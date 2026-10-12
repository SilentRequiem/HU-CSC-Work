import Foundation
import Compression

/// A minimal, read-only ZIP reader for Office Open XML files (DOCX, PPTX, XLSX).
///
/// Why this exists instead of a package: Office files are ZIP archives of XML parts. Apple has no
/// public "unzip" API on iOS, but the ZIP container is a simple, documented format, and every
/// Office part is either *stored* (method 0) or *deflated* (method 8). The `Compression`
/// framework's `COMPRESSION_ZLIB` algorithm decodes raw DEFLATE (RFC 1951) natively, so the whole
/// pipeline uses Apple frameworks only and adds no third-party dependency.
///
/// How it works:
///   1. Find the End Of Central Directory record at the end of the file.
///   2. Read the central directory: one entry per file with its name, sizes, method, and offset.
///   3. To read an entry, skip its local header and decompress exactly `compressedSize` bytes.
/// Sizes come from the central directory, which is always authoritative (local headers may
/// defer sizes to a trailing data descriptor).
///
/// Not supported (and reported as errors rather than misread): encrypted entries, ZIP64 archives
/// (> 4 GB or > 65,535 entries), and compression methods other than stored/deflate.
nonisolated struct ZipArchiveReader {
    struct Entry {
        let path: String
        let method: UInt16
        let flags: UInt16
        let compressedSize: Int
        let uncompressedSize: Int
        let localHeaderOffset: Int
    }

    enum ZipError: LocalizedError {
        case notAZipArchive
        case unsupported(String)
        case corrupt(String)
        case missingEntry(String)

        var errorDescription: String? {
            switch self {
            case .notAZipArchive: "The file isn't a valid Office document (it isn't a ZIP package)."
            case .unsupported(let detail): "This document uses a feature StudyLens can't read: \(detail)."
            case .corrupt(let detail): "The document appears to be damaged (\(detail))."
            case .missingEntry(let path): "The document is missing an expected part (\(path))."
            }
        }
    }

    /// Guards against "zip bombs": no single XML part in a normal study document comes close.
    static let maxEntrySize = 200 * 1024 * 1024

    private let data: Data
    /// Entries keyed by their path inside the archive, e.g. "word/document.xml".
    let entries: [String: Entry]

    init(data: Data) throws {
        self.data = data
        entries = try Self.readCentralDirectory(in: data)
    }

    func contains(_ path: String) -> Bool { entries[path] != nil }

    /// Returns the decompressed bytes of one archive entry.
    func data(for path: String) throws -> Data {
        guard let entry = entries[path] else { throw ZipError.missingEntry(path) }
        if entry.flags & 0x1 != 0 { throw ZipError.unsupported("password-protected content") }
        guard entry.uncompressedSize <= Self.maxEntrySize else { throw ZipError.unsupported("an extremely large embedded part") }

        // Local file header: fixed 30 bytes, then the file name and an extra field whose lengths
        // can differ from the central directory's copy, so they're read from here.
        let header = entry.localHeaderOffset
        guard try readUInt32(at: header) == 0x04034b50 else { throw ZipError.corrupt("bad local header for \(path)") }
        let nameLength = Int(try readUInt16(at: header + 26))
        let extraLength = Int(try readUInt16(at: header + 28))
        let start = header + 30 + nameLength + extraLength
        let end = start + entry.compressedSize
        guard start >= 0, end <= data.count else { throw ZipError.corrupt("truncated entry \(path)") }
        let compressed = data.subdata(in: start..<end)

        switch entry.method {
        case 0: // Stored: the bytes are already uncompressed.
            return compressed
        case 8: // Deflate: decode with the Compression framework.
            return try Self.inflate(compressed, expectedSize: entry.uncompressedSize)
        default:
            throw ZipError.unsupported("compression method \(entry.method)")
        }
    }

    // MARK: - Central directory

    private static func readCentralDirectory(in data: Data) throws -> [String: Entry] {
        // The End Of Central Directory record is 22 bytes plus an optional comment of up to 64 KB,
        // so search backwards from the end for its signature.
        guard data.count >= 22 else { throw ZipError.notAZipArchive }
        let reader = ByteReader(data: data)
        let searchStart = max(0, data.count - 22 - 65_535)
        var eocd: Int?
        var index = data.count - 22
        while index >= searchStart {
            if try reader.uint32(at: index) == 0x06054b50 { eocd = index; break }
            index -= 1
        }
        guard let eocd else { throw ZipError.notAZipArchive }

        let entryCount = Int(try reader.uint16(at: eocd + 10))
        let directorySize = Int(try reader.uint32(at: eocd + 12))
        let directoryOffset = Int(try reader.uint32(at: eocd + 16))
        if entryCount == 0xFFFF || directoryOffset == 0xFFFF_FFFF {
            throw ZipError.unsupported("ZIP64 (very large) packages")
        }
        guard directoryOffset + directorySize <= data.count else { throw ZipError.corrupt("central directory out of range") }

        var entries: [String: Entry] = [:]
        var offset = directoryOffset
        for _ in 0..<entryCount {
            guard try reader.uint32(at: offset) == 0x02014b50 else { throw ZipError.corrupt("bad central directory entry") }
            let flags = try reader.uint16(at: offset + 8)
            let method = try reader.uint16(at: offset + 10)
            let compressedSize = Int(try reader.uint32(at: offset + 20))
            let uncompressedSize = Int(try reader.uint32(at: offset + 24))
            let nameLength = Int(try reader.uint16(at: offset + 28))
            let extraLength = Int(try reader.uint16(at: offset + 30))
            let commentLength = Int(try reader.uint16(at: offset + 32))
            let localHeaderOffset = Int(try reader.uint32(at: offset + 42))
            guard offset + 46 + nameLength <= data.count else { throw ZipError.corrupt("entry name out of range") }

            let nameData = data.subdata(in: (offset + 46)..<(offset + 46 + nameLength))
            // Bit 11 marks UTF-8 names; Office always writes ASCII part names, so either decodes.
            let path = String(decoding: nameData, as: UTF8.self)
            if compressedSize == 0xFFFF_FFFF || uncompressedSize == 0xFFFF_FFFF || localHeaderOffset == 0xFFFF_FFFF {
                throw ZipError.unsupported("ZIP64 (very large) packages")
            }
            entries[path] = Entry(
                path: path, method: method, flags: flags,
                compressedSize: compressedSize, uncompressedSize: uncompressedSize,
                localHeaderOffset: localHeaderOffset
            )
            offset += 46 + nameLength + extraLength + commentLength
        }
        return entries
    }

    // MARK: - Inflate

    /// Decompresses raw DEFLATE data. `COMPRESSION_ZLIB` in Apple's Compression framework is raw
    /// DEFLATE (RFC 1951) with no zlib header, which is exactly the ZIP method-8 format.
    private static func inflate(_ compressed: Data, expectedSize: Int) throws -> Data {
        guard expectedSize > 0 else { return Data() }
        var output = Data(count: expectedSize)
        let decodedCount = output.withUnsafeMutableBytes { (destination: UnsafeMutableRawBufferPointer) -> Int in
            compressed.withUnsafeBytes { (source: UnsafeRawBufferPointer) -> Int in
                guard let destinationBase = destination.bindMemory(to: UInt8.self).baseAddress,
                      let sourceBase = source.bindMemory(to: UInt8.self).baseAddress else { return 0 }
                return compression_decode_buffer(
                    destinationBase, expectedSize,
                    sourceBase, compressed.count,
                    nil, COMPRESSION_ZLIB
                )
            }
        }
        guard decodedCount == expectedSize else { throw ZipError.corrupt("an entry didn't decompress fully") }
        return output
    }

    // MARK: - Little-endian helpers

    private func readUInt16(at offset: Int) throws -> UInt16 { try ByteReader(data: data).uint16(at: offset) }
    private func readUInt32(at offset: Int) throws -> UInt32 { try ByteReader(data: data).uint32(at: offset) }

    private struct ByteReader {
        let data: Data

        func uint16(at offset: Int) throws -> UInt16 {
            guard offset >= 0, offset + 2 <= data.count else { throw ZipError.corrupt("read past end of file") }
            let base = data.startIndex + offset
            return UInt16(data[base]) | UInt16(data[base + 1]) << 8
        }

        func uint32(at offset: Int) throws -> UInt32 {
            guard offset >= 0, offset + 4 <= data.count else { throw ZipError.corrupt("read past end of file") }
            let base = data.startIndex + offset
            return UInt32(data[base]) | UInt32(data[base + 1]) << 8 | UInt32(data[base + 2]) << 16 | UInt32(data[base + 3]) << 24
        }
    }
}
