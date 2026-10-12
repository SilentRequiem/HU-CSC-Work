import SwiftUI

/// Quiz Me opened from the Study tab, so practicing isn't tied to the Speak Note sheet.
/// Reuses `QuizMeSection` and `QuizMeViewModel`, so questions come from the same shared study
/// guide and answers go through the same grader as in Speak Note.
struct QuizMeScreen: View {
    @State private var viewModel = QuizMeViewModel(
        recognizer: SpeechRecognitionService(),
        synthesizer: SpeechSynthesisService()
    )

    var body: some View {
        ScrollView {
            QuizMeSection(viewModel: viewModel)
                .padding()
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Quiz Me")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        // Never leave the microphone or speech running after leaving the screen.
        .onDisappear { viewModel.stopAll() }
    }
}

#Preview {
    NavigationStack {
        QuizMeScreen()
    }
    .environment(NotesViewModel())
    .environment(StudyViewModel())
    .environment(AppNavigationModel())
}
