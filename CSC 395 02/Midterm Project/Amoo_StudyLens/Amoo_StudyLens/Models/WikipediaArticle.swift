import Foundation

// MARK: - Wikipedia models
//
// Two layers:
//   1. `WikipediaQueryResponse` mirrors the raw MediaWiki Action API JSON exactly (Codable).
//      It is internal to `WikipediaService` and never reaches a view.
//   2. `WikipediaArticle` / `WikipediaLookupResult` are the cleaned-up app models the UI shows.
// Everything here is external information. None of these types is ever written into a
// `StudyAnalysis`, Quiz Me, Flashcards, or the Brain Map; only an explicit "Add to Notes" turns an
// article into a `StudyNote`.

// MARK: Raw API response (Codable)

/// The JSON returned by `api.php?action=query&format=json&formatversion=2&generator=search&prop=…`.
///
/// Example (trimmed):
/// ```json
/// { "batchcomplete": true,
///   "query": { "pages": [
///     { "pageid": 19588, "title": "Mitochondrion", "index": 1,
///       "description": "Organelle in eukaryotic cells responsible for respiration",
///       "extract": "A mitochondrion is an organelle…",
///       "fullurl": "https://en.wikipedia.org/wiki/Mitochondrion",
///       "pageprops": { "disambiguation": "" } } ] } }
/// ```
/// `formatversion=2` makes `pages` an array (not a dictionary keyed by page ID) and booleans real
/// JSON booleans, which maps cleanly onto Swift types. Every field the API may omit is optional,
/// so a missing value decodes as nil instead of failing the whole response.
nonisolated struct WikipediaQueryResponse: Decodable, Sendable {
    /// Absent when the search matched nothing; the response is then just `{"batchcomplete":true}`.
    let query: Query?
    /// Present instead of `query` when the API rejects the request (bad parameter, rate limit…).
    let error: APIError?

    struct Query: Decodable, Sendable {
        let pages: [Page]?
    }

    struct Page: Decodable, Sendable {
        let pageid: Int?
        let title: String
        /// 1-based search rank. Pages come back in arbitrary order, so results are sorted by this.
        let index: Int?
        /// Plain-text introduction (requested with `exintro` + `explaintext`). Can be missing or empty.
        let extract: String?
        /// Wikidata short description, e.g. "Organelle in eukaryotic cells responsible for respiration".
        let description: String?
        /// Canonical page URL (requested with `inprop=url`).
        let fullurl: String?
        /// `pageprops.disambiguation` exists (with an empty string value) only on disambiguation pages.
        let pageprops: PageProps?
        /// True for a requested title that doesn't exist.
        let missing: Bool?
    }

    struct PageProps: Decodable, Sendable {
        let disambiguation: String?
    }

    struct APIError: Decodable, Sendable {
        let code: String?
        let info: String?
    }
}

// MARK: App models

/// One Wikipedia article, cleaned up for display.
nonisolated struct WikipediaArticle: Identifiable, Hashable, Sendable {
    let id: Int
    let title: String
    /// Wikidata short description, if Wikipedia has one.
    let shortDescription: String?
    /// The article's introduction as plain text, or nil when Wikipedia returned no usable extract.
    let summary: String?
    /// The article's web page, or nil when the API returned a URL that couldn't be parsed.
    let url: URL?
    /// Disambiguation pages only list other articles ("Mercury may refer to…").
    let isDisambiguation: Bool

    /// Converts one raw API page into an app model. Returns nil for pages that don't exist.
    init?(page: WikipediaQueryResponse.Page) {
        guard page.missing != true, let pageID = page.pageid else { return nil }
        id = pageID
        title = page.title
        shortDescription = page.description.flatMap(Self.nonEmpty)
        summary = page.extract.map(Self.cleanExtract).flatMap(Self.nonEmpty)
        url = Self.makeURL(fullURL: page.fullurl, title: page.title)
        isDisambiguation = page.pageprops?.disambiguation != nil
    }

    init(id: Int, title: String, shortDescription: String?, summary: String?, url: URL?, isDisambiguation: Bool = false) {
        self.id = id
        self.title = title
        self.shortDescription = shortDescription
        self.summary = summary
        self.url = url
        self.isDisambiguation = isDisambiguation
    }

    /// Uses the API's `fullurl` when it's a valid https URL; otherwise rebuilds the standard
    /// `https://en.wikipedia.org/wiki/Title_With_Underscores` address from the title. Returns nil
    /// (the UI then hides the link) if neither produces a valid URL.
    private static func makeURL(fullURL: String?, title: String) -> URL? {
        if let fullURL, let url = URL(string: fullURL), url.scheme == "https", url.host() != nil {
            return url
        }
        var components = URLComponents()
        components.scheme = "https"
        components.host = WikipediaService.host
        components.path = "/wiki/" + title.replacingOccurrences(of: " ", with: "_")
        return components.url
    }

    /// `explaintext` extracts keep empty brackets where pronunciation markup was removed
    /// ("A ribosome () is…") and can have runs of blank lines; tidy both.
    private static func cleanExtract(_ text: String) -> String {
        text
            .replacing(/\s*\(\s*[;,]?\s*\)/, with: "")
            .replacing(/\n{3,}/, with: "\n\n")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func nonEmpty(_ text: String) -> String? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}

/// What a Learn More search found for one concept.
nonisolated struct WikipediaLookupResult: Hashable, Sendable {
    enum Outcome: Hashable, Sendable {
        /// A best match, plus other search results the user can switch to.
        case article(WikipediaArticle, otherMatches: [WikipediaArticle])
        /// The concept's name has several meanings on Wikipedia (the top result was a
        /// disambiguation page), so the user picks the one that matches their notes.
        case ambiguous(options: [WikipediaArticle])
        /// Wikipedia had nothing for this search.
        case noResults
    }

    /// The concept name that was searched for.
    let concept: String
    let outcome: Outcome
}

// MARK: Errors

/// User-facing Wikipedia failures. Each message says what happened and reassures the user that
/// the rest of StudyLens (which runs on device) is unaffected.
/// Cancellation is deliberately *not* a case: it is reported as `CancellationError` and treated as
/// a normal user action rather than a failure.
nonisolated enum WikipediaError: LocalizedError, Hashable, Sendable {
    /// No internet connection (offline, airplane mode, Wi-Fi without internet).
    case offline
    /// The server took too long to answer.
    case timedOut
    /// The request URL couldn't be built (e.g. an unusable concept name).
    case invalidRequest
    /// Wikipedia answered with a non-success HTTP status, such as 429 or 503.
    case httpStatus(Int)
    /// Wikipedia answered but reported an API error.
    case api(String)
    /// The response wasn't the JSON StudyLens expects.
    case unreadableResponse
    /// Any other networking failure.
    case network(String)

    var errorDescription: String? {
        switch self {
        case .offline:
            "You appear to be offline. Connect to the internet to look this up on Wikipedia."
        case .timedOut:
            "Wikipedia took too long to respond. Check your connection and try again."
        case .invalidRequest:
            "StudyLens couldn't build a Wikipedia search for this concept."
        case .httpStatus(let code) where code == 429:
            "Wikipedia is receiving too many requests right now. Wait a moment and try again."
        case .httpStatus(let code):
            "Wikipedia couldn't be reached right now (HTTP \(code)). Try again later."
        case .api(let info):
            "Wikipedia reported a problem: \(info)"
        case .unreadableResponse:
            "Wikipedia sent a response StudyLens couldn't read. Try again later."
        case .network(let description):
            "Wikipedia couldn't be reached. \(description)"
        }
    }
}
