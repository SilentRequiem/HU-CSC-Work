import SwiftUI

/// Flashcards opened from the Study tab. Turns the shared study guide's Practice Questions and
/// Key Concepts into a deck the user flips through, rating each card Know It or Review Again.
/// Reads the existing guide from `StudyViewModel`; it never asks Foundation Models for new content.
struct FlashcardsView: View {
    @Environment(NotesViewModel.self) private var notesViewModel
    @Environment(StudyViewModel.self) private var studyViewModel
    /// Leaving goes through the Study stack's owner rather than `dismiss()`, so "Done" and
    /// "Back to Study" always pop exactly this screen and return to the intact Study guide.
    @Environment(AppNavigationModel.self) private var navigation
    /// Reduce Motion: no spring flip, scaling, or sliding; cards change with a short cross-fade.
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var viewModel: FlashcardsViewModel

    /// A fresh view model each time the screen opens. It holds only the deck and session progress;
    /// the guide itself always comes from the shared `StudyViewModel` in the environment.
    init(viewModel: FlashcardsViewModel? = nil) {
        _viewModel = State(initialValue: viewModel ?? FlashcardsViewModel(synthesizer: SpeechSynthesisService()))
    }

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.flashcardsBackground)
            .navigationTitle("Flashcards")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            // Builds the deck from the current guide, and rebuilds it if the guide is regenerated
            // or cleared (for example, when all of its source notes are deleted).
            .onChange(of: studyViewModel.guide?.id, initial: true) {
                viewModel.load(studyViewModel.guide)
            }
            // Never leave speech running after leaving the screen.
            .onDisappear { viewModel.stopSpeaking() }
    }

    /// Same pattern as Quiz Me: whether a guide exists is decided by the one shared
    /// `StudyViewModel.guide` (observed), never by a local copy. The local view model only holds the
    /// deck and session progress built from that guide.
    @ViewBuilder
    private var content: some View {
        if let guide = studyViewModel.guide {
            if viewModel.sourceGuideID != guide.id && !viewModel.hasGuide {
                // Only for the instant before `.onChange(initial:)` builds the deck on first appear.
                ProgressView()
            } else {
                deckContent
            }
        } else {
            emptyState
        }
    }

    @ViewBuilder
    private var deckContent: some View {
        if viewModel.isComplete {
            ScrollView {
                FlashcardSessionSummaryView(
                    summary: viewModel.summary,
                    pass: viewModel.pass,
                    onStudyReviewCards: { withAnimation { viewModel.studyReviewCardsAgain() } },
                    onRestartAll: { withAnimation { viewModel.restartAllCards() } },
                    onDone: { navigation.popStudy() }
                )
                .padding()
                .frame(maxWidth: .infinity)
            }
            .transition(.opacity)
        } else if let card = viewModel.currentCard {
            ScrollView {
                deck(showing: card)
                    .padding()
                    .frame(maxWidth: 640)
                    .frame(maxWidth: .infinity)
            }
        } else {
            // Only possible if a filter matches no cards, e.g. a guide with blank questions.
            ContentUnavailableView {
                Label("No Cards in This Deck", systemImage: "rectangle.on.rectangle.slash")
            } description: {
                Text("This study guide has no \(viewModel.filter.title.lowercased()) to study.")
            } actions: {
                Button("Show All Cards") { viewModel.setFilter(.all) }
                    .buttonStyle(.bordered)
            }
        }
    }

    // MARK: - Deck

    private func deck(showing card: Flashcard) -> some View {
        VStack(spacing: 20) {
            deckPicker

            // Which notes the deck came from, and whether they've changed since.
            if let guide = studyViewModel.guide {
                StudySourceBanner(guide: guide, isCompact: true)
            }

            progressHeader

            Button {
                flip()
            } label: {
                FlashcardView(card: card, isFlipped: viewModel.isFlipped,
                              position: "\(viewModel.currentIndex + 1) of \(viewModel.deck.count)")
                    .contentShape(.rect(cornerRadius: 24))
            }
            .buttonStyle(.plain)
            .keyboardShortcut(.space, modifiers: [])
            // A new identity per card means each card appears fresh on its front, rather than
            // the previous card visibly flipping back first.
            .id(card.id)
            .transition(reduceMotion ? .opacity : .opacity.combined(with: .scale(scale: 0.97)))
            .accessibilityAction(named: "Know It") { rateCard(.known) }
            .accessibilityAction(named: "Review Again") { rateCard(.review) }
            .background {
                // Return also flips the card on macOS (a second shortcut needs its own button).
                Button("Flip Card") { flip() }
                    .keyboardShortcut(.return, modifiers: [])
                    .opacity(0)
                    .accessibilityHidden(true)
            }

            ratingButtons
            navigationButtons
            speechControls

            if card.kind == .keyConcept {
                // Same Concept Detail screen as the Study guide's Key Concepts, pushed on the Study
                // stack above this deck, so Back returns here with the session intact.
                Button("Concept Details & Learn More", systemImage: "lightbulb") {
                    viewModel.stopSpeaking()
                    navigation.openStudy(.concept(StudyConcept(name: card.front, explanation: card.back, origin: .flashcards)))
                }
                .font(.footnote)
                .buttonStyle(.borderless)
                .tint(.flashcardsAccent)
            }
        }
    }

    private var deckPicker: some View {
        Picker("Deck", selection: Binding(
            get: { viewModel.filter },
            set: { newValue in withAnimation { viewModel.setFilter(newValue) } }
        )) {
            ForEach(FlashcardDeckFilter.allCases) { filter in
                Text("\(filter.title) (\(viewModel.cardCount(for: filter)))").tag(filter)
            }
        }
        .pickerStyle(.segmented)
        .labelsHidden()
    }

    private var progressHeader: some View {
        VStack(spacing: 10) {
            HStack {
                Text(viewModel.pass > 1 ? "Review Round \(viewModel.pass)" : "Progress")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text(viewModel.progress, format: .percent.precision(.fractionLength(0)))
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: viewModel.progress)
                .tint(.flashcardsAccent)
                .animation(.easeOut(duration: 0.25), value: viewModel.progress)

            HStack(spacing: 8) {
                ProgressChip(title: "Known", value: viewModel.knownCount, systemImage: "checkmark.circle.fill", tint: .green)
                ProgressChip(title: "Review", value: viewModel.reviewCount, systemImage: "arrow.counterclockwise.circle.fill", tint: .orange)
                ProgressChip(title: "Remaining", value: viewModel.remainingCount, systemImage: "rectangle.stack.fill", tint: .flashcardsAccent)
            }
        }
        .accessibilityElement(children: .combine)
    }

    /// Know It / Review Again only appear once the answer is showing. They stay in the layout
    /// (just hidden) so the buttons below don't jump when the card flips.
    private var ratingButtons: some View {
        HStack(spacing: 12) {
            Button {
                rateCard(.review)
            } label: {
                Label("Review Again", systemImage: "arrow.counterclockwise")
                    .frame(maxWidth: .infinity)
            }
            .tint(.orange)

            Button {
                rateCard(.known)
            } label: {
                Label("Know It", systemImage: "checkmark")
                    .frame(maxWidth: .infinity)
            }
            .tint(.green)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .opacity(viewModel.isFlipped ? 1 : 0)
        .disabled(!viewModel.isFlipped)
        .accessibilityHidden(!viewModel.isFlipped)
        .animation(.easeOut(duration: 0.2), value: viewModel.isFlipped)
        .overlay {
            if let rating = viewModel.currentRating, !viewModel.isFlipped {
                Label(rating == .known ? "You marked this card Know It" : "You marked this card Review Again",
                      systemImage: rating == .known ? "checkmark.circle" : "arrow.counterclockwise.circle")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var navigationButtons: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Button {
                    navigate { viewModel.previous() }
                } label: {
                    Label("Previous", systemImage: "chevron.left")
                        .frame(maxWidth: .infinity)
                }
                .keyboardShortcut(.leftArrow, modifiers: [])
                .disabled(!viewModel.canGoBack)

                Button {
                    navigate { viewModel.next() }
                } label: {
                    HStack(spacing: 6) {
                        Text(viewModel.isOnLastCard ? "Finish" : "Next")
                        Image(systemName: viewModel.isOnLastCard ? "flag.checkered" : "chevron.right")
                    }
                    .frame(maxWidth: .infinity)
                }
                .keyboardShortcut(.rightArrow, modifiers: [])
            }
            .buttonStyle(.bordered)
            .controlSize(.large)

            HStack(spacing: 12) {
                Button("Shuffle", systemImage: "shuffle") {
                    navigate { viewModel.shuffle() }
                }
                .disabled(!viewModel.canShuffle)

                Button("Restart Deck", systemImage: "arrow.trianglehead.2.clockwise.rotate.90") {
                    navigate { viewModel.restartAllCards() }
                }
            }
            .buttonStyle(.bordered)
            .tint(.flashcardsAccent)
        }
    }

    private var speechControls: some View {
        @Bindable var viewModel = viewModel
        return HStack {
            Button {
                viewModel.toggleReadAloud()
            } label: {
                Label(viewModel.isSpeaking ? "Stop Reading" : "Read Aloud",
                      systemImage: viewModel.isSpeaking ? "speaker.wave.3.fill" : "speaker.wave.2")
            }
            .buttonStyle(.bordered)
            .tint(.flashcardsAccent)
            .symbolEffect(.variableColor.iterative, options: .repeating, isActive: viewModel.isSpeaking)

            Spacer(minLength: 8)

            Toggle("Auto Read", isOn: $viewModel.readsFrontAutomatically)
                .toggleStyle(.switch)
                .controlSize(.small)
                .font(.footnote)
                .fixedSize()
        }
    }

    // MARK: - Empty state

    private var emptyState: some View {
        ContentUnavailableView {
            Label("No Study Guide Yet", systemImage: "rectangle.on.rectangle.angled")
        } description: {
            Text(notesViewModel.notes.isEmpty
                 ? "Add notes from the Capture tab, then generate a study guide in the Study tab. Its practice questions and key concepts become your flashcards."
                 : "Generate a study guide from the Study tab. Its practice questions and key concepts become your flashcards.")
        } actions: {
            Button("Back to Study") { navigation.popStudy() }
                .buttonStyle(.bordered)
        }
    }

    // MARK: - Actions

    private func flip() {
        // With Reduce Motion, `FlashcardView` skips the 3D turn and this brief ease just
        // cross-fades the two sides.
        withAnimation(reduceMotion ? .easeInOut(duration: 0.2) : .spring(duration: 0.5, bounce: 0.15)) {
            viewModel.flip()
        }
    }

    private func navigate(_ action: () -> Void) {
        withAnimation(.easeInOut(duration: reduceMotion ? 0.15 : 0.25)) {
            action()
        }
    }

    /// Rates the current card. Also exposed as VoiceOver actions on the card, so it can be rated
    /// without hunting for the buttons; rating is only accepted once the answer is showing.
    private func rateCard(_ rating: FlashcardRating) {
        guard viewModel.isFlipped else { return }
        navigate { viewModel.rate(rating) }
    }
}

/// A compact count such as "Known 6", used under the progress bar.
private struct ProgressChip: View {
    let title: String
    let value: Int
    let systemImage: String
    let tint: Color

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: systemImage)
                .foregroundStyle(tint)
            Text(title)
                .foregroundStyle(.secondary)
            Text(value, format: .number)
                .fontWeight(.semibold)
                .monospacedDigit()
        }
        .font(.footnote)
        .lineLimit(1)
        .minimumScaleFactor(0.8)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity)
        .background(tint.opacity(0.12), in: .capsule)
    }
}

#Preview("Deck") {
    // The deck comes from the shared StudyViewModel's guide, exactly as in the app.
    let studyViewModel = StudyViewModel()
    studyViewModel.loadPreviewGuide(.flashcardsPreviewSample)
    return NavigationStack {
        FlashcardsView()
    }
    .environment(NotesViewModel())
    .environment(studyViewModel)
    .environment(AppNavigationModel())
}

#Preview("Empty State") {
    NavigationStack {
        FlashcardsView()
    }
    .environment(NotesViewModel())
    .environment(StudyViewModel())
    .environment(AppNavigationModel())
}
