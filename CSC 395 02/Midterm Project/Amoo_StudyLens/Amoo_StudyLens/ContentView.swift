import SwiftUI

/// Root tab-based interface for StudyLens.
///
/// State ownership (each object is created once here and shared through the environment):
///   • `NotesViewModel`      – saved notes (SwiftData).
///   • `StudyViewModel`      – study scope + the generated guide shared by Study, Quiz Me,
///                             Flashcards, and Brain Map. Lives above the TabView, so switching
///                             tabs never destroys the guide.
///   • `AppNavigationModel`  – the selected tab, the Study stack's path, and the active Capture
///                             sheet. The only place navigation state is stored.
struct ContentView: View {
    @State private var notesViewModel: NotesViewModel
    @State private var studyViewModel = StudyViewModel()
    @State private var navigation = AppNavigationModel()

    /// The app passes a SwiftData-backed view model; previews use the in-memory default.
    init(notesViewModel: NotesViewModel? = nil) {
        _notesViewModel = State(initialValue: notesViewModel ?? NotesViewModel())
    }

    var body: some View {
        TabView(selection: $navigation.selectedTab) {
            Tab("Capture", systemImage: "camera.viewfinder", value: .capture) {
                CaptureView()
            }
            Tab("Notes", systemImage: "note.text", value: .notes) {
                NotesListView()
            }
            Tab("Study", systemImage: "graduationcap", value: .study) {
                StudyView()
            }
            Tab("Brain Map", systemImage: "brain.head.profile", value: AppTab.brainMap) {
                BrainMapView()
            }
        }
        .environment(notesViewModel)
        .environment(studyViewModel)
        .environment(navigation)
        // Deleting or changing notes (or a guide finishing after its notes were deleted) updates
        // the shared study state: the scope forgets deleted notes, and a guide with no remaining
        // source notes is cleared. Partially affected guides are kept and shown as outdated.
        .onChange(of: notesViewModel.notes) {
            studyViewModel.reconcile(with: notesViewModel.notes)
            // A deleted note's detail screen is closed, so the Notes stack never shows it.
            navigation.forgetDeletedNotes(keeping: Set(notesViewModel.notes.map(\.id)))
        }
        .onChange(of: studyViewModel.guide?.id) {
            studyViewModel.reconcile(with: notesViewModel.notes)
            navigation.closeConceptDetails()
        }
        // Lets the app's menu commands (macOS menu bar, iPad keyboard) reach this window's navigation.
        .focusedSceneValue(\.appNavigation, navigation)
    }
}

#Preview {
    ContentView()
}
