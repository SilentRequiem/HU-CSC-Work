import SwiftUI

/// The large microphone button shared by Dictate and Quiz Me.
/// Red with a pulsing waveform while recording so the state is obvious at a glance.
struct RecordButton: View {
    let isRecording: Bool
    var isStarting = false
    var startTitle = "Start Recording"
    var stopTitle = "Stop Recording"
    let action: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            Button(action: action) {
                ZStack {
                    Circle()
                        .fill(isRecording ? Color.red.gradient : Color.orange.gradient)
                        .frame(width: 88, height: 88)
                        .shadow(color: (isRecording ? Color.red : Color.orange).opacity(0.4), radius: isRecording ? 14 : 6)

                    if isStarting {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                            .font(.system(size: 34, weight: .semibold))
                            .foregroundStyle(.white)
                            .contentTransition(.symbolEffect(.replace))
                    }
                }
            }
            .buttonStyle(.plain)
            .disabled(isStarting)
            .accessibilityLabel(isRecording ? stopTitle : startTitle)
            .accessibilityHint(isRecording ? "Stops the microphone." : "Starts listening with the microphone.")
            .accessibilityValue(isStarting ? "Starting" : (isRecording ? "Recording" : ""))

            Text(isRecording ? stopTitle : startTitle)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(isRecording ? .red : .primary)

            if isRecording {
                RecordingIndicator()
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.snappy, value: isRecording)
    }
}

/// "Listening…" label with an animated waveform, shown only while the microphone is live.
struct RecordingIndicator: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Label("Listening…", systemImage: "waveform")
            .font(.footnote.weight(.semibold))
            .foregroundStyle(.red)
            // The "Listening…" text already shows the state, so Reduce Motion can drop the pulse.
            .symbolEffect(.variableColor.iterative, options: .repeating, isActive: !reduceMotion)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.red.opacity(0.12), in: .capsule)
    }
}

/// A titled card matching the Study screen's section style.
struct SpeakCard<Content: View>: View {
    let title: String
    let systemImage: String
    var tint: Color = .orange
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: systemImage)
                .font(.headline)
                .foregroundStyle(tint)
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.background.secondary, in: .rect(cornerRadius: 16))
    }
}

/// A friendly inline error or notice.
struct SpeakMessageLabel: View {
    let message: String
    var systemImage = "exclamationmark.triangle"
    var tint: Color = .studyLensWarning

    var body: some View {
        Label(message, systemImage: systemImage)
            .font(.subheadline)
            .foregroundStyle(tint)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// A speech or microphone error plus the practical next step: Open Settings when a permission
/// was denied, and (in Quiz Me) Type Instead when the microphone can't be used at all.
struct SpeechErrorView: View {
    let message: String
    let error: SpeechRecognitionError?
    /// When set and the error means the microphone can't be used, shows a Type Instead button.
    var onTypeInstead: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SpeakMessageLabel(message: message)

            let showsTyping = onTypeInstead != nil && error?.suggestsTyping == true
            if error?.settingsLink != nil || showsTyping {
                HStack(spacing: 10) {
                    if let link = error?.settingsLink {
                        OpenSettingsButton(link: link)
                    }
                    if showsTyping, let onTypeInstead {
                        Button("Type Instead", systemImage: "keyboard", action: onTypeInstead)
                            .buttonStyle(.bordered)
                    }
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        RecordButton(isRecording: false) {}
        RecordButton(isRecording: true) {}
    }
    .padding()
}
