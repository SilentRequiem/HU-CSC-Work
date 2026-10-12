import Foundation
import AVFoundation
import Observation

/// Text prepared for reading aloud. Building scripts here (instead of in views) means the
/// same speech service can read notes now and study-guide sections later.
struct SpeechScript: Equatable {
    /// What the synthesizer says. Word highlighting ranges refer to this string.
    let text: String

    /// A saved note: its title, a short pause, then the body.
    static func note(_ note: StudyNote) -> SpeechScript {
        SpeechScript(text: "\(note.title).\n\n\(note.body)")
    }

    /// A generated study-guide summary.
    static func summary(_ analysis: StudyAnalysis) -> SpeechScript {
        SpeechScript(text: "Summary. \(analysis.summary)")
    }

    /// A practice question, optionally followed by its expected answer.
    static func question(_ item: PracticeQuestion, number: Int? = nil, includeAnswer: Bool = false) -> SpeechScript {
        var text = number.map { "Question \($0). " } ?? ""
        text += item.question
        if includeAnswer {
            text += "\n\nAnswer. \(item.answer)"
        }
        return SpeechScript(text: text)
    }
}

/// Wraps AVSpeechSynthesizer so views and view models don't talk to AVFoundation directly.
/// Adapted from the text-to-speech assignment's `SpeechManager`: publishes speaking/paused
/// state and the word currently being spoken.
@MainActor
@Observable
final class SpeechSynthesisService: NSObject, AVSpeechSynthesizerDelegate {
    /// Slowest, default, and fastest rates offered by the speed slider.
    nonisolated static let minimumRate = AVSpeechUtteranceMinimumSpeechRate
    nonisolated static let defaultRate = AVSpeechUtteranceDefaultSpeechRate
    nonisolated static let maximumRate = min(AVSpeechUtteranceMaximumSpeechRate, 0.65)

    /// AVSpeechSynthesizer → the object that actually speaks.
    @ObservationIgnored
    private let synthesizer = AVSpeechSynthesizer()

    private(set) var isSpeaking = false
    private(set) var isPaused = false

    /// The text being spoken and the range of the current word, used for highlighting.
    private(set) var spokenText = ""
    private(set) var currentWordRange: NSRange?

    /// Called once when the current script finishes on its own (not when stopped).
    @ObservationIgnored
    private var onFinish: (() -> Void)?

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    /// Speaks a script from the beginning, replacing anything already playing.
    func speak(_ script: SpeechScript, rate: Float = SpeechSynthesisService.defaultRate, onFinish: (() -> Void)? = nil) {
        let text = script.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        if synthesizer.isSpeaking {
            self.onFinish = nil
            synthesizer.stopSpeaking(at: .immediate)
        }

        #if os(iOS) || os(visionOS)
        configureAudioSessionForPlayback()
        #endif

        // AVSpeechUtterance → represents the text to be spoken.
        let utterance = AVSpeechUtterance(string: text)
        // Match the user's language when a voice exists, otherwise U.S. English.
        utterance.voice = AVSpeechSynthesisVoice(language: Locale.current.identifier(.bcp47))
            ?? AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = min(max(rate, Self.minimumRate), Self.maximumRate)
        utterance.postUtteranceDelay = 0.1

        spokenText = text
        currentWordRange = nil
        self.onFinish = onFinish

        // synthesizer.speak(utterance) → starts text-to-speech.
        synthesizer.speak(utterance)
    }

    func pause() {
        synthesizer.pauseSpeaking(at: .word)
    }

    func resume() {
        synthesizer.continueSpeaking()
    }

    func togglePause() {
        isPaused ? resume() : pause()
    }

    /// Stops immediately without running the finish callback.
    func stop() {
        onFinish = nil
        synthesizer.stopSpeaking(at: .immediate)
    }

    #if os(iOS) || os(visionOS)
    /// If the microphone left the session in record mode, make sure speech plays from the
    /// speaker at full volume. Keeps `.playAndRecord` so Quiz Me can record right after.
    private func configureAudioSessionForPlayback() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playAndRecord, mode: .spokenAudio, options: [.duckOthers, .defaultToSpeaker])
        try? session.setActive(true)
    }
    #endif

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
        Task { @MainActor in self.finish(stillSpeaking: stillSpeaking, completed: true) }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        let stillSpeaking = synthesizer.isSpeaking
        Task { @MainActor in self.finish(stillSpeaking: stillSpeaking, completed: false) }
    }

    /// Resets state when an utterance ends, unless a new one has already started.
    private func finish(stillSpeaking: Bool, completed: Bool) {
        guard !stillSpeaking else { return }
        isSpeaking = false
        isPaused = false
        currentWordRange = nil

        let callback = completed ? onFinish : nil
        onFinish = nil
        callback?()
    }
}
