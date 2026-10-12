import Foundation

/// The way a note entered StudyLens. Each source maps to a capture pipeline
/// (Vision text recognition, speech recognition, PencilKit handwriting, file import, Wikipedia).
enum NoteSource: String, CaseIterable, Codable, Identifiable {
    case scan
    case voice
    case handwriting
    case typed
    /// Text extracted from an imported file (PDF, Office document, image, text, CSV).
    case imported
    /// External information the user explicitly saved from a Wikipedia article (Learn More).
    /// Never created automatically; see `ConceptEnrichmentViewModel.saveAsNote`.
    case wikipedia

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .scan: "Scanned"
        case .voice: "Voice"
        case .handwriting: "Handwritten"
        case .typed: "Typed"
        case .imported: "Imported"
        case .wikipedia: "Wikipedia"
        }
    }

    var systemImage: String {
        switch self {
        case .scan: "doc.viewfinder"
        case .voice: "waveform"
        case .handwriting: "pencil.and.scribble"
        case .typed: "keyboard"
        case .imported: "square.and.arrow.down"
        case .wikipedia: "globe"
        }
    }
}

/// Where an externally sourced note came from (currently only Wikipedia articles), so the
/// note always keeps its attribution and a link back to the original page.
struct ExternalSourceInfo: Hashable, Codable {
    /// The article's title on Wikipedia, e.g. "Mitochondrion".
    var articleTitle: String
    /// The article's web page. Nil only if Wikipedia returned a URL that couldn't be parsed.
    var url: URL?
}

/// A single captured study note.
struct StudyNote: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var body: String
    var source: NoteSource
    var createdAt: Date
    /// The original file's name, type, and size (pages/slides/sheets) for `.imported` notes.
    var importInfo: ImportedFileInfo?
    /// The article title and link for `.wikipedia` notes.
    var externalSource: ExternalSourceInfo?

    init(
        id: UUID = UUID(),
        title: String,
        body: String,
        source: NoteSource,
        createdAt: Date = .now,
        importInfo: ImportedFileInfo? = nil,
        externalSource: ExternalSourceInfo? = nil
    ) {
        self.id = id
        self.title = title
        self.body = body
        self.source = source
        self.createdAt = createdAt
        self.importInfo = importInfo
        self.externalSource = externalSource
    }
}
