import AVFoundation
import Observation

/// Wraps AVSpeechSynthesizer so views don't talk to AVFoundation directly.
/// Publishes speaking/paused state and the word currently being spoken.
@MainActor
@Observable
final class SpeechManager: NSObject, AVSpeechSynthesizerDelegate {
    /// AVSpeechSynthesizer → the object that actually speaks
    private let synthesizer = AVSpeechSynthesizer()

    private(set) var isSpeaking = false
    private(set) var isPaused = false

    /// The text being spoken and the range of the current word, used for highlighting.
    private(set) var spokenText = ""
    private(set) var currentWordRange: NSRange?

    /// All U.S. English voices installed on the device, best quality first.
    let availableVoices: [AVSpeechSynthesisVoice] = AVSpeechSynthesisVoice.speechVoices()
        .filter { $0.language == "en-US" }
        .sorted {
            if $0.quality != $1.quality { return $0.quality.rawValue > $1.quality.rawValue }
            return $0.name < $1.name
        }

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ text: String, voiceIdentifier: String?, rate: Float, pitch: Float) {
        // Start fresh if something is already playing.
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }

        // AVSpeechUtterance → represents the sentence to be spoken
        let utterance = AVSpeechUtterance(string: text)

        // Use the picked voice, otherwise fall back to the default U.S. English voice.
        // AVSpeechSynthesisVoice(language: "en-US") → selects an English U.S. voice
        if let voiceIdentifier, let voice = AVSpeechSynthesisVoice(identifier: voiceIdentifier) {
            utterance.voice = voice
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        }
        utterance.rate = rate
        utterance.pitchMultiplier = pitch

        spokenText = text
        currentWordRange = nil

        // synthesizer.speak(utterance) → starts text-to-speech
        synthesizer.speak(utterance)
    }

    func pause() {
        synthesizer.pauseSpeaking(at: .word)
    }

    func resume() {
        synthesizer.continueSpeaking()
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }

    // MARK: - AVSpeechSynthesizerDelegate
    // Delegate callbacks may arrive off the main actor, so hop back before touching state.

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        Task { @MainActor in
            self.isSpeaking = true
            self.isPaused = false
        }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                                       willSpeakRangeOfSpeechString characterRange: NSRange,
                                       utterance: AVSpeechUtterance) {
        Task { @MainActor in self.currentWordRange = characterRange }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        Task { @MainActor in self.isPaused = true }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        Task { @MainActor in self.isPaused = false }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        let stillSpeaking = synthesizer.isSpeaking
        Task { @MainActor in self.finish(stillSpeaking: stillSpeaking) }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        let stillSpeaking = synthesizer.isSpeaking
        Task { @MainActor in self.finish(stillSpeaking: stillSpeaking) }
    }

    /// Resets state when an utterance ends, unless a new one has already started.
    private func finish(stillSpeaking: Bool) {
        guard !stillSpeaking else { return }
        isSpeaking = false
        isPaused = false
        currentWordRange = nil
    }
}
