import SwiftUI

/// The Speak Note screen: Dictate Note, Listen / Read Aloud, and Recite / Quiz Me.
/// All speech work lives in `SpeakNoteViewModel` and its services; this view only presents state.
struct SpeakNoteView: View {
    @Environment(NotesViewModel.self) private var notesViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = SpeakNoteViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    modePicker
                    modeHeader

                    switch viewModel.mode {
                    case .dictate:
                        DictateNoteSection(viewModel: viewModel.dictation)
                    case .listen:
                        ReadAloudSection(viewModel: viewModel.readAloud)
                    case .quiz:
                        QuizMeSection(viewModel: viewModel.quiz)
                    }
                }
                .padding()
                .readableContentWidth(720)
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Speak Note")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(viewModel.mode == .dictate ? "Cancel" : "Done") { close() }
                }
                if viewModel.mode == .dictate {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save Note") {
                            // SAVE AS .voice: same shared NotesViewModel as Scan Image and
                            // Write Note, so the note appears in Notes and feeds the Study Guide.
                            notesViewModel.add(viewModel.dictation.makeNote())
                            close()
                        }
                        .disabled(!viewModel.dictation.canSave)
                    }
                }
            }
        }
        .studyLensSheetFrame()
        // Never leave the microphone or speech running after the sheet closes.
        .onDisappear { viewModel.stopAudio() }
    }

    private func close() {
        viewModel.stopAudio()
        dismiss()
    }

    private var modePicker: some View {
        Picker("Mode", selection: Binding(
            get: { viewModel.mode },
            set: { viewModel.switchMode(to: $0) }
        )) {
            ForEach(SpeakNoteMode.allCases) { mode in
                Label(mode.title, systemImage: mode.systemImage).tag(mode)
            }
        }
        .pickerStyle(.segmented)
        .labelsHidden()
    }

    /// Makes the current mode obvious even after scrolling past the picker.
    private var modeHeader: some View {
        HStack(spacing: 14) {
            Image(systemName: viewModel.mode.systemImage)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(Color.orange.gradient, in: .rect(cornerRadius: 12))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.mode.headline)
                    .font(.title3.bold())
                Text(viewModel.mode.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    SpeakNoteView()
        .environment(NotesViewModel())
        .environment(StudyViewModel())
}
