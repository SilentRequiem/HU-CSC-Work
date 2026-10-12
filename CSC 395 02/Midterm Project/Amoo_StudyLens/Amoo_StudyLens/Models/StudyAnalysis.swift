import Foundation
import FoundationModels

// MARK: - Guided generation types
//
// These types are filled in directly by the on-device model through guided generation.
// `@Generable` makes the model produce output that matches each Swift type's structure,
// so StudyLens never asks for JSON and never parses text by hand. `@Guide` descriptions
// and count constraints steer the content and keep the result intentionally small.
// Property order matters: the model generates properties top to bottom, so the summary
// is written first and grounds the sections that follow.

/// The complete AI study guide generated from the user's saved notes.
@Generable(description: "A concise study guide built only from the student's notes.")
nonisolated struct StudyAnalysis: Equatable {
    @Guide(description: "A 2-4 sentence summary of the main ideas in the notes.")
    var summary: String

    @Guide(description: "The most important concepts found in the notes.", .count(4...6))
    var keyConcepts: [KeyConcept]

    @Guide(description: "Questions that can be answered using only the notes.", .count(3...5))
    var practiceQuestions: [PracticeQuestion]

    @Guide(description: "A concept map of how the ideas in the notes connect.")
    var brainMap: BrainMap
}

/// A single important term or idea and a short explanation drawn from the notes.
@Generable
nonisolated struct KeyConcept: Equatable {
    @Guide(description: "The concept's name, a few words at most.")
    var name: String

    @Guide(description: "One or two sentences explaining the concept using only the notes.")
    var explanation: String
}

/// A self-test question with its answer taken from the notes.
@Generable
nonisolated struct PracticeQuestion: Equatable {
    @Guide(description: "A clear question about the notes.")
    var question: String

    @Guide(description: "A short answer based only on the notes. If the notes do not contain the answer, say so.")
    var answer: String
}

/// Graph data drawn by the Brain Map tab (see `BrainMapGraph` and `BrainMapLayout`).
@Generable
nonisolated struct BrainMap: Equatable {
    @Guide(description: "The single topic that best ties the notes together.")
    var centralTopic: String

    @Guide(description: "Short concept names that appear as nodes in the map.", .count(4...8))
    var concepts: [String]

    @Guide(description: "Connections between concepts, using the concept names above.", .count(4...8))
    var relationships: [ConceptRelationship]
}

/// A directed link between two brain-map concepts.
@Generable
nonisolated struct ConceptRelationship: Equatable {
    @Guide(description: "The concept the relationship starts from.")
    var source: String

    @Guide(description: "The concept the relationship points to.")
    var target: String

    @Guide(description: "A few words describing how the source relates to the target, such as \"causes\" or \"is part of\".")
    var relationship: String
}
