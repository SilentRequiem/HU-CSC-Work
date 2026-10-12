import SwiftUI

@main struct MyApp: App {
    /// Created once per launch; loads saved notes from on-device SwiftData storage.
    @State private var notesViewModel = NotesViewModel.makePersistent()

    var body: some Scene {
        WindowGroup {
            ContentView(notesViewModel: notesViewModel)
        }
        .commands {
            StudyLensCommands()
        }
    }
}
