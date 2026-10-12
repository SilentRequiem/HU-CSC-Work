import Foundation
import Observation

/// Drives the Flashcards screen: builds a deck from the shared study guide, tracks the
/// current card and which side is showing, and records Know It / Review Again for the session.
/// Cards come from the existing `StudyAnalysis`, so no Foundation Models request is made here.
@MainActor
@Observable
final class FlashcardsViewModel {
    /// The cards in the current pass, in study order. Shuffling reorders this array.
    private(set) var deck: [Flashcard] = []
    private(set) var currentIndex = 0
    /// False shows the front. Every card starts on its front.
    private(set) var isFlipped = false
    private(set) var filter: FlashcardDeckFilter = .all
    /// Ratings for the current pass, keyed by card ID so they survive shuffling.
    private(set) var ratings: [Flashcard.ID: FlashcardRating] = [:]
    /// 1 for the first time through; increases with each "Study Review Cards Again".
    private(set) var pass = 1
    private(set) var isComplete = false
    /// When on, the front of each new card is read aloud.
    var readsFrontAutomatically = false {
        didSet {
            // Turning Auto Read on reads the card that's already showing, if it's on its front.
            if readsFrontAutomatically, !oldValue, !isFlipped, !isComplete {
                readCurrentSide()
            }
        }
    }

    /// The guide the deck was built from, so a regenerated guide rebuilds the deck.
    private(set) var sourceGuideID: UUID?
    /// The shared guide's analysis the deck is built from. Deliberately *observed*: `hasGuide` and
    /// `cardCount(for:)` read it, and when it was `@ObservationIgnored` the screen rendered "No Study
    /// Guide Yet" before `load(_:)` ran and was never told to re-render afterwards.
    private var analysis: StudyAnalysis?

    @ObservationIgnored
    let synthesizer: SpeechSynthesisService

    init(synthesizer: SpeechSynthesisService) {
        self.synthesizer = synthesizer
    }

    // MARK: - Derived state

    var currentCard: Flashcard? {
        deck.indices.contains(currentIndex) ? deck[currentIndex] : nil
    }

    var hasGuide: Bool { analysis != nil }

    var knownCount: Int { deck.count { ratings[$0.id] == .known } }
    var reviewCount: Int { deck.count { ratings[$0.id] == .review } }
    /// Cards in this pass that haven't been rated yet.
    var remainingCount: Int { deck.count - knownCount - reviewCount }

    /// How far through the pass the user is, from 0 to 1, for the progress bar.
    var progress: Double {
        deck.isEmpty ? 0 : Double(knownCount + reviewCount) / Double(deck.count)
    }

    var canGoBack: Bool { currentIndex > 0 }
    var isOnLastCard: Bool { currentIndex == deck.count - 1 }
    var canShuffle: Bool { deck.count - currentIndex > 1 }
    var currentRating: FlashcardRating? { currentCard.flatMap { ratings[$0.id] } }
    var isSpeaking: Bool { synthesizer.isSpeaking }

    var summary: FlashcardSessionSummary {
        FlashcardSessionSummary(cardsInPass: deck.count, known: knownCount, review: reviewCount)
    }

    /// Number of cards each filter would contain, shown in the deck picker.
    func cardCount(for filter: FlashcardDeckFilter) -> Int {
        guard let analysis else { return 0 }
        return Flashcard.deck(from: analysis, filter: filter).count
    }

    // MARK: - Loading

    /// Builds a fresh deck when the guide is new or was regenerated. Calling it again with the
    /// same guide keeps the user's place, so returning to the screen doesn't reset progress.
    func load(_ guide: GeneratedStudyGuide?) {
        guard guide?.id != sourceGuideID else { return }
        sourceGuideID = guide?.id
        analysis = guide?.analysis
        pass = 1
        startPass(with: allCardsForFilter())
    }

    func setFilter(_ newFilter: FlashcardDeckFilter) {
        guard newFilter != filter else { return }
        filter = newFilter
        pass = 1
        startPass(with: allCardsForFilter())
    }

    // MARK: - Card actions

    func flip() {
        guard currentCard != nil else { return }
        // The visible text changed, so whatever was being read no longer matches the card.
        synthesizer.stop()
        isFlipped.toggle()
    }

    func next() {
        if currentIndex < deck.count - 1 {
            show(index: currentIndex + 1)
        } else if !deck.isEmpty {
            finishPass()
        }
    }

    func previous() {
        guard canGoBack else { return }
        show(index: currentIndex - 1)
    }

    /// Records the user's choice for the current card and moves on. Going back to a card and
    /// choosing again replaces the earlier rating.
    func rate(_ rating: FlashcardRating) {
        guard isFlipped, let card = currentCard else { return }
        ratings[card.id] = rating
        next()
    }

    /// Shuffles the current card and every card after it. Cards already passed keep their
    /// order, so Previous still walks back through what the user has seen.
    func shuffle() {
        guard canShuffle else { return }
        var upcoming = Array(deck[currentIndex...]).shuffled()
        // Make sure the shuffle visibly changes the card on screen.
        if upcoming.first == deck[currentIndex], let swapIndex = upcoming.indices.dropFirst().randomElement() {
            upcoming.swapAt(0, swapIndex)
        }
        deck.replaceSubrange(currentIndex..., with: upcoming)
        show(index: currentIndex)
    }

    /// Starts over with every card in the selected deck, in study-guide order.
    func restartAllCards() {
        pass = 1
        startPass(with: allCardsForFilter())
    }

    /// Starts another pass containing only the cards marked Review Again.
    func studyReviewCardsAgain() {
        let reviewCards = deck.filter { ratings[$0.id] == .review }
        guard !reviewCards.isEmpty else { return }
        pass += 1
        startPass(with: reviewCards)
    }

    // MARK: - Speech

    /// Reads the side that's showing: the question/concept on the front, the answer/explanation on the back.
    func toggleReadAloud() {
        if synthesizer.isSpeaking {
            synthesizer.stop()
        } else {
            readCurrentSide()
        }
    }

    func stopSpeaking() {
        synthesizer.stop()
    }


    // MARK: - Private

    private func allCardsForFilter() -> [Flashcard] {
        analysis.map { Flashcard.deck(from: $0, filter: filter) } ?? []
    }

    private func startPass(with cards: [Flashcard]) {
        deck = cards
        ratings = [:]
        isComplete = false
        show(index: 0)
    }

    /// Moves to a card, always face up on its front.
    private func show(index: Int) {
        synthesizer.stop()
        isFlipped = false
        currentIndex = index
        if readsFrontAutomatically, !isComplete {
            readCurrentSide()
        }
    }

    private func finishPass() {
        synthesizer.stop()
        isFlipped = false
        isComplete = true
    }

    private func readCurrentSide() {
        guard let card = currentCard else { return }
        synthesizer.speak(.flashcard(card, showingBack: isFlipped))
    }
}
