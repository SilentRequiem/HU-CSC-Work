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
//   • `studyPath`     – the Study tab's stack (NavigationStack(path:)). Only Study screens live here.
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
}

@MainActor
@Observable
final class AppNavigationModel {
    var selectedTab: AppTab = .capture
    /// Bound to the Study tab's `NavigationStack(path:)`.
    var studyPath: [StudyDestination] = []
    /// The Capture sheet currently presented, if any. Set only by an explicit user action.
    var activeCapture: CaptureOption?
    /// A drop onto the Capture screen, waiting for the Import File sheet to pick it up.
    private(set) var pendingImport: PendingImport?

    enum PendingImport: Equatable {
        case file(URL)
        /// Something that isn't a file (text, a web link…) was dropped; the sheet explains why.
        case unsupportedDrop
    }

    // MARK: Study

    /// Pushes a Study screen. Ignores a repeat of the screen already on top (e.g. a double tap).
    func openStudy(_ destination: StudyDestination) {
        guard studyPath.last != destination else { return }
        studyPath.append(destination)
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

    // MARK: Capture

    func presentCapture(_ option: CaptureOption) {
        activeCapture = option
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
