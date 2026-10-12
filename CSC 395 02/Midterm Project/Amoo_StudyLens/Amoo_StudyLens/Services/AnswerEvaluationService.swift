import Foundation
import FoundationModels

/// How the student gave a Quiz Me answer. Both go through the same grader; this only adjusts
/// the wording of the prompt so the model knows which kinds of small mistakes to forgive.
enum AnswerInputMethod: String, CaseIterable, Identifiable {
    case spoken
    case typed

    var id: String { rawValue }

    var title: String {
        switch self {
        case .spoken: "Speak"
        case .typed: "Type"
        }
    }

    var systemImage: String {
        switch self {
        case .spoken: "mic.fill"
        case .typed: "keyboard"
        }
    }
}

/// Grades a Quiz Me answer (spoken or typed) against the expected answer from the generated
/// study guide. Uses Apple's on-device Foundation Models for semantic grading, and falls back to
/// a local keyword comparison when the model is unavailable or fails.
struct AnswerEvaluationService {
    /// Same on-device model used for study-guide generation.
    private let model = SystemLanguageModel.default
    /// Reuses the Study Guide's availability check and user-facing messages.
    private let studyService = StudyAnalysisService()

    var isModelAvailable: Bool {
        studyService.checkAvailability() == .available
    }

    /// Instructions keep the grader grounded in the expected answer only.
    private static let instructions = """
        You grade a student's answer to a practice question. The answer was either spoken \
        (and transcribed by speech recognition) or typed.
        The expected answer comes from the student's own study guide and is the only source of truth.
        Judge whether the student's answer means the same thing as the expected answer. \
        Ignore wording, filler words, grammar, spelling, typos, and small speech-recognition mistakes.
        Do not use outside knowledge, and do not add facts that are not in the expected answer.
        If the student's answer is empty, off-topic, or contradicts the expected answer, the verdict is tryAgain.
        """

    // MARK: - Evaluation

    /// The single grading entry point for Quiz Me. Spoken and typed answers both come here and
    /// get the same verdicts (Correct, Partially Correct, Try Again) and explanations.
    func evaluate(answer: String, for item: PracticeQuestion, inputMethod: AnswerInputMethod) async -> AnswerEvaluationResult {
        let trimmed = answer.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return AnswerEvaluationResult(
                verdict: .tryAgain,
                explanation: inputMethod == .spoken
                    ? "No answer was recorded. Tap the microphone and say your answer."
                    : "No answer was entered. Type your answer and check it again.",
                method: .keywordMatch
            )
        }

        if isModelAvailable {
            do {
                return try await evaluateWithModel(answer: trimmed, for: item, inputMethod: inputMethod)
            } catch is CancellationError {
                return Self.localEvaluation(answer: trimmed, expectedAnswer: item.answer)
            } catch {
                // Any model problem (guardrails, busy, context size) falls back to local grading.
            }
        }
        return Self.localEvaluation(answer: trimmed, expectedAnswer: item.answer)
    }

    /// Foundation Models guided generation: the model fills in an `AnswerEvaluation`
    /// (verdict + explanation) directly, so no text parsing is needed.
    private func evaluateWithModel(answer: String, for item: PracticeQuestion, inputMethod: AnswerInputMethod) async throws -> AnswerEvaluationResult {
        // A fresh session per answer keeps earlier questions out of the context window.
        let session = LanguageModelSession(model: model, instructions: Self.instructions)

        let prompt = """
            Question: \(item.question)
            Expected answer (from the study guide): \(item.answer)
            Student's \(inputMethod == .spoken ? "spoken (transcribed)" : "typed") answer: \(answer)

            Grade the student's answer using only the expected answer.
            """

        let response = try await session.respond(
            to: prompt,
            generating: AnswerEvaluation.self,
            // Low temperature keeps grading consistent between attempts.
            options: GenerationOptions(temperature: 0.1)
        )
        return AnswerEvaluationResult(
            verdict: response.content.verdict,
            explanation: response.content.explanation,
            method: .onDeviceModel
        )
    }

    // MARK: - Local fallback

    /// Compares the important words of the expected answer with the student's answer.
    /// Less forgiving than the model about synonyms, but works on every device.
    static func localEvaluation(answer: String, expectedAnswer: String) -> AnswerEvaluationResult {
        var expected = keywords(in: expectedAnswer)
        var spoken = keywords(in: answer)

        // Very short expected answers ("No", "pH 7", "42") have no long content words, so compare
        // every word instead of reporting that the answer can't be checked.
        if expected.isEmpty {
            expected = keywords(in: expectedAnswer, keepingShortWords: true)
            spoken = keywords(in: answer, keepingShortWords: true)
        }

        guard !expected.isEmpty else {
            return AnswerEvaluationResult(
                verdict: .partiallyCorrect,
                explanation: "StudyLens couldn't compare this answer automatically. Check it against the expected answer below.",
                method: .keywordMatch
            )
        }

        let matched = expected.keys.filter { spoken[$0] != nil }
        let coverage = Double(matched.count) / Double(expected.count)

        let verdict: AnswerVerdict
        let explanation: String
        switch coverage {
        // Thresholds are lenient because speech recognition, typos, and paraphrasing change wording.
        case 0.6...:
            verdict = .correct
            explanation = "Your answer includes the key ideas from the study guide."
        case 0.3..<0.6:
            verdict = .partiallyCorrect
            let missing = expected.keys.filter { spoken[$0] == nil }.sorted().prefix(3)
                .compactMap { expected[$0] }.joined(separator: ", ")
            explanation = "You covered part of the answer. Try also mentioning: \(missing)."
        default:
            verdict = .tryAgain
            explanation = "Your answer doesn't match the key ideas in the study guide yet. Review the expected answer and try again."
        }
        return AnswerEvaluationResult(verdict: verdict, explanation: explanation, method: .keywordMatch)
    }

    /// Lowercased content words with very common words removed and simple plurals folded.
    /// Keys are the folded forms used for matching; values are the words as written, which is
    /// what the "Try also mentioning" hint shows (so it never displays a chopped word like "analysi").
    private static func keywords(in text: String, keepingShortWords: Bool = false) -> [String: String] {
        let words = text.lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { keepingShortWords ? !$0.isEmpty : $0.count > 2 && !stopWords.contains($0) }
        var keywords: [String: String] = [:]
        for word in words {
            let folded = word.count > 4 && word.hasSuffix("s") && !word.hasSuffix("ss") ? String(word.dropLast()) : word
            keywords[folded] = keywords[folded] ?? word
        }
        return keywords
    }

    private static let stopWords: Set<String> = [
        "the", "and", "for", "are", "but", "not", "you", "all", "any", "can", "had", "her", "was",
        "one", "our", "out", "has", "have", "his", "how", "its", "may", "new", "now", "see", "who",
        "did", "get", "let", "say", "she", "too", "use", "that", "this", "with", "from", "they",
        "them", "then", "than", "there", "their", "what", "when", "where", "which", "while", "will",
        "would", "could", "should", "into", "onto", "also", "been", "being", "were", "your", "about",
        "because", "does", "just", "like", "some", "such", "very", "um", "uh", "okay", "yeah", "think",
        "answer", "notes", "note", "called", "means", "mean", "thing", "things", "kind", "sort"
    ]
}
