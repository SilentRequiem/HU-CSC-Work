import SwiftUI
import AVFoundation

struct ContentView: View {
    /// @State textInput → stores whatever you type
    @State private var textInput: String = ""
    @State private var speech = SpeechManager()
    @State private var selectedVoiceID: String? = AVSpeechSynthesisVoice(language: "en-US")?.identifier
    @State private var rate: Float = AVSpeechUtteranceDefaultSpeechRate
    @State private var pitch: Float = 1.0

    private var trimmedText: String {
        textInput.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(red: 0.29, green: 0.16, blue: 0.62),
                         Color(red: 0.10, green: 0.45, blue: 0.80)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    header

                    // Input card
                    VStack(alignment: .leading, spacing: 16) {
                        textArea

                        HStack {
                            Text("\(textInput.count) characters")
                            Spacer()
                            if !textInput.isEmpty && !speech.isSpeaking {
                                Button("Clear", systemImage: "xmark.circle.fill") {
                                    textInput = ""
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))

                        voicePicker

                        voiceSlider(title: "Speed", icon: "hare.fill",
                                    value: $rate,
                                    range: AVSpeechUtteranceMinimumSpeechRate...AVSpeechUtteranceMaximumSpeechRate)
                        voiceSlider(title: "Pitch", icon: "tuningfork",
                                    value: $pitch, range: 0.5...2.0)
                    }
                    .padding(20)
                    .background(.ultraThinMaterial.opacity(0.6), in: .rect(cornerRadius: 24))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(.white.opacity(0.25), lineWidth: 1)
                    )

                    controls
                }
                .padding(24)
                .frame(maxWidth: 600)
                .frame(maxWidth: .infinity)
            }
        }
    }

    // MARK: - Subviews

    private var header: some View {
        VStack(spacing: 8) {
            Image(systemName: speech.isSpeaking ? "waveform" : "waveform.circle.fill")
                .font(.system(size: 56, weight: .semibold))
                .foregroundStyle(.white)
                .symbolEffect(.variableColor.iterative, isActive: speech.isSpeaking && !speech.isPaused)
                .contentTransition(.symbolEffect(.replace))
                .frame(height: 64)

            Text("Speak Up")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundStyle(.white)

            Text(statusText)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
                .contentTransition(.opacity)
        }
        .padding(.top, 20)
        .animation(.easeInOut, value: speech.isSpeaking)
        .animation(.easeInOut, value: speech.isPaused)
    }

    private var statusText: String {
        if speech.isPaused { return "Paused" }
        if speech.isSpeaking { return "Speaking…" }
        return "Type something and hear it out loud"
    }

    /// Editable while idle; while speaking, shows the text with the current word highlighted.
    @ViewBuilder
    private var textArea: some View {
        Group {
            if speech.isSpeaking {
                ScrollView {
                    Text(highlightedText)
                        .font(.body)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 8)
                }
            } else {
                ZStack(alignment: .topLeading) {
                    if textInput.isEmpty {
                        Text("Enter text to speak…")
                            .foregroundStyle(.white.opacity(0.5))
                            .padding(.horizontal, 5)
                            .padding(.vertical, 8)
                    }
                    TextEditor(text: $textInput)
                        .scrollContentBackground(.hidden)
                        .foregroundStyle(.white)
                        .font(.body)
                }
            }
        }
        .frame(minHeight: 120, maxHeight: 200)
        .padding(12)
        .background(.white.opacity(0.12), in: .rect(cornerRadius: 16))
    }

    /// Builds the spoken text with the word currently being read highlighted.
    private var highlightedText: AttributedString {
        let text = speech.spokenText
        guard let nsRange = speech.currentWordRange,
              let range = Range(nsRange, in: text) else {
            return AttributedString(text)
        }

        var before = AttributedString(text[..<range.lowerBound])
        var word = AttributedString(text[range])
        var after = AttributedString(text[range.upperBound...])

        before.foregroundColor = .white.opacity(0.6)
        word.foregroundColor = .white
        word.backgroundColor = .pink.opacity(0.7)
        word.font = .body.bold()
        after.foregroundColor = .white

        return before + word + after
    }

    private var voicePicker: some View {
        HStack {
            Label("Voice", systemImage: "person.wave.2.fill")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white)
            Spacer()
            Picker("Voice", selection: $selectedVoiceID) {
                ForEach(speech.availableVoices, id: \.identifier) { voice in
                    Text(displayName(for: voice)).tag(Optional(voice.identifier))
                }
            }
            .labelsHidden()
            .tint(.white)
            .disabled(speech.isSpeaking)
        }
    }

    private func displayName(for voice: AVSpeechSynthesisVoice) -> String {
        switch voice.quality {
        case .premium: return "\(voice.name) (Premium)"
        case .enhanced: return "\(voice.name) (Enhanced)"
        default: return voice.name
        }
    }

    private var controls: some View {
        HStack(spacing: 12) {
            // Pause / Resume, only while speaking
            if speech.isSpeaking {
                Button {
                    speech.isPaused ? speech.resume() : speech.pause()
                } label: {
                    Image(systemName: speech.isPaused ? "play.fill" : "pause.fill")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(width: 56, height: 56)
                        .background(.white.opacity(0.2), in: .circle)
                        .overlay(Circle().stroke(.white.opacity(0.3), lineWidth: 1))
                        .contentTransition(.symbolEffect(.replace))
                }
                .buttonStyle(.plain)
                .accessibilityLabel(speech.isPaused ? "Resume" : "Pause")
                .transition(.scale.combined(with: .opacity))
            }

            speakButton
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: speech.isSpeaking)
    }

    private var speakButton: some View {
        Button {
            if speech.isSpeaking {
                speech.stop()
            } else {
                speech.speak(trimmedText, voiceIdentifier: selectedVoiceID, rate: rate, pitch: pitch)
            }
        } label: {
            Label(speech.isSpeaking ? "Stop" : "Speak",
                  systemImage: speech.isSpeaking ? "stop.fill" : "speaker.wave.2.fill")
                .font(.system(.title3, design: .rounded, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .foregroundStyle(.white)
                .background(
                    LinearGradient(
                        colors: speech.isSpeaking
                            ? [.red, .orange]
                            : [.pink, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    in: .capsule
                )
                .shadow(color: .black.opacity(0.3), radius: 10, y: 5)
        }
        .buttonStyle(.plain)
        .disabled(trimmedText.isEmpty && !speech.isSpeaking)
        .opacity(trimmedText.isEmpty && !speech.isSpeaking ? 0.5 : 1)
    }

    private func voiceSlider(title: String, icon: String,
                             value: Binding<Float>, range: ClosedRange<Float>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(title, systemImage: icon)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white)
            Slider(value: value, in: range)
                .tint(.pink)
                .disabled(speech.isSpeaking)
        }
    }
}

#Preview {
    ContentView()
}
