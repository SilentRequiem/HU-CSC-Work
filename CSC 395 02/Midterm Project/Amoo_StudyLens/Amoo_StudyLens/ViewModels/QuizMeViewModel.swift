import Foundation
import Observation

/// Drives Recite / Quiz Me: steps through the practice questions from the shared study guide
/// (built from scanned, handwritten, and voice notes alike), reads them aloud, takes a spoken
/// or typed answer, and grades it.
@MainActor
@Observable
final class QuizMeViewModel {
    private(set) var currentIndex = 0
    /// The answer to grade: the live transcript when speaking, or what the user typed.
    /// Always editable so the user can fix a misheard word before checking.
    var answerText = ""
    /// Whether the user is answering out loud or by typing. Change it with `setInputMethod(_:)`.
    private(set) var inputMethod: AnswerInputMethod = .spoken
    private(set) var result: AnswerEvaluationResult?
    /// How the graded answer was given, shown next to the result.
    private(set) var resultInputMethod: AnswerInputMethod?
    private(set) var isEvaluating = false
    private(set) var isStartingRecording = false
    private(set) var errorMessage: String?
    var isAnswerRevealed = false
    /// When on, each new question is read aloud automatically.
    var readsQuestionsAutomatically = true

    @ObservationIgnored
    let synthesizer: SpeechSynthesisService
    @ObservationIgnored
    private let recognizer: SpeechRecognitionService
    @ObservationIgnored
    private let evaluator: AnswerEvaluationService
    @ObservationIgnored
    private var evaluationTask: Task<Void, Never>?

    init(
        recognizer: SpeechRecognitionService,
        synthesizer: SpeechSynthesisService,
        evaluator: AnswerEvaluationService? = nil
    ) {
        self.recognizer = recognizer
        self.synthesizer = synthesizer
        self.evaluator = evaluator ?? AnswerEvaluationService()
    }

    var isRecording: Bool { recognizer.isRecording }
    var isSpeakingQuestion: Bool { synthesizer.isSpeaking }

    /// Tells the user up front whether grading will be semantic or keyword-based.
    var usesOnDeviceModel: Bool { evaluator.isModelAvailable }

    var canCheckAnswer: Bool {
        !isRecording && !isStartingRecording && !isEvaluating
            && answerText.contains { $0.isLetter || $0.isNumber }
    }

    func currentQuestion(in questions: [PracticeQuestion]) -> PracticeQuestion? {
        questions.indices.contains(currentIndex) ? questions[currentIndex] : nil
    }

    // MARK: - Navigation

    func select(index: Int, in questions: [PracticeQuestion]) {
        guard questions.indices.contains(index) else { return }
        currentIndex = index
        resetAttempt()
        if readsQuestionsAutomatically {
            readQuestion(in: questions)
        }
    }

    func next(in questions: [PracticeQuestion]) {
        select(index: currentIndex + 1, in: questions)
    }

    func previous(in questions: [PracticeQuestion]) {
        select(index: currentIndex - 1, in: questions)
    }

    /// Called when a new study guide replaces the old one.
    func restart() {
        currentIndex = 0
        resetAttempt()
    }

    private func resetAttempt() {
        evaluationTask?.cancel()
        recognizer.cancel()
        synthesizer.stop()
        answerText = ""
        result = nil
        resultInputMethod = nil
        errorMessage = nil
        isEvaluating = false
        isAnswerRevealed = false
    }

    // MARK: - Speaking the question

    func readQuestion(in questions: [PracticeQuestion]) {
        guard let item = currentQuestion(in: questions) else { return }
        // Never talk over the microphone; the recognizer would transcribe StudyLens itself.
        if isRecording { recognizer.stopRecording() }
        synthesizer.speak(.question(item, number: currentIndex + 1))
    }

    func readExpectedAnswer(in questions: [PracticeQuestion]) {
        guard let item = currentQuestion(in: questions) else { return }
        if isRecording { recognizer.stopRecording() }
        synthesizer.speak(SpeechScript(text: "The expected answer is: \(item.answer)"))
    }

    // MARK: - Answer input

    /// Switches between speaking and typing. Leaving Speak releases the microphone; any text
    /// already in the answer is kept so the user can finish it by typing.
    func setInputMethod(_ method: AnswerInputMethod) {
        guard method != inputMethod else { return }
        if method == .typed {
            recognizer.cancel()
        }
        errorMessage = nil
        inputMethod = method
    }

    // MARK: - Recording the answer

    func toggleRecording() {
        isRecording ? recognizer.stopRecording() : startRecording()
    }

    private func startRecording() {
        guard !isStartingRecording else { return }
        synthesizer.stop()
        answerText = ""
        result = nil
        resultInputMethod = nil
        errorMessage = nil
        isStartingRecording = true

        Task {
            defer { isStartingRecording = false }
            do {
                // The service releases this closure when recording ends, so a strong capture is safe.
                try await recognizer.startRecording { event in
                    switch event {
                    case .partial(let text), .final(let text):
                        self.answerText = text
                    case .failed(let error):
                        self.errorMessage = error.localizedDescription
                    }
                }
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func stopAll() {
        evaluationTask?.cancel()
        recognizer.cancel()
        synthesizer.stop()
    }

    // MARK: - Grading

    /// Grades the answer against the study guide's expected answer. Spoken and typed answers
    /// use the same `AnswerEvaluationService` call; only the input method label differs.
    func checkAnswer(in questions: [PracticeQuestion]) {
        guard canCheckAnswer, let item = currentQuestion(in: questions) else { return }
        let answer = answerText
        let method = inputMethod
        isEvaluating = true
        errorMessage = nil
        result = nil

        evaluationTask = Task {
            let evaluation = await evaluator.evaluate(answer: answer, for: item, inputMethod: method)
            guard !Task.isCancelled else { return }
            result = evaluation
            resultInputMethod = method
            isEvaluating = false
            // Show the expected answer automatically when the user didn't get it fully right.
            if evaluation.verdict != .correct {
                isAnswerRevealed = true
            }
        }
    }
}
