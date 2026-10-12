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
    /// The speech error behind `errorMessage`, so the screen can offer Open Settings or Type Instead.
    private(set) var speechError: SpeechRecognitionError?
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
    /// Bumped whenever a pending recording start should be abandoned (switching to Type, moving
    /// to another question, leaving the screen). Permission prompts can take a while, so the
    /// microphone must not switch on after the user has already moved on.
    @ObservationIgnored
    private var recordingAttempt = 0
    /// The study guide the current question index belongs to.
    @ObservationIgnored
    private var guideID: UUID?

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

    /// Starts again from question 1 only when the guide is different from the one the quiz was
    /// on. Called on appear as well as on change, so a guide regenerated while Quiz Me was off
    /// screen (e.g. the Speak sheet was on Dictate) can't leave the index pointing past the end.
    func showGuide(id newID: UUID?) {
        guard newID != guideID else { return }
        guideID = newID
        restart()
    }

    private func resetAttempt() {
        evaluationTask?.cancel()
        recordingAttempt += 1
        recognizer.cancel()
        synthesizer.stop()
        answerText = ""
        result = nil
        resultInputMethod = nil
        showError(nil)
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
            recordingAttempt += 1
            recognizer.cancel()
        }
        showError(nil)
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
        showError(nil)
        isStartingRecording = true
        recordingAttempt += 1
        let attempt = recordingAttempt

        Task {
            defer { isStartingRecording = false }
            do {
                // The service releases this closure when recording ends, so a strong capture is safe.
                try await recognizer.startRecording { event in
                    switch event {
                    case .partial(let text), .final(let text):
                        self.answerText = text
                    case .failed(let error):
                        self.showError(error)
                    }
                }
                // The user switched to Type, changed question, or left while permission was
                // being requested; don't leave the microphone running with no Stop button.
                if attempt != recordingAttempt || inputMethod != .spoken {
                    recognizer.cancel()
                }
            } catch {
                guard attempt == recordingAttempt else { return }
                showError(error)
            }
        }
    }

    /// Publishes an error (or clears it with nil), keeping the typed speech error when there is one.
    private func showError(_ error: Error?) {
        errorMessage = error?.localizedDescription
        speechError = error as? SpeechRecognitionError
    }

    func stopAll() {
        evaluationTask?.cancel()
        // The cancelled grading task returns early, so clear its spinner here; otherwise Check
        // Answer would stay disabled when the user comes back to this question.
        isEvaluating = false
        recordingAttempt += 1
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
        showError(nil)
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
