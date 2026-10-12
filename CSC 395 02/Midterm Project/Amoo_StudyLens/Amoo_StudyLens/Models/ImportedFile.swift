import Foundation
import UniformTypeIdentifiers

// MARK: - Import File models
//
// StudyLens imports *study text*, not files. Every supported format is turned into plain text
// by `DocumentImportService`, the user reviews/corrects it, and it is saved as an ordinary
// `StudyNote` (source `.imported`). Only lightweight metadata about the original file is kept
// (`ImportedFileInfo`); the file itself is never copied into SwiftData.

/// The file formats StudyLens can extract study text from.
nonisolated enum ImportFileKind: String, CaseIterable, Codable, Sendable {
    case image
    case pdf
    case plainText
    case markdown
    case csv
    case word
    case powerPoint
    case excel

    var displayName: String {
        switch self {
        case .image: "Image"
        case .pdf: "PDF Document"
        case .plainText: "Plain Text"
        case .markdown: "Markdown"
        case .csv: "CSV Spreadsheet"
        case .word: "Word Document"
        case .powerPoint: "PowerPoint Presentation"
        case .excel: "Excel Workbook"
        }
    }

    var systemImage: String {
        switch self {
        case .image: "photo"
        case .pdf: "doc.richtext"
        case .plainText: "doc.plaintext"
        case .markdown: "text.document"
        case .csv: "tablecells"
        case .word: "doc.text"
        case .powerPoint: "rectangle.on.rectangle"
        case .excel: "tablecells.badge.ellipsis"
        }
    }

    /// e.g. "12 pages", "8 slides", "3 sheets", or nil for formats without natural units.
    func unitDescription(count: Int?) -> String? {
        guard let count else { return nil }
        let (singular, plural): (String, String) = switch self {
        case .pdf: ("page", "pages")
        case .powerPoint: ("slide", "slides")
        case .excel: ("sheet", "sheets")
        case .csv: ("row", "rows")
        case .word: ("paragraph", "paragraphs")
        case .plainText, .markdown: ("line", "lines")
        case .image: ("image", "images")
        }
        return "\(count) \(count == 1 ? singular : plural)"
    }

    // MARK: Detection

    /// Office Open XML type identifiers (declared by the system, so `UTType(_:)` resolves them).
    static let wordType = UTType("org.openxmlformats.wordprocessingml.document") ?? UTType(filenameExtension: "docx") ?? .data
    static let powerPointType = UTType("org.openxmlformats.presentationml.presentation") ?? UTType(filenameExtension: "pptx") ?? .data
    static let excelType = UTType("org.openxmlformats.spreadsheetml.sheet") ?? UTType(filenameExtension: "xlsx") ?? .data
    static let markdownType = UTType("net.daringfireball.markdown") ?? UTType(filenameExtension: "md") ?? .plainText

    /// Content types offered by the system file picker.
    static let allowedContentTypes: [UTType] = [
        .png, .jpeg, .heic, .heif,
        .pdf,
        .plainText, markdownType,
        .commaSeparatedText,
        wordType, powerPointType, excelType
    ]

    /// Human-readable list used in drop-zone hints and rejection messages.
    static let supportedFormatsDescription = "PDF, Word (DOCX), PowerPoint (PPTX), Excel (XLSX), CSV, TXT, Markdown, PNG, JPEG, or HEIC"

    /// Works out the format from a file's extension (most reliable for dropped/temporary copies),
    /// falling back to its declared content type. Returns nil for anything unsupported.
    static func detect(url: URL) -> ImportFileKind? {
        switch url.pathExtension.lowercased() {
        case "png", "jpg", "jpeg", "heic", "heif": return .image
        case "pdf": return .pdf
        case "txt", "text": return .plainText
        case "md", "markdown", "mdown": return .markdown
        case "csv": return .csv
        case "docx": return .word
        case "pptx": return .powerPoint
        case "xlsx": return .excel
        default: break
        }

        guard let type = (try? url.resourceValues(forKeys: [.contentTypeKey]))?.contentType else { return nil }
        if type.conforms(to: wordType) { return .word }
        if type.conforms(to: powerPointType) { return .powerPoint }
        if type.conforms(to: excelType) { return .excel }
        if type.conforms(to: .pdf) { return .pdf }
        if type.conforms(to: .commaSeparatedText) { return .csv }
        if type.conforms(to: markdownType) { return .markdown }
        if type.conforms(to: .png) || type.conforms(to: .jpeg) || type.conforms(to: .heic) || type.conforms(to: .heif) { return .image }
        if type.conforms(to: .plainText) { return .plainText }
        return nil
    }
}

/// Metadata about the original file an imported note came from. Stored alongside the note;
/// the file's bytes are not.
nonisolated struct ImportedFileInfo: Hashable, Codable, Sendable {
    var filename: String
    var kind: ImportFileKind
    /// Pages (PDF), slides (PPTX), sheets (XLSX), rows (CSV), and so on. See `ImportFileKind.unitDescription`.
    var unitCount: Int?

    /// e.g. "PowerPoint Presentation · 8 slides".
    var summary: String {
        [kind.displayName, kind.unitDescription(count: unitCount)].compactMap(\.self).joined(separator: " · ")
    }
}

/// The result of extracting text from one file, before the user reviews it.
nonisolated struct ImportedDocument: Sendable {
    let info: ImportedFileInfo
    let text: String
    /// Non-fatal notes for the user, e.g. "3 pages were read with Vision OCR."
    var notices: [String] = []
}

/// Progress reported while a larger file is being extracted.
nonisolated struct ImportProgress: Sendable, Equatable {
    /// 0...1 when the total amount of work is known (e.g. pages), otherwise nil.
    var fractionCompleted: Double?
    var message: String
}

/// User-facing import failures.
nonisolated enum ImportError: LocalizedError, Sendable {
    case unsupportedFile(filename: String)
    case unreadable(filename: String, reason: String)
    case noText(filename: String)
    case passwordProtected(filename: String)

    var errorDescription: String? {
        switch self {
        case .unsupportedFile(let filename):
            "“\(filename)” isn't a supported file type. StudyLens can import \(ImportFileKind.supportedFormatsDescription) files."
        case .unreadable(let filename, let reason):
            "“\(filename)” couldn't be read. \(reason)"
        case .noText(let filename):
            "No study text was found in “\(filename)”."
        case .passwordProtected(let filename):
            "“\(filename)” is password protected. Remove the password and try again."
        }
    }
}
