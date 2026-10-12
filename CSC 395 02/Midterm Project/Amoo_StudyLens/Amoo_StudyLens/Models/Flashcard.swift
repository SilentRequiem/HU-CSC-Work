import Foundation

/// Where a flashcard came from in the generated study guide.
enum FlashcardKind: String, CaseIterable, Identifiable {
    /// Built from a Practice Question: question on the front, expected answer on the back.
    case question
    /// Built from a Key Concept: concept name on the front, explanation on the back.
    case keyConcept

    var id: Self { self }

    var displayName: String {
        switch self {
        case .question: "Question"
        case .keyConcept: "Key Concept"
        }
    }

    /// The study-guide section the card was taken from, shown on the card.
    var sourceName: String {
        switch self {
        case .question: "Practice Questions"
        case .keyConcept: "Key Concepts"
        }
    }

    var systemImage: String {
        switch self {
        case .question: "questionmark.bubble"
        case .keyConcept: "lightbulb"
        }
    }

    var frontHeading: String {
        switch self {
        case .question: "Question"
        case .keyConcept: "Concept"
        }
    }

    var backHeading: String {
        switch self {
        case .question: "Answer"
        case .keyConcept: "Explanation"
        }
    }

    var revealInstruction: String {
        switch self {
        case .question: "Tap to reveal answer"
        case .keyConcept: "Tap to reveal explanation"
        }
    }
}

/// One two-sided study card. Cards are derived from an existing `StudyAnalysis`; they don't
/// store a copy of the guide, and making them never calls Foundation Models.
struct Flashcard: Identifiable, Equatable {
    /// Stable within one guide, e.g. "question-2", so ratings survive shuffling and review passes.
    let id: String
    let kind: FlashcardKind
    let front: String
    let back: String
    /// 1-based position in its study-guide section ("Practice Question 2").
    let sourceNumber: Int

    /// e.g. "From Practice Questions · #2"
    var sourceDescription: String {
        "From \(kind.sourceName) · #\(sourceNumber)"
    }
}

/// Which cards to include in a deck.
enum FlashcardDeckFilter: String, CaseIterable, Identifiable {
    case all
    case questions
    case keyConcepts

    var id: Self { self }

    var title: String {
        switch self {
        case .all: "All Cards"
        case .questions: "Questions"
        case .keyConcepts: "Key Concepts"
        }
    }

    func includes(_ kind: FlashcardKind) -> Bool {
        switch self {
        case .all: true
        case .questions: kind == .question
        case .keyConcepts: kind == .keyConcept
        }
    }
}

extension Flashcard {
    /// Builds cards from the guide's Practice Questions, then its Key Concepts.
    /// Blank entries (which the model shouldn't produce, but could) are skipped.
    static func deck(from analysis: StudyAnalysis, filter: FlashcardDeckFilter = .all) -> [Flashcard] {
        let questionCards = analysis.practiceQuestions.enumerated().map { index, item in
            Flashcard(id: "question-\(index)", kind: .question,
                      front: item.question, back: item.answer, sourceNumber: index + 1)
        }
        let conceptCards = analysis.keyConcepts.enumerated().map { index, concept in
            Flashcard(id: "concept-\(index)", kind: .keyConcept,
                      front: concept.name, back: concept.explanation, sourceNumber: index + 1)
        }
        return (questionCards + conceptCards).filter { card in
            filter.includes(card.kind)
                && !card.front.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                && !card.back.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
}

// MARK: - Session

/// The user's self-assessment after revealing a card.
enum FlashcardRating: Equatable {
    case known
    case review
}

/// Totals shown on the session-complete screen.
struct FlashcardSessionSummary: Equatable {
    let cardsInPass: Int
    let known: Int
    let review: Int

    /// Cards the user rated (cards passed over with Next aren't counted as studied).
    var studied: Int { known + review }
    var skipped: Int { max(cardsInPass - studied, 0) }

    /// Share of studied cards marked Know It, from 0 to 1.
    var fractionKnown: Double {
        studied == 0 ? 0 : Double(known) / Double(studied)
    }
}

// MARK: - Speech

extension SpeechScript {
    /// The visible side of a flashcard, read by the shared `SpeechSynthesisService`.
    static func flashcard(_ card: Flashcard, showingBack: Bool) -> SpeechScript {
        let heading = showingBack ? card.kind.backHeading : card.kind.frontHeading
        let text = showingBack ? card.back : card.front
        return SpeechScript(text: "\(heading). \(text)")
    }
}

// MARK: - Preview data

#if DEBUG
extension StudyAnalysis {
    /// Preview-only sample guide; the app always uses the model-generated guide.
    static let flashcardsPreviewSample = StudyAnalysis(
        summary: "Plant and animal cells share many organelles, but plants have extra structures for photosynthesis and support.",
        keyConcepts: [
            KeyConcept(name: "Chloroplast", explanation: "The organelle where photosynthesis turns light energy into chemical energy."),
            KeyConcept(name: "Mitochondria", explanation: "Organelles that release energy from food as ATP during cellular respiration."),
            KeyConcept(name: "Cell Wall", explanation: "A rigid layer outside the plant cell membrane that gives support and shape.")
        ],
        practiceQuestions: [
            PracticeQuestion(question: "Which organelles are found only in plants?", answer: "Chloroplasts, central vacuole, and cell wall."),
            PracticeQuestion(question: "What does the mitochondria produce?", answer: "ATP, the cell's usable energy.")
        ],
        brainMap: BrainMap(centralTopic: "Cells", concepts: [], relationships: [])
    )
}
#endif
