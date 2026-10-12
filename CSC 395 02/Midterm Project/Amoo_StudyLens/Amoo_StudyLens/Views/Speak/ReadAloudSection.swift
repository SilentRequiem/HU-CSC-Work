import SwiftUI

/// Listen / Read Aloud: choose a saved note and have AVSpeechSynthesizer read it,
/// with the word currently being spoken highlighted.
struct ReadAloudSection: View {
    @Bindable var viewModel: ReadAloudViewModel
    @Environment(NotesViewModel.self) private var notesViewModel

    private var notes: [StudyNote] { notesViewModel.sortedNotes }

    var body: some View {
        if notes.isEmpty {
            ContentUnavailableView(
                "No Saved Notes",
                systemImage: "speaker.slash",
                description: Text("Save a note with Scan, Write, or Dictate, then come back to hear it read aloud.")
            )
        } else {
            VStack(alignment: .leading, spacing: 16) {
                notePicker

                if let note = viewModel.selectedNote(in: notes) {
                    noteText(for: note)
                    controls(for: note)
                }
                rateSlider
            }
            .onAppear { viewModel.ensureSelection(in: notes) }
            .onChange(of: notes) { viewModel.ensureSelection(in: notes) }
        }
    }

    private var notePicker: some View {
        SpeakCard(title: "Note", systemImage: "note.text") {
            Picker("Note to read", selection: $viewModel.selectedNoteID) {
                ForEach(notes) { note in
                    Label(note.title, systemImage: note.source.systemImage)
                        .tag(Optional(note.id))
                }
            }
            .pickerStyle(.menu)
            .onChange(of: viewModel.selectedNoteID) { viewModel.selectionChanged() }
        }
    }

    private func noteText(for note: StudyNote) -> some View {
        SpeakCard(title: viewModel.isSpeaking ? "Reading Aloud" : "Text", systemImage: viewModel.isSpeaking ? "speaker.wave.2.fill" : "text.alignleft") {
            Group {
                if viewModel.isSpeaking {
                    Text(highlightedText)
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(note.title).font(.headline)
                        Text(note.body)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: true)
            .textSelection(.enabled)
        }
    }

    private func controls(for note: StudyNote) -> some View {
        HStack(spacing: 12) {
            Button {
                viewModel.play(note)
            } label: {
                Label(viewModel.isSpeaking ? "Restart" : "Play",
                      systemImage: viewModel.isSpeaking ? "arrow.counterclockwise" : "play.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)

            Button {
                viewModel.togglePause()
            } label: {
                Label(viewModel.isPaused ? "Resume" : "Pause",
                      systemImage: viewModel.isPaused ? "play.circle" : "pause.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(!viewModel.isSpeaking)

            Button(role: .destructive) {
                viewModel.stop()
            } label: {
                Label("Stop", systemImage: "stop.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(!viewModel.isSpeaking)
        }
        .controlSize(.large)
    }

    private var rateSlider: some View {
        SpeakCard(title: "Speed", systemImage: "gauge.with.dots.needle.50percent") {
            HStack {
                Image(systemName: "tortoise.fill").foregroundStyle(.secondary)
                    .accessibilityHidden(true)
                Slider(
                    value: $viewModel.rate,
                    in: SpeechSynthesisService.minimumRate...SpeechSynthesisService.maximumRate
                )
                .tint(.orange)
                .accessibilityLabel("Reading speed")
                Image(systemName: "hare.fill").foregroundStyle(.secondary)
                    .accessibilityHidden(true)
            }
            Text(viewModel.isSpeaking ? "The new speed applies when you tap Restart." : "Adjust how fast StudyLens reads.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }

    /// The spoken text with the current word highlighted (from the TTS assignment).
    private var highlightedText: AttributedString {
        let synthesizer = viewModel.synthesizer
        let text = synthesizer.spokenText
        guard let nsRange = synthesizer.currentWordRange,
              let range = Range(nsRange, in: text) else {
            return AttributedString(text)
        }

        var before = AttributedString(text[..<range.lowerBound])
        var word = AttributedString(text[range])
        let after = AttributedString(text[range.upperBound...])

        before.foregroundColor = .secondary
        word.backgroundColor = .orange.opacity(0.35)
        word.font = .body.bold()

        return before + word + after
    }
}
