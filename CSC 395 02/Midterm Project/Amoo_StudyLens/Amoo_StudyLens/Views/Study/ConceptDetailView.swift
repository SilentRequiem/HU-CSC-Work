import SwiftUI

/// Details for one concept from the study guide, with an optional Wikipedia lookup.
///
/// The screen is split into two clearly labeled cards so the user always knows where text came from:
///   • **From Your Notes** – the explanation generated on device from the selected study material.
///   • **From Wikipedia** – external information, fetched only when the user taps Learn More.
/// Pushed onto the existing Study stack (`AppNavigationModel.studyPath`) from Key Concepts and
/// Key Concept flashcards, and onto the Brain Map stack (`brainMapPath`) from a map node. All
/// networking lives in `WikipediaService`, reached through `ConceptEnrichmentViewModel`.
struct ConceptDetailView: View {
    @Environment(NotesViewModel.self) private var notesViewModel
    @State private var viewModel: ConceptEnrichmentViewModel

    init(concept: StudyConcept, viewModel: ConceptEnrichmentViewModel? = nil) {
        _viewModel = State(initialValue: viewModel ?? ConceptEnrichmentViewModel(concept: concept))
    }

    private var concept: StudyConcept { viewModel.concept }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                fromYourNotesCard
                fromWikipediaCard
            }
            .padding()
            .frame(maxWidth: 720)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle(concept.name)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        // A concept already looked up this session (from Key Concepts, Flashcards, or the Brain Map)
        // reappears from the in-memory cache; no request is made on appear.
        .task { await viewModel.restoreCachedResult() }
        // Leaving the screen cancels an in-flight search; nothing is left running in the background.
        .onDisappear { viewModel.cancel(userInitiated: false) }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Label("From \(concept.origin.displayName)", systemImage: "lightbulb")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.orange)
            Text(concept.name)
                .font(.title2.bold())
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - From Your Notes

    private var fromYourNotesCard: some View {
        StudySectionCard(title: "From Your Notes", systemImage: "note.text", tint: .orange) {
            if let explanation = concept.explanation, !explanation.isEmpty {
                Text(explanation)
                    .fixedSize(horizontal: false, vertical: true)
                    .textSelection(.enabled)
            } else {
                Text("Your study guide includes this concept in the Brain Map but doesn't have a separate explanation for it.")
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Text("Generated on device from your selected StudyLens material. Quiz Me, Flashcards, and the Brain Map use only your notes.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - From Wikipedia

    private var fromWikipediaCard: some View {
        StudySectionCard(title: "From Wikipedia", systemImage: "globe", tint: .teal) {
            Label("External information — not from your notes", systemImage: "arrow.up.forward.app")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.teal)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.teal.opacity(0.12), in: .capsule)

            wikipediaContent

            Text("Wikipedia is written by volunteers and its text is available under CC BY-SA 4.0. Check important facts against your course materials.")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    @ViewBuilder
    private var wikipediaContent: some View {
        switch viewModel.phase {
        case .idle:
            idleState
        case .loading:
            loadingState
        case .failed(let error):
            failureState(error)
        case .loaded(let result):
            loadedState(result)
        }
    }

    private var idleState: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Look up “\(concept.name)” on Wikipedia for extra background. StudyLens only contacts Wikipedia when you tap Learn More, and nothing is added to your notes unless you choose Add to Notes.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            if viewModel.wasCancelled {
                Label("Search cancelled.", systemImage: "xmark.circle")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            learnMoreButton(title: "Learn More")
        }
    }

    private var loadingState: some View {
        HStack(spacing: 12) {
            ProgressView()
            Text("Searching Wikipedia…")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Button("Cancel", role: .cancel) {
                viewModel.cancel()
            }
            .buttonStyle(.bordered)
        }
        .padding(.vertical, 4)
    }

    private func failureState(_ error: WikipediaError) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(error.localizedDescription, systemImage: error == .offline ? "wifi.exclamationmark" : "exclamationmark.triangle")
                .font(.subheadline)
                .foregroundStyle(Color.studyLensWarning)
                .fixedSize(horizontal: false, vertical: true)

            Text("Your notes, study guide, Quiz Me, Flashcards, and Brain Map keep working without Wikipedia.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            learnMoreButton(title: "Try Again")
        }
    }

    private func learnMoreButton(title: String) -> some View {
        Button {
            viewModel.learnMore()
        } label: {
            Label(title, systemImage: "magnifyingglass")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(.teal)
    }

    @ViewBuilder
    private func loadedState(_ result: WikipediaLookupResult) -> some View {
        if viewModel.isFromCache {
            Label("Shown from this session's cache — no new request was made.", systemImage: "clock.arrow.circlepath")
                .font(.caption)
                .foregroundStyle(.secondary)
        }

        switch result.outcome {
        case .noResults:
            VStack(alignment: .leading, spacing: 8) {
                Label("No Wikipedia Article Found", systemImage: "magnifyingglass")
                    .font(.subheadline.bold())
                Text("Wikipedia has no article matching “\(concept.name)”. The term may be specific to your course or spelled differently in your notes. Your own explanation above is unaffected.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

        case .ambiguous(let options):
            if let article = viewModel.selectedArticle {
                Button("Show All Meanings", systemImage: "chevron.left") {
                    viewModel.showAllMeanings()
                }
                .font(.footnote)
                .buttonStyle(.borderless)

                articleView(article)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Several Possible Meanings", systemImage: "arrow.triangle.branch")
                        .font(.subheadline.bold())
                    Text("“\(concept.name)” can refer to different things on Wikipedia. Choose the article that matches your notes:")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    matchList(options)
                }
            }

        case .article(let best, let otherMatches):
            let shown = viewModel.selectedArticle ?? best
            if shown == best && !viewModel.isCloseMatch(best) {
                Label("Closest match on Wikipedia for “\(concept.name)”.", systemImage: "info.circle")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            articleView(shown)

            let alternatives = ([best] + otherMatches).filter { $0 != shown }
            if !alternatives.isEmpty {
                DisclosureGroup("Not the right article? Other matches (\(alternatives.count))") {
                    matchList(alternatives)
                        .padding(.top, 8)
                }
                .font(.subheadline)
                .tint(.teal)
            }
        }
    }

    private func articleView(_ article: WikipediaArticle) -> some View {
        WikipediaArticleView(
            article: article,
            savedNote: viewModel.existingNote(for: article, in: notesViewModel.notes),
            justSaved: viewModel.lastSavedNoteTitle == article.title,
            onSave: { viewModel.saveAsNote(article, to: notesViewModel) }
        )
        // Fresh expand/collapse state for each article.
        .id(article.id)
    }

    /// Search results or disambiguation choices, each tappable to show that article.
    private func matchList(_ articles: [WikipediaArticle]) -> some View {
        VStack(spacing: 8) {
            ForEach(articles) { article in
                Button {
                    withAnimation { viewModel.select(article) }
                } label: {
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(article.title)
                                .font(.subheadline.weight(.semibold))
                            if let description = article.shortDescription {
                                Text(description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        Spacer(minLength: 0)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.teal.opacity(0.08), in: .rect(cornerRadius: 10))
                    .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .accessibilityHint("Shows this Wikipedia article.")
            }
        }
    }
}

// MARK: - Article

/// One Wikipedia article: title, description, summary, source link, and Add to Notes.
private struct WikipediaArticleView: View {
    let article: WikipediaArticle
    /// The `.wikipedia` note already saved for this article, if any.
    let savedNote: StudyNote?
    let justSaved: Bool
    let onSave: () -> Void

    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(article.title)
                    .font(.headline)
                if let description = article.shortDescription {
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            if let summary = article.summary {
                Text(summary)
                    .font(.subheadline)
                    .lineLimit(isExpanded ? nil : 8)
                    .fixedSize(horizontal: false, vertical: true)
                    .textSelection(.enabled)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.teal.opacity(0.08), in: .rect(cornerRadius: 10))

                // Only long introductions need the toggle.
                if summary.count > 600 {
                    Button(isExpanded ? "Show Less" : "Show More") {
                        withAnimation { isExpanded.toggle() }
                    }
                    .font(.footnote)
                    .buttonStyle(.borderless)
                }
            } else {
                Label("Wikipedia didn't include a summary for this article. Open the page to read it.", systemImage: "text.badge.xmark")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            sourceLink
            saveSection
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var sourceLink: some View {
        if let url = article.url {
            VStack(alignment: .leading, spacing: 2) {
                Link(destination: url) {
                    Label("Read on Wikipedia", systemImage: "safari")
                }
                .font(.subheadline.weight(.medium))
                .tint(.teal)

                Text(url.absoluteString)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .textSelection(.enabled)
            }
        } else {
            Label("A link to this article isn't available.", systemImage: "link.badge.plus")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var saveSection: some View {
        if let savedNote {
            Label(justSaved ? "Added to Notes as “\(savedNote.title)”." : "Already in your Notes as “\(savedNote.title)”.",
                  systemImage: "checkmark.circle.fill")
                .font(.subheadline)
                .foregroundStyle(.green)
                .fixedSize(horizontal: false, vertical: true)
        } else {
            VStack(alignment: .leading, spacing: 6) {
                Button(action: onSave) {
                    Label("Add to Notes", systemImage: "note.text.badge.plus")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(.teal)
                .disabled(article.summary == nil)

                Text(article.summary == nil
                     ? "There's no summary text to save for this article."
                     : "Saves this text as a separate note marked Wikipedia, with its link. Like any note, it's only studied when it's part of the study source you generate from.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#if DEBUG
// Preview-only sample data; the app always shows live Wikipedia results.
private extension StudyConcept {
    static let previewMitochondria = StudyConcept(
        name: "Mitochondria",
        explanation: "Organelles that release energy from food as ATP during cellular respiration.",
        origin: .keyConcepts
    )
}

private extension WikipediaArticle {
    static let previewMitochondrion = WikipediaArticle(
        id: 19588,
        title: "Mitochondrion",
        shortDescription: "Organelle in eukaryotic cells responsible for respiration",
        summary: "A mitochondrion is an organelle found in the cells of most eukaryotes, such as animals, plants and fungi. Mitochondria have a double membrane structure and use aerobic respiration to generate adenosine triphosphate (ATP), which is used throughout the cell as a source of chemical energy.",
        url: URL(string: "https://en.wikipedia.org/wiki/Mitochondrion")
    )
}

private func previewDetail(_ concept: StudyConcept = .previewMitochondria, phase: ConceptEnrichmentViewModel.Phase) -> some View {
    let viewModel = ConceptEnrichmentViewModel(concept: concept)
    viewModel.loadPreviewPhase(phase)
    return NavigationStack {
        ConceptDetailView(concept: concept, viewModel: viewModel)
    }
    .environment(NotesViewModel())
}

#Preview("Idle") {
    previewDetail(phase: .idle)
}

#Preview("Loading") {
    previewDetail(phase: .loading)
}

#Preview("Wikipedia Result") {
    previewDetail(phase: .loaded(WikipediaLookupResult(
        concept: "Mitochondria",
        outcome: .article(.previewMitochondrion, otherMatches: [
            WikipediaArticle(id: 2, title: "Mitochondrial DNA", shortDescription: "DNA located in mitochondria", summary: "Mitochondrial DNA is the DNA located in the mitochondria.", url: nil)
        ])
    )))
}

#Preview("Ambiguous") {
    previewDetail(StudyConcept(name: "Mercury", explanation: "A liquid metal used in old thermometers.", origin: .brainMap),
                  phase: .loaded(WikipediaLookupResult(concept: "Mercury", outcome: .ambiguous(options: [
                      WikipediaArticle(id: 3, title: "Mercury (planet)", shortDescription: "First planet from the Sun", summary: "Mercury is the first planet from the Sun.", url: nil),
                      WikipediaArticle(id: 4, title: "Mercury (element)", shortDescription: "Chemical element with atomic number 80 (Hg)", summary: "Mercury is a chemical element.", url: nil)
                  ]))))
}

#Preview("No Results") {
    previewDetail(StudyConcept(name: "Xqzvplorbnk", explanation: nil, origin: .brainMap),
                  phase: .loaded(WikipediaLookupResult(concept: "Xqzvplorbnk", outcome: .noResults)))
}

#Preview("Offline") {
    previewDetail(phase: .failed(.offline))
}
#endif
