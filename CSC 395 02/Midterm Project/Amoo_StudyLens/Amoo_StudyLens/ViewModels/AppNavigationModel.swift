import Foundation
import Observation

// MARK: - Navigation architecture
//
// Before this type existed, navigation state was implicit and scattered:
//   • the Study tab's NavigationStack had no path, so pushes were owned by `NavigationLink`s
//     embedded in content that was torn down and rebuilt (availability changes, `.id(guide.id)`);
//   • pushed screens closed themselves with `dismiss()`, whose meaning depends on where the view
//     happens to be hosted (pop in Study, close the whole sheet in Speak Note);
//   • Quiz Me and Flashcards could be opened even when no guide existed.
//
// `AppNavigationModel` is now the *only* place that decides what is on screen:
//   • `selectedTab`   – which tab is showing (TabView(selection:)).
//   • `notesPath`     – the Notes tab's stack (Note Detail screens, by note ID).
//   • `studyPath`     – the Study tab's stack (NavigationStack(path:)). Only Study screens live here.
//   • `brainMapPath`  – the Brain Map tab's stack; holds Concept Detail screens opened from the map.
//   • `activeCapture` – the one Capture sheet that is presented (Scan, Write, Speak, Import).
//
// Each value has exactly one writer per user action, so generating a guide (which only changes
// `StudyViewModel`) can never change a destination, and Speak Note can only appear when the user
// taps it on the Capture screen.

/// The app's top-level tabs.
enum AppTab: Hashable {
    case capture
    case notes
    case study
    case brainMap
}

/// Screens pushed onto the Study tab's navigation stack.
enum StudyDestination: Hashable {
    case quizMe
    case flashcards
    /// The multi-select list used by the Selected Notes study source.
    case chooseNotes
    /// Concept details with the optional Wikipedia Learn More, from Key Concepts or a Key Concept flashcard.
    case concept(StudyConcept)
}

@MainActor
@Observable
final class AppNavigationModel {
    var selectedTab: AppTab = .capture
    /// Bound to the Notes tab's `NavigationStack(path:)`. Holds note *IDs* (not note values), so
    /// an edited note keeps the same path entry and Note Detail always shows the saved version.
    var notesPath: [UUID] = []
    /// Bound to the Study tab's `NavigationStack(path:)`.
    var studyPath: [StudyDestination] = []
    /// Bound to the Brain Map tab's `NavigationStack(path:)`. Concept details opened from a map
    /// node are pushed here, so they stay on the Brain Map tab instead of jumping to Study.
    var brainMapPath: [StudyConcept] = []
    /// The Capture sheet currently presented, if any. Set only by an explicit user action.
    var activeCapture: CaptureOption?
    /// A drop onto the Capture screen, waiting for the Import File sheet to pick it up.
    private(set) var pendingImport: PendingImport?

    enum PendingImport: Equatable {
        case file(URL)
        /// Something that isn't a file (text, a web link…) was dropped; the sheet explains why.
        case unsupportedDrop
    }

    // MARK: Tabs

    /// Switches tabs without touching any tab's stack, so each tab comes back exactly as it was left.
    func show(_ tab: AppTab) {
        selectedTab = tab
    }

    // MARK: Notes

    /// Opens Note Detail on the Notes tab. Never stacks a second copy of the same note.
    func openNote(_ id: UUID) {
        Self.push(id, onto: &notesPath)
    }

    /// Leaves Note Detail for `id` (e.g. after the note is deleted) and returns to the list.
    func closeNote(_ id: UUID) {
        if let index = notesPath.firstIndex(of: id) {
            notesPath.removeSubrange(index...)
        }
    }

    /// Removes Note Detail screens whose notes no longer exist, so the stack never shows a deleted note.
    func forgetDeletedNotes(keeping existingIDs: Set<UUID>) {
        if let index = notesPath.firstIndex(where: { !existingIDs.contains($0) }) {
            notesPath.removeSubrange(index...)
        }
    }

    // MARK: Study

    /// Pushes a Study screen. If that screen is already in the stack (a double tap, or reopening
    /// a concept that's already open further down), returns to it instead of stacking a duplicate.
    func openStudy(_ destination: StudyDestination) {
        Self.push(destination, onto: &studyPath)
    }

    /// Returns from the top Study screen to the one beneath it.
    func popStudy() {
        guard !studyPath.isEmpty else { return }
        studyPath.removeLast()
    }

    /// Shows the Study tab at its root, e.g. after "Study This Note" from the Notes tab.
    func showStudyRoot() {
        studyPath.removeAll()
        selectedTab = .study
    }

    // MARK: Brain Map

    /// Opens Concept Detail for a map node on the Brain Map tab's own stack.
    func openBrainMapConcept(_ concept: StudyConcept) {
        Self.push(concept, onto: &brainMapPath)
    }

    // MARK: Capture

    func presentCapture(_ option: CaptureOption) {
        activeCapture = option
    }

    /// Opens a Capture sheet from anywhere (empty-state buttons, macOS menu commands). The sheets
    /// live on the Capture tab, so that tab is shown first; other tabs' stacks are left untouched.
    func beginCapture(_ option: CaptureOption) {
        selectedTab = .capture
        activeCapture = option
    }

    // MARK: Helpers

    /// Shared push rule for every stack: a destination already in the stack is popped back to,
    /// never pushed a second time.
    private static func push<Element: Equatable>(_ element: Element, onto path: inout [Element]) {
        if let index = path.firstIndex(of: element) {
            path.removeSubrange(path.index(after: index)...)
        } else {
            path.append(element)
        }
    }

    /// Opens the Import File sheet already loaded with a dropped file (nil = not a file).
    func beginImport(of url: URL?) {
        pendingImport = url.map(PendingImport.file) ?? .unsupportedDrop
        activeCapture = .importFile
    }

    /// Hands the drop to the Import File screen exactly once.
    func takePendingImport() -> PendingImport? {
        defer { pendingImport = nil }
        return pendingImport
    }
}
