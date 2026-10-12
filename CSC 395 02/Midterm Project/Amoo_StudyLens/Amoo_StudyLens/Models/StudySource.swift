import Foundation

// MARK: - Study source architecture
//
// A study guide is always generated from an explicit *scope* of notes, chosen by the user:
//
//   StudyScope (what the user has picked on the Study screen; may change at any time)
//        │  resolve(in: notes)
//        ▼
//   [StudyNote] ──► StudyAnalysisService.makeStudyMaterial ──► Foundation Models ──► StudyAnalysis
//        │
//        ▼
//   StudySource (an immutable snapshot stored with the generated guide)
//
// Quiz Me, Flashcards, and Brain Map all read the *same* `GeneratedStudyGuide`, so they share one
// scope and never call Foundation Models themselves. The snapshot records exactly which notes
// (and which versions of them) the guide came from, so later edits or deletions can be detected
// and the guide marked outdated instead of silently presenting stale material.

/// The three ways a user can choose study material.
enum StudyScopeKind: String, CaseIterable, Identifiable, Hashable {
    case allNotes
    case selectedNotes
    case singleNote

    var id: String { rawValue }

    var title: String {
        switch self {
        case .allNotes: "All Notes"
        case .selectedNotes: "Selected Notes"
        case .singleNote: "Single Note"
        }
    }

    var systemImage: String {
        switch self {
        case .allNotes: "square.stack.3d.up"
        case .selectedNotes: "checklist"
        case .singleNote: "doc.text"
        }
    }
}

/// The user's current choice of study material on the Study screen.
enum StudyScope: Hashable {
    /// Every saved note, combined into one study set.
    case allNotes
    /// Only the notes the user ticked.
    case selectedNotes(Set<UUID>)
    /// One note, usually chosen with "Study This Note" on the note's detail screen.
    case singleNote(UUID)

    var kind: StudyScopeKind {
        switch self {
        case .allNotes: .allNotes
        case .selectedNotes: .selectedNotes
        case .singleNote: .singleNote
        }
    }

    /// The saved notes this scope refers to, oldest first (the order they're sent to the model).
    func resolve(in notes: [StudyNote]) -> [StudyNote] {
        let matching: [StudyNote]
        switch self {
        case .allNotes:
            matching = notes
        case .selectedNotes(let ids):
            matching = notes.filter { ids.contains($0.id) }
        case .singleNote(let id):
            matching = notes.filter { $0.id == id }
        }
        return matching.sorted { $0.createdAt < $1.createdAt }
    }

    /// Drops references to notes that no longer exist. A single-note scope whose note was deleted
    /// falls back to All Notes so the Study screen never points at nothing.
    func pruned(keeping existingIDs: Set<UUID>) -> StudyScope {
        switch self {
        case .allNotes:
            return .allNotes
        case .selectedNotes(let ids):
            return .selectedNotes(ids.intersection(existingIDs))
        case .singleNote(let id):
            return existingIDs.contains(id) ? self : .allNotes
        }
    }
}

/// An immutable record of the notes a study guide was generated from.
struct StudySource: Equatable {
    let kind: StudyScopeKind
    /// Source note IDs in the order they were sent to the model.
    let noteIDs: [UUID]
    let noteTitles: [String]
    /// A content fingerprint per note, so edits (not just deletions) mark the guide outdated.
    /// Guides only live while the app runs, so Swift's per-launch hash seeding is fine here.
    let fingerprints: [UUID: Int]

    init(kind: StudyScopeKind, notes: [StudyNote]) {
        self.kind = kind
        noteIDs = notes.map(\.id)
        noteTitles = notes.map(\.title)
        fingerprints = Dictionary(uniqueKeysWithValues: notes.map { ($0.id, Self.fingerprint(of: $0)) })
    }

    var noteIDSet: Set<UUID> { Set(noteIDs) }

    /// The scope that would regenerate this same study set.
    var scope: StudyScope {
        switch kind {
        case .allNotes: .allNotes
        case .selectedNotes: .selectedNotes(noteIDSet)
        case .singleNote: noteIDs.first.map(StudyScope.singleNote) ?? .allNotes
        }
    }
    var noteCount: Int { noteIDs.count }

    /// e.g. "All Notes · 8 notes", "Selected Notes · 3 notes", "Single Note · Photosynthesis".
    var summary: String {
        if kind == .singleNote, let title = noteTitles.first {
            return "\(kind.title) · \(title)"
        }
        return "\(kind.title) · \(noteCount) \(noteCount == 1 ? "note" : "notes")"
    }

    /// Up to three source titles, e.g. "Photosynthesis, Cell Parts, and 2 more".
    var titlesDescription: String {
        Self.describeTitles(noteTitles)
    }

    static func describeTitles(_ titles: [String], limit: Int = 3) -> String {
        guard titles.count > limit else { return titles.formatted(.list(type: .and)) }
        return titles.prefix(limit).joined(separator: ", ") + ", and \(titles.count - limit) more"
    }

    static func fingerprint(of note: StudyNote) -> Int {
        var hasher = Hasher()
        hasher.combine(note.title)
        hasher.combine(note.body)
        return hasher.finalize()
    }

    /// Why the guide no longer matches the saved notes, or nil if it's still current.
    func outdatedReason(comparedWith notes: [StudyNote]) -> String? {
        let current = Dictionary(uniqueKeysWithValues: notes.map { ($0.id, $0) })

        let deletedCount = noteIDs.count { current[$0] == nil }
        if deletedCount > 0 {
            return deletedCount == 1
                ? "A note used by this study guide was deleted."
                : "\(deletedCount) notes used by this study guide were deleted."
        }

        let editedCount = noteIDs.count { id in
            current[id].map { Self.fingerprint(of: $0) != fingerprints[id] } ?? false
        }
        if editedCount > 0 {
            return editedCount == 1
                ? "A note used by this study guide was changed."
                : "\(editedCount) notes used by this study guide were changed."
        }

        // Only an All Notes guide is affected by new notes; a hand-picked set is still accurate.
        if kind == .allNotes {
            let addedCount = notes.count { !noteIDSet.contains($0.id) }
            if addedCount > 0 {
                return "\(addedCount) new \(addedCount == 1 ? "note was" : "notes were") added since this study guide was generated."
            }
        }
        return nil
    }
}
