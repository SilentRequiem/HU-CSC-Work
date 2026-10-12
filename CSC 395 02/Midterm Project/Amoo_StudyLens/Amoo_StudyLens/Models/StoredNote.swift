import Foundation
import SwiftData

/// SwiftData record for one saved note.
///
/// The rest of the app keeps working with the `StudyNote` value type; this class only exists
/// so notes can be written to disk. `SwiftDataNoteStore` converts between the two.
@Model
final class StoredNote {
    @Attribute(.unique) var id: UUID
    var title: String
    var body: String
    /// `NoteSource.rawValue` (scan, voice, handwriting, typed, imported). Stored as text so new sources
    /// can be added later without a schema migration.
    var sourceRawValue: String
    var createdAt: Date
    // Imported-file metadata. Optional, so SwiftData migrates existing stores automatically
    // (older notes simply have nil here). Only metadata is stored, never the file itself.
    var importFilename: String?
    var importKindRawValue: String?
    var importUnitCount: Int?

    init(note: StudyNote) {
        id = note.id
        title = note.title
        body = note.body
        sourceRawValue = note.source.rawValue
        createdAt = note.createdAt
        importFilename = note.importInfo?.filename
        importKindRawValue = note.importInfo?.kind.rawValue
        importUnitCount = note.importInfo?.unitCount
    }

    /// Copies editable fields from a note with the same ID.
    func update(from note: StudyNote) {
        if title != note.title { title = note.title }
        if body != note.body { body = note.body }
        if sourceRawValue != note.source.rawValue { sourceRawValue = note.source.rawValue }
        if createdAt != note.createdAt { createdAt = note.createdAt }
        if importFilename != note.importInfo?.filename { importFilename = note.importInfo?.filename }
        if importKindRawValue != note.importInfo?.kind.rawValue { importKindRawValue = note.importInfo?.kind.rawValue }
        if importUnitCount != note.importInfo?.unitCount { importUnitCount = note.importInfo?.unitCount }
    }

    var studyNote: StudyNote {
        StudyNote(
            id: id,
            title: title,
            body: body,
            // An unknown value can only come from a future version; show it as typed text.
            source: NoteSource(rawValue: sourceRawValue) ?? .typed,
            createdAt: createdAt,
            importInfo: importInfo
        )
    }

    private var importInfo: ImportedFileInfo? {
        guard let importFilename, let kind = importKindRawValue.flatMap(ImportFileKind.init(rawValue:)) else { return nil }
        return ImportedFileInfo(filename: importFilename, kind: kind, unitCount: importUnitCount)
    }
}
