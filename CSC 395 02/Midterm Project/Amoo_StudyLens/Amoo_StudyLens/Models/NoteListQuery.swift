import Foundation

/// How the Notes tab orders notes.
enum NoteSortOrder: String, CaseIterable, Identifiable {
    case newest
    case oldest
    case title

    var id: String { rawValue }

    var title: String {
        switch self {
        case .newest: "Newest First"
        case .oldest: "Oldest First"
        case .title: "Title (A–Z)"
        }
    }

    var systemImage: String {
        switch self {
        case .newest: "arrow.down"
        case .oldest: "arrow.up"
        case .title: "textformat"
        }
    }
}

/// The Notes tab's search text, source filter, and sort order, applied to the saved notes.
///
/// A plain value with no UI or storage dependencies, so it's easy to check on its own and can
/// never change what's saved: it only decides which notes are *shown* and in what order.
struct NoteListQuery: Equatable {
    var searchText = ""
    /// Sources to show. Empty means every source (no filter).
    var sources: Set<NoteSource> = []
    var sortOrder: NoteSortOrder = .newest

    /// True when search or a source filter hides some notes (sorting alone hides nothing).
    var isFiltering: Bool {
        !trimmedSearch.isEmpty || !sources.isEmpty
    }

    private var trimmedSearch: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// The notes to display: matching the search (title or body) and source filter, in sort order.
    func apply(to notes: [StudyNote]) -> [StudyNote] {
        let terms = trimmedSearch.split(whereSeparator: \.isWhitespace).map(String.init)
        let matching = notes.filter { note in
            (sources.isEmpty || sources.contains(note.source)) && Self.note(note, matchesAll: terms)
        }
        return sorted(matching)
    }

    /// Every search word must appear in the title or body (case- and accent-insensitive),
    /// so "cell atp" finds a note mentioning both, in any order.
    private static func note(_ note: StudyNote, matchesAll terms: [String]) -> Bool {
        terms.allSatisfy { term in
            note.title.localizedStandardContains(term) || note.body.localizedStandardContains(term)
        }
    }

    private func sorted(_ notes: [StudyNote]) -> [StudyNote] {
        switch sortOrder {
        case .newest:
            notes.sorted { $0.createdAt > $1.createdAt }
        case .oldest:
            notes.sorted { $0.createdAt < $1.createdAt }
        case .title:
            notes.sorted { lhs, rhs in
                let order = lhs.title.localizedStandardCompare(rhs.title)
                // Notes with the same title stay in a stable, newest-first order.
                return order == .orderedSame ? lhs.createdAt > rhs.createdAt : order == .orderedAscending
            }
        }
    }

    /// "12 notes", or "3 of 12 notes" while search or a filter hides some.
    func countDescription(shown: Int, total: Int) -> String {
        let noun = total == 1 ? "note" : "notes"
        return isFiltering ? "\(shown) of \(total) \(noun)" : "\(total) \(noun)"
    }
}
