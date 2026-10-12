import Foundation
import Observation

/// Drives the "From Wikipedia" part of `ConceptDetailView` for one concept.
///
/// Holds only external-lookup state (loading, result, error, which article is showing). It never
/// reads or writes the study guide, so Wikipedia text can't leak into Summary, Key Concepts,
/// Quiz Me grading, Flashcards, or the Brain Map. The single bridge into the user's material is
/// `saveAsNote(_:to:)`, which runs only when the user taps Add to Notes.
@MainActor
@Observable
final class ConceptEnrichmentViewModel {
    enum Phase: Equatable {
        /// Nothing requested yet (the screen never contacts Wikipedia on its own).
        case idle
        case loading
        case loaded(WikipediaLookupResult)
        case failed(WikipediaError)
    }

    let concept: StudyConcept
    private(set) var phase: Phase = .idle
    /// The article currently shown: the best match, or one the user picked from the other
    /// matches / disambiguation choices. Nil while choosing between meanings.
    private(set) var selectedArticle: WikipediaArticle?
    /// True when the last result came from this session's cache instead of a new request.
    private(set) var isFromCache = false
    /// True after the user cancels a search, so the idle state can say so.
    private(set) var wasCancelled = false
    /// Title of the note just created by Add to Notes, for the confirmation message.
    private(set) var lastSavedNoteTitle: String?

    @ObservationIgnored private let service: WikipediaService
    @ObservationIgnored private var task: Task<Void, Never>?
    /// Identifies the latest request, so a cancelled request finishing late can't overwrite it.
    @ObservationIgnored private var requestID = UUID()

    init(concept: StudyConcept, service: WikipediaService = .shared) {
        self.concept = concept
        self.service = service
    }

    var isLoading: Bool { phase == .loading }

    // MARK: - Lookup

    /// Starts a Wikipedia lookup for the concept. Called only from the Learn More / Try Again buttons.
    func learnMore() {
        guard !isLoading else { return }
        task?.cancel()

        let id = UUID()
        requestID = id
        phase = .loading
        wasCancelled = false
        selectedArticle = nil

        task = Task { [service, concept] in
            do {
                // Cache first: a concept looked up earlier this session appears instantly,
                // without a second network request.
                if let cached = await service.cachedResult(for: concept.name) {
                    apply(cached, fromCache: true, requestID: id)
                    return
                }
                let result = try await service.lookUp(concept: concept.name)
                apply(result, fromCache: false, requestID: id)
            } catch is CancellationError {
                // Cancelling is a normal user action, not a failure; `cancel()` already reset the state.
                return
            } catch let error as WikipediaError {
                guard requestID == id else { return }
                phase = .failed(error)
            } catch {
                guard requestID == id else { return }
                phase = .failed(.network(error.localizedDescription))
            }
        }
    }

    /// Stops an in-flight search. `userInitiated` is false when the screen simply goes away,
    /// in which case there's no one to show a "cancelled" message to.
    func cancel(userInitiated: Bool = true) {
        guard let task else { return }
        task.cancel()
        self.task = nil
        requestID = UUID()
        if isLoading {
            phase = .idle
            wasCancelled = userInitiated
        }
    }

    private func apply(_ result: WikipediaLookupResult, fromCache: Bool, requestID id: UUID) {
        guard requestID == id else { return }
        isFromCache = fromCache
        phase = .loaded(result)
        task = nil
        switch result.outcome {
        case .article(let best, _): selectedArticle = best
        // Let the user choose: showing the first option could present the wrong meaning.
        case .ambiguous, .noResults: selectedArticle = nil
        }
    }

    #if DEBUG
    /// Lets previews show each state without contacting Wikipedia.
    func loadPreviewPhase(_ phase: Phase) {
        if case .loaded(let result) = phase {
            apply(result, fromCache: false, requestID: requestID)
        } else {
            self.phase = phase
        }
    }
    #endif

    // MARK: - Choosing between matches

    func select(_ article: WikipediaArticle) {
        selectedArticle = article
        lastSavedNoteTitle = nil
    }

    /// Returns to the list of meanings for an ambiguous concept.
    func showAllMeanings() {
        selectedArticle = nil
        lastSavedNoteTitle = nil
    }

    /// Whether the best match's title clearly is the concept (otherwise the UI calls it a
    /// "closest match", e.g. "Light reactions" → "Light-dependent reactions").
    func isCloseMatch(_ article: WikipediaArticle) -> Bool {
        let title = WikipediaService.cacheKey(for: article.title)
        let name = WikipediaService.cacheKey(for: concept.name)
        // Allow simple plurals ("Ribosomes" → "Ribosome", "Mitochondria" → "Mitochondrion").
        return title == name || title.hasPrefix(name) || name.hasPrefix(title)
            || title.dropLast(2) == name.dropLast(1) || title.dropLast(1) == name.dropLast(2)
    }

    // MARK: - Saving external information as a note

    /// The `.wikipedia` note already saved for this article, if any, so it isn't saved twice.
    func existingNote(for article: WikipediaArticle, in notes: [StudyNote]) -> StudyNote? {
        notes.first { note in
            guard note.source == .wikipedia, let source = note.externalSource else { return false }
            if let url = article.url, let savedURL = source.url { return url == savedURL }
            return source.articleTitle == article.title
        }
    }

    /// Saves the article as a new StudyLens note — only ever called from the Add to Notes button.
    ///
    /// The note goes through the same `NotesViewModel.add` path as every other capture, so it is
    /// persisted by SwiftData, appears in the Notes tab, can be exported or deleted, and can be
    /// chosen as a study source like any other note. It is clearly marked as external:
    ///   • `source = .wikipedia` (shown as "Wikipedia" with a globe icon everywhere notes appear);
    ///   • `externalSource` keeps the article title and URL (stored in SwiftData);
    ///   • the body ends with an attribution block, so the source survives export as plain text.
    /// Saving doesn't touch the current study guide; it only becomes study material when the user
    /// generates a guide whose source includes this note.
    func saveAsNote(_ article: WikipediaArticle, to notesViewModel: NotesViewModel) {
        guard existingNote(for: article, in: notesViewModel.notes) == nil,
              let note = Self.makeNote(from: article, concept: concept) else { return }
        notesViewModel.add(note)
        lastSavedNoteTitle = note.title
    }

    /// Builds the note. Returns nil when the article has no summary, since there'd be no study text to save.
    static func makeNote(from article: WikipediaArticle, concept: StudyConcept, date: Date = .now) -> StudyNote? {
        guard let summary = article.summary else { return nil }

        var attribution = [
            "Source: Wikipedia — “\(article.title)”"
        ]
        if let url = article.url {
            attribution.append(url.absoluteString)
        }
        attribution.append("Saved with Learn More for the StudyLens concept “\(concept.name)” on \(date.formatted(date: .abbreviated, time: .omitted)). Wikipedia text is available under the Creative Commons Attribution-ShareAlike 4.0 License.")

        return StudyNote(
            title: article.title,
            body: summary + "\n\n—\n" + attribution.joined(separator: "\n"),
            source: .wikipedia,
            createdAt: date,
            externalSource: ExternalSourceInfo(articleTitle: article.title, url: article.url)
        )
    }
}
