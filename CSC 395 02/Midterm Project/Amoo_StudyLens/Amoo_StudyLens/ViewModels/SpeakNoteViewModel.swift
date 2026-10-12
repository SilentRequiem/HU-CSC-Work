import Foundation
import Observation

/// The three sections of the Speak Note screen.
enum SpeakNoteMode: String, CaseIterable, Identifiable {
    case dictate
    case listen
    case quiz

    var id: String { rawValue }

    var title: String {
        switch self {
        case .dictate: "Dictate"
        case .listen: "Listen"
        case .quiz: "Quiz Me"
        }
    }

    var headline: String {
        switch self {
        case .dictate: "Dictate Note"
        case .listen: "Listen / Read Aloud"
        case .quiz: "Recite / Quiz Me"
        }
    }

    var subtitle: String {
        switch self {
        case .dictate: "Speak and StudyLens writes it down as a voice note."
        case .listen: "Have StudyLens read one of your saved notes aloud."
        case .quiz: "Practice questions from all your notes. Answer out loud or by typing, and get feedback."
        }
    }

    var systemImage: String {
        switch self {
        case .dictate: "mic.fill"
        case .listen: "speaker.wave.2.fill"
        case .quiz: "questionmark.bubble.fill"
        }
    }
}

/// Owns the shared speech services for the Speak Note screen and one view model per mode.
/// A single recognizer and synthesizer means only one mode can use the microphone or
/// speaker at a time, and switching modes stops whatever was running.
@MainActor
@Observable
final class SpeakNoteViewModel {
    private(set) var mode: SpeakNoteMode = .dictate

    let dictation: DictateNoteViewModel
    let readAloud: ReadAloudViewModel
    let quiz: QuizMeViewModel

    @ObservationIgnored
    private let recognizer: SpeechRecognitionService
    @ObservationIgnored
    private let synthesizer: SpeechSynthesisService

    init() {
        let recognizer = SpeechRecognitionService()
        let synthesizer = SpeechSynthesisService()
        self.recognizer = recognizer
        self.synthesizer = synthesizer
        dictation = DictateNoteViewModel(recognizer: recognizer)
        readAloud = ReadAloudViewModel(synthesizer: synthesizer)
        quiz = QuizMeViewModel(recognizer: recognizer, synthesizer: synthesizer)
    }

    func switchMode(to newMode: SpeakNoteMode) {
        guard newMode != mode else { return }
        stopAudio()
        mode = newMode
    }

    /// Releases the microphone and silences speech (mode switch or closing the sheet).
    func stopAudio() {
        recognizer.cancel()
        synthesizer.stop()
        quiz.stopAll()
    }
}
