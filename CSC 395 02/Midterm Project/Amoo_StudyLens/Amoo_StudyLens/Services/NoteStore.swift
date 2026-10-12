import Foundation
import SwiftData

/// Abstraction over where notes are kept, so view models don't depend on the storage technology.
/// The app uses `SwiftDataNoteStore`; previews use `InMemoryNoteStore`.
protocol NoteStore {
    func loadNotes() throws -> [StudyNote]
    /// Makes storage match `notes` exactly: inserts new notes, updates changed ones,
    /// and removes notes that are no longer in the list.
    func save(_ notes: [StudyNote]) throws
}

/// Simple storage that keeps notes only for the lifetime of the app session.
final class InMemoryNoteStore: NoteStore {
    private var notes: [StudyNote] = []

    init(notes: [StudyNote] = []) {
        self.notes = notes
    }

    func loadNotes() throws -> [StudyNote] {
        notes
    }

    func save(_ notes: [StudyNote]) throws {
        self.notes = notes
    }
}

/// Persists notes on device with SwiftData, so they survive quitting and relaunching the app.
final class SwiftDataNoteStore: NoteStore {
    private let container: ModelContainer
    private var context: ModelContext { container.mainContext }

    /// Opens (or creates) the on-disk note store in the app's sandboxed Application Support folder.
    init() throws {
        let configuration = ModelConfiguration("StudyLensNotes")
        container = try ModelContainer(for: StoredNote.self, configurations: configuration)
    }

    func loadNotes() throws -> [StudyNote] {
        let descriptor = FetchDescriptor<StoredNote>(sortBy: [SortDescriptor(\.createdAt)])
        return try context.fetch(descriptor).map(\.studyNote)
    }

    func save(_ notes: [StudyNote]) throws {
        let stored = try context.fetch(FetchDescriptor<StoredNote>())
        let storedByID = Dictionary(stored.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        let keepIDs = Set(notes.map(\.id))

        // Only notes the user deleted reach this point; nothing else is ever removed.
        for record in stored where !keepIDs.contains(record.id) {
            context.delete(record)
        }
        for note in notes {
            if let record = storedByID[note.id] {
                record.update(from: note)
            } else {
                context.insert(StoredNote(note: note))
            }
        }

        if context.hasChanges {
            try context.save()
        }
    }
}
