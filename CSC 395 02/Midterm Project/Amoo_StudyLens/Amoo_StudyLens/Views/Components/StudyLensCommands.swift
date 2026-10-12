import SwiftUI

extension FocusedValues {
    /// The focused window's navigation model, published by `ContentView`.
    @Entry var appNavigation: AppNavigationModel?
}

/// Menu-bar commands (and iPad hardware-keyboard shortcuts): switch tabs and start a capture.
/// Every command goes through `AppNavigationModel`, the same path as tapping in the app, so
/// shortcuts can't put navigation into a state the UI couldn't reach.
struct StudyLensCommands: Commands {
    @FocusedValue(\.appNavigation) private var navigation

    var body: some Commands {
        CommandGroup(after: .newItem) {
            Group {
                Button("Import File…") { navigation?.beginCapture(.importFile) }
                    .keyboardShortcut("o", modifiers: .command)
                Button("Scan Image…") { navigation?.beginCapture(.scanImage) }
                    .keyboardShortcut("n", modifiers: [.command, .shift])
                Button("Write Note…") { navigation?.beginCapture(.writeNote) }
                Button("Speak Note…") { navigation?.beginCapture(.speakNote) }
            }
            // No StudyLens window is focused (e.g. all windows closed on macOS).
            .disabled(navigation == nil)
        }

        CommandMenu("Go") {
            Group {
                Button("Capture") { navigation?.show(.capture) }
                    .keyboardShortcut("1", modifiers: .command)
                Button("Notes") { navigation?.show(.notes) }
                    .keyboardShortcut("2", modifiers: .command)
                Button("Study") { navigation?.show(.study) }
                    .keyboardShortcut("3", modifiers: .command)
                Button("Brain Map") { navigation?.show(.brainMap) }
                    .keyboardShortcut("4", modifiers: .command)
            }
            .disabled(navigation == nil)
        }
    }
}
