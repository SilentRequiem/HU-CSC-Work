import Foundation
import Observation

/// Owns the list of captured notes and is shared across tabs through the environment.
/// Every change is written through `NoteStore`, so saved notes survive relaunching the app.
@MainActor
@Observable
final class NotesViewModel {
    private(set) var notes: [StudyNote] = []
    /// Set when notes couldn't be loaded from or written to disk.
    private(set) var persistenceErrorMessage: String?
    /// Set for the whole session when on-device storage couldn't be opened at all.
    private(set) var storageWarning: String?

    @ObservationIgnored
    private let store: NoteStore

    /// Without a store, notes are kept in memory only (used by previews).
    init(store: NoteStore? = nil) {
        let store = store ?? InMemoryNoteStore()
        self.store = store
        do {
            notes = try store.loadNotes()
        } catch {
            persistenceErrorMessage = "Your saved notes couldn't be loaded. \(error.localizedDescription)"
        }
    }

    /// The app's view model, backed by on-device SwiftData storage. If the store can't be opened,
    /// notes are still kept for this session and the Notes screen explains why they won't persist.
    static func makePersistent() -> NotesViewModel {
        do {
            return NotesViewModel(store: try SwiftDataNoteStore())
        } catch {
            let viewModel = NotesViewModel()
            viewModel.storageWarning = "Notes can't be saved on this device right now, so they'll only be kept until StudyLens closes. \(error.localizedDescription)"
            return viewModel
        }
    }

    /// Notes sorted newest first for display.
    var sortedNotes: [StudyNote] {
        notes.sorted { $0.createdAt > $1.createdAt }
    }

    /// The notes with the given IDs, newest first.
    func notes(withIDs ids: Set<UUID>) -> [StudyNote] {
        sortedNotes.filter { ids.contains($0.id) }
    }

    /// The saved version of a note, or nil if it has been deleted.
    func note(withID id: UUID) -> StudyNote? {
        notes.first { $0.id == id }
    }

    func add(_ note: StudyNote) {
        notes.append(note)
        persist()
    }

    /// Saves an edited note (matched by ID). Does nothing — and writes nothing to disk — if the
    /// note was deleted meanwhile or nothing actually changed.
    func update(_ note: StudyNote) {
        guard let index = notes.firstIndex(where: { $0.id == note.id }), notes[index] != note else { return }
        notes[index] = note
        persist()
    }

    func delete(_ note: StudyNote) {
        delete(ids: [note.id])
    }

    func delete(ids: Set<UUID>) {
        notes.removeAll { ids.contains($0.id) }
        persist()
    }

    /// Removes every saved note. Callers confirm with the user first.
    func deleteAll() {
        notes.removeAll()
        persist()
    }

    private func persist() {
        do {
            try store.save(notes)
            persistenceErrorMessage = nil
        } catch {
            persistenceErrorMessage = "Your latest changes couldn't be saved. \(error.localizedDescription)"
        }
    }
}
