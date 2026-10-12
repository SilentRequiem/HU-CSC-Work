import SwiftUI

/// Dictate Note: record, watch the live transcript, then edit the title and text before saving.
struct DictateNoteSection: View {
    @Bindable var viewModel: DictateNoteViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SpeakCard(title: "Record", systemImage: "mic") {
                RecordButton(
                    isRecording: viewModel.isRecording,
                    isStarting: viewModel.isStarting,
                    action: viewModel.toggleRecording
                )
                .padding(.vertical, 8)

                if let errorMessage = viewModel.errorMessage {
                    SpeakMessageLabel(message: errorMessage)
                }

                Text(viewModel.transcript.isEmpty
                     ? "Tap the microphone and start talking. Your words appear below as you speak."
                     : "Tap the microphone again to keep adding to this note.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            SpeakCard(title: "Transcript", systemImage: "text.quote") {
                transcriptArea

                HStack {
                    Text("\(wordCount) \(wordCount == 1 ? "word" : "words")")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Button("Clear", systemImage: "trash", role: .destructive) {
                        viewModel.clearTranscript()
                    }
                    .font(.footnote)
                    .buttonStyle(.borderless)
                    .disabled(viewModel.transcript.isEmpty || viewModel.isRecording)
                }
            }

            if !viewModel.transcript.isEmpty {
                SpeakCard(title: "Title", systemImage: "textformat") {
                    TextField("Note title", text: $viewModel.title)
                        .textFieldStyle(.roundedBorder)
                    Text("StudyLens suggests a title from your first sentence. Edit it if you like, then tap Save Note.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    @ViewBuilder
    private var transcriptArea: some View {
        if viewModel.isRecording {
            // Live, read-only view while speech is streaming in.
            Text(viewModel.transcript.isEmpty ? "Listening…" : viewModel.transcript)
                .foregroundStyle(viewModel.transcript.isEmpty ? .secondary : .primary)
                .frame(maxWidth: .infinity, minHeight: 180, alignment: .topLeading)
                .padding(12)
                .background(.background, in: .rect(cornerRadius: 12))
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(.red.opacity(0.6), lineWidth: 2)
                }
                .animation(.default, value: viewModel.transcript)
        } else {
            TextEditor(text: $viewModel.transcript)
                .frame(minHeight: 180)
                .scrollContentBackground(.hidden)
                .padding(8)
                .background(.background, in: .rect(cornerRadius: 12))
                .overlay(alignment: .topLeading) {
                    if viewModel.transcript.isEmpty {
                        Text("Your transcript will appear here.")
                            .foregroundStyle(.tertiary)
                            .padding(16)
                            .allowsHitTesting(false)
                    }
                }
        }
    }

    private var wordCount: Int {
        viewModel.transcript.split(whereSeparator: \.isWhitespace).count
    }
}
