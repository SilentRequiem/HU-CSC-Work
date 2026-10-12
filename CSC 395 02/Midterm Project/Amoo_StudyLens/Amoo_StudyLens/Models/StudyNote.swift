import Foundation

/// The way a note entered StudyLens. Each source maps to a capture pipeline
/// (Vision text recognition, speech recognition, PencilKit handwriting, file import).
enum NoteSource: String, CaseIterable, Codable, Identifiable {
    case scan
    case voice
    case handwriting
    case typed
    /// Text extracted from an imported file (PDF, Office document, image, text, CSV).
    case imported

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .scan: "Scanned"
        case .voice: "Voice"
        case .handwriting: "Handwritten"
        case .typed: "Typed"
        case .imported: "Imported"
        }
    }

    var systemImage: String {
        switch self {
        case .scan: "doc.viewfinder"
        case .voice: "waveform"
        case .handwriting: "pencil.and.scribble"
        case .typed: "keyboard"
        case .imported: "square.and.arrow.down"
        }
    }
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

    init(
        id: UUID = UUID(),
        title: String,
        body: String,
        source: NoteSource,
        createdAt: Date = .now,
        importInfo: ImportedFileInfo? = nil
    ) {
        self.id = id
        self.title = title
        self.body = body
        self.source = source
        self.createdAt = createdAt
        self.importInfo = importInfo
    }
}
