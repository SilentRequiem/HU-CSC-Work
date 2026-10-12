import Foundation
import FoundationModels

// MARK: - Guided generation types for Quiz Me
//
// Like `StudyAnalysis`, these are filled in directly by the on-device model through
// guided generation, so the grade comes back as typed Swift values instead of free text.
// The verdict is generated first so the explanation is written to justify it.

/// How close a spoken or typed answer is to the study guide's expected answer.
@Generable
nonisolated enum AnswerVerdict: String, Equatable, CaseIterable {
    case correct
    case partiallyCorrect
    case tryAgain

    var displayName: String {
        switch self {
        case .correct: "Correct"
        case .partiallyCorrect: "Partially Correct"
        case .tryAgain: "Try Again"
        }
    }

    var systemImage: String {
        switch self {
        case .correct: "checkmark.circle.fill"
        case .partiallyCorrect: "circle.lefthalf.filled"
        case .tryAgain: "arrow.counterclockwise.circle.fill"
        }
    }
}

/// The model's structured judgment of one spoken or typed answer.
@Generable(description: "A grade for a student's answer, judged only against the expected answer.")
nonisolated struct AnswerEvaluation: Equatable {
    @Guide(description: "correct if the student's answer means the same as the expected answer, partiallyCorrect if it captures some but not all of the key idea, tryAgain if it is wrong, unrelated, or empty.")
    var verdict: AnswerVerdict

    @Guide(description: "One or two short sentences, addressed to the student, explaining the grade using only the expected answer.")
    var explanation: String
}

/// What the Quiz Me screen shows after grading, including which grader produced it.
struct AnswerEvaluationResult: Equatable {
    enum Method: Equatable {
        /// Graded semantically by Apple's on-device Foundation Models.
        case onDeviceModel
        /// Graded locally by keyword overlap because the model wasn't available.
        case keywordMatch
    }

    let verdict: AnswerVerdict
    let explanation: String
    let method: Method
}
