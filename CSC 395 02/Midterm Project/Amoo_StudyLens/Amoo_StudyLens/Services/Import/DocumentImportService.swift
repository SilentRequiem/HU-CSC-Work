import Foundation

/// The single entry point for turning a file into study text.
///
///     URL ──► ImportFileKind.detect ──► format-specific extractor ──► ImportedDocument
///
/// | Format            | Framework / technique                                            |
/// |-------------------|------------------------------------------------------------------|
/// | PNG / JPEG / HEIC | ImageIO decode → Vision OCR (`VisionTextRecognizer`, same as Scan) |
/// | PDF               | PDFKit embedded text; Vision OCR for image-only pages            |
/// | TXT / Markdown    | Foundation string decoding (UTF-8, UTF-16, Windows/Latin-1)      |
/// | CSV               | `CSVParser` → `TabularTextFormatter`                             |
/// | DOCX / PPTX / XLSX| `ZipArchiveReader` (Compression) → `XMLParser` → `OfficeDocumentExtractor` |
///
/// All work runs off the main actor (`@concurrent`) so large files never freeze the UI, and
/// progress is reported through a callback for the Import File screen's progress bar.
nonisolated struct DocumentImportService {
    /// The saved note keeps at most this much text. The study-guide prompt uses a much smaller,
    /// fairly shared budget (`StudyAnalysisService.maxMaterialCharacters`), but keeping more here
    /// means the user can still read, export, and pick from the full material.
    static let maxStoredCharacters = 150_000

    /// Extracts reviewable study text from the file at `url`.
    /// - Parameter progress: Called (on a background thread) as extraction advances.
    @concurrent
    func importDocument(at url: URL, progress: @escaping @Sendable (ImportProgress) -> Void) async throws -> ImportedDocument {
        let filename = url.lastPathComponent
        guard let kind = ImportFileKind.detect(url: url) else {
            throw ImportError.unsupportedFile(filename: filename)
        }

        // Files from the picker (and on macOS, drops) are security-scoped; borrow access while reading.
        let isScoped = url.startAccessingSecurityScopedResource()
        defer { if isScoped { url.stopAccessingSecurityScopedResource() } }

        progress(ImportProgress(fractionCompleted: nil, message: "Reading \(kind.displayName.lowercased())…"))

        var document: ImportedDocument
        do {
            document = try await extract(kind: kind, from: url, filename: filename, progress: progress)
        } catch ImportError.unreadable(_, let reason) {
            // Office XML parsing doesn't know the file's name; report the real one, not "document".
            throw ImportError.unreadable(filename: filename, reason: reason)
        } catch let error as ImportError {
            throw error
        } catch is CancellationError {
            throw CancellationError()
        } catch let error as TextRecognitionError {
            throw ImportError.unreadable(filename: filename, reason: error.localizedDescription)
        } catch {
            throw ImportError.unreadable(filename: filename, reason: error.localizedDescription)
        }

        let trimmed = document.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw ImportError.noText(filename: filename) }

        var text = trimmed
        if text.count > Self.maxStoredCharacters {
            text = String(text.prefix(Self.maxStoredCharacters))
            document.notices.append("The file was very long, so only the first \(Self.maxStoredCharacters.formatted()) characters were imported.")
        }
        progress(ImportProgress(fractionCompleted: 1, message: "Done"))
        return ImportedDocument(info: document.info, text: text, notices: document.notices)
    }

    // MARK: - Format dispatch

    private func extract(kind: ImportFileKind, from url: URL, filename: String,
                         progress: @escaping @Sendable (ImportProgress) -> Void) async throws -> ImportedDocument {
        switch kind {
        case .image:
            // Same pipeline as Scan Image: ImageIO decode (EXIF-upright, downsampled) → Vision OCR.
            let data = try Data(contentsOf: url)
            guard let image = await ScanNoteViewModel.decodeImage(from: data) else {
                throw ImportError.unreadable(filename: filename, reason: "It isn't a supported image.")
            }
            progress(ImportProgress(fractionCompleted: nil, message: "Recognizing text with Vision…"))
            let text = try await VisionTextRecognizer().recognizeText(in: image)
            return ImportedDocument(info: ImportedFileInfo(filename: filename, kind: .image, unitCount: nil), text: text,
                                    notices: ["Text was recognized with Vision OCR. Check it for mistakes before saving."])

        case .pdf:
            let result = try await PDFTextExtractor().extract(from: url, progress: progress)
            var notices: [String] = []
            if result.ocrPageCount > 0 {
                notices.append("\(result.ocrPageCount) of \(result.pageCount) \(result.pageCount == 1 ? "page was" : "pages were") scanned images and read with Vision OCR. Check them for mistakes.")
            }
            return ImportedDocument(info: ImportedFileInfo(filename: filename, kind: .pdf, unitCount: result.pageCount),
                                    text: result.text, notices: notices)

        case .plainText, .markdown:
            let text = try Self.decodeText(Data(contentsOf: url), filename: filename)
            let lines = text.split(whereSeparator: \.isNewline).count
            return ImportedDocument(info: ImportedFileInfo(filename: filename, kind: kind, unitCount: lines), text: text)

        case .csv:
            let text = try Self.decodeText(Data(contentsOf: url), filename: filename)
            let formatted = TabularTextFormatter.format(rows: CSVParser.parse(text))
            return ImportedDocument(info: ImportedFileInfo(filename: filename, kind: .csv, unitCount: formatted.rowCount),
                                    text: formatted.text)

        case .word:
            let result = try OfficeDocumentExtractor.extractWord(from: Data(contentsOf: url))
            return ImportedDocument(info: ImportedFileInfo(filename: filename, kind: .word, unitCount: result.paragraphCount),
                                    text: result.text)

        case .powerPoint:
            let result = try OfficeDocumentExtractor.extractPowerPoint(from: Data(contentsOf: url)) { current, total in
                progress(ImportProgress(fractionCompleted: Double(current) / Double(max(total, 1)),
                                        message: "Reading slide \(current) of \(total)…"))
            }
            return ImportedDocument(info: ImportedFileInfo(filename: filename, kind: .powerPoint, unitCount: result.slideCount),
                                    text: result.text)

        case .excel:
            let result = try OfficeDocumentExtractor.extractExcel(from: Data(contentsOf: url)) { current, total in
                progress(ImportProgress(fractionCompleted: Double(current) / Double(max(total, 1)),
                                        message: "Reading sheet \(current) of \(total)…"))
            }
            return ImportedDocument(info: ImportedFileInfo(filename: filename, kind: .excel, unitCount: result.sheetCount),
                                    text: result.text, notices: result.notices)
        }
    }

    /// Decodes text files that may not be UTF-8 (older Windows exports are often CP-1252).
    static func decodeText(_ data: Data, filename: String) throws -> String {
        if data.starts(with: [0xFF, 0xFE]) || data.starts(with: [0xFE, 0xFF]),
           let text = String(data: data, encoding: .utf16) {
            return text
        }
        if let text = String(data: data, encoding: .utf8) {
            // Drop a UTF-8 byte-order mark if present.
            return text.hasPrefix("\u{FEFF}") ? String(text.dropFirst()) : text
        }
        if let text = String(data: data, encoding: .windowsCP1252) ?? String(data: data, encoding: .isoLatin1) {
            return text
        }
        throw ImportError.unreadable(filename: filename, reason: "Its text encoding isn't supported.")
    }
}
