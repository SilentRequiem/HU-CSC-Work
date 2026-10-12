import Foundation

/// Looks up StudyLens concepts on English Wikipedia through the public MediaWiki Action API.
///
/// This is the only place in the app that talks to the network. Views never call it directly;
/// `ConceptEnrichmentViewModel` does, and only when the user taps Learn More. Opening the Study
/// tab, generating a guide, Quiz Me, Flashcards, and Brain Map never contact Wikipedia.
///
/// It is an `actor`, so the in-memory cache can be read and written safely from any task, and
/// networking/JSON decoding run off the main actor.
actor WikipediaService {
    /// One shared instance for the app session, so every Concept Detail screen shares one cache.
    static let shared = WikipediaService()

    nonisolated static let host = "en.wikipedia.org"

    /// Wikimedia asks API clients to identify themselves with a descriptive User-Agent.
    /// See https://meta.wikimedia.org/wiki/User-Agent_policy
    private nonisolated static let userAgent = "StudyLens/1.0 (CSC 395 student study app; Swift URLSession)"
    /// How many search results to fetch: the best match plus a few alternatives.
    private nonisolated static let resultLimit = 6
    /// CirrusSearch rejects search strings longer than 300 characters.
    private nonisolated static let maxQueryLength = 300

    private let session: URLSession

    // MARK: Cache
    //
    // A lightweight, session-only cache keyed by the *normalized* concept name, so reopening a
    // concept (or opening the same concept from Key Concepts, Flashcards, and the Brain Map)
    // doesn't repeat the request. Only successful lookups are cached — including "no results",
    // which is a valid answer — so after an error, Try Again really does contact Wikipedia again.
    // Nothing is written to disk; the cache disappears when StudyLens quits.
    private var cache: [String: WikipediaLookupResult] = [:]

    init(session: URLSession? = nil) {
        if let session {
            self.session = session
        } else {
            let configuration = URLSessionConfiguration.ephemeral
            // Fail fast with a clear "offline" message instead of waiting silently for a network.
            configuration.waitsForConnectivity = false
            configuration.timeoutIntervalForRequest = 15
            self.session = URLSession(configuration: configuration)
        }
    }

    /// Searches Wikipedia for `concept` and returns the best match, alternatives, or a
    /// disambiguation choice. Answers from the cache when the same concept was looked up earlier
    /// in this session.
    ///
    /// - Throws: `WikipediaError` for network/API problems, or `CancellationError` when the
    ///   calling task is cancelled (the user tapped Cancel or left the screen).
    func lookUp(concept: String) async throws -> WikipediaLookupResult {
        let key = Self.cacheKey(for: concept)
        guard !key.isEmpty else { throw WikipediaError.invalidRequest }

        if let cached = cache[key] {
            return cached
        }

        let request = try Self.makeSearchRequest(for: concept)
        let response = try await perform(request)
        let result = Self.makeResult(concept: concept, response: response)

        // A result that arrives after cancellation is discarded rather than cached or shown.
        try Task.checkCancellation()
        cache[key] = result
        return result
    }

    /// Whether a lookup for `concept` is already cached (lets the UI skip the loading state).
    func cachedResult(for concept: String) -> WikipediaLookupResult? {
        cache[Self.cacheKey(for: concept)]
    }

    // MARK: - Request construction

    /// Builds one request that both *searches* and *fetches summaries*, using the search as a
    /// "generator" for page properties:
    ///
    /// `https://en.wikipedia.org/w/api.php?action=query&format=json&formatversion=2`
    /// `&generator=search&gsrsearch=<concept>&gsrlimit=6`
    /// `&prop=extracts|info|pageprops|description`
    /// `&exintro=1&explaintext=1&exlimit=max&inprop=url&ppprop=disambiguation&redirects=1`
    ///
    /// - `generator=search` / `gsrsearch`: full-text search; each hit becomes a page in the result.
    /// - `prop=extracts` + `exintro` + `explaintext`: the article's introduction as plain text.
    /// - `prop=info` + `inprop=url`: the page's canonical URL (`fullurl`).
    /// - `prop=pageprops` + `ppprop=disambiguation`: flags "may refer to…" pages.
    /// - `prop=description`: the short Wikidata description.
    /// - `redirects=1`: follow redirects such as "Mitochondria" → "Mitochondrion".
    /// - `origin=*` is not needed (that's for browsers); `formatversion=2` gives cleaner JSON.
    ///
    /// `URLComponents` percent-encodes the concept, so names with spaces, accents, or symbols
    /// ("Na+/K+ pump", "Schrödinger equation") are safe.
    nonisolated static func makeSearchRequest(for concept: String) throws -> URLRequest {
        let searchText = String(concept.trimmingCharacters(in: .whitespacesAndNewlines).prefix(maxQueryLength))
        guard !searchText.isEmpty else { throw WikipediaError.invalidRequest }

        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = "/w/api.php"
        components.queryItems = [
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "formatversion", value: "2"),
            URLQueryItem(name: "generator", value: "search"),
            URLQueryItem(name: "gsrsearch", value: searchText),
            URLQueryItem(name: "gsrlimit", value: String(resultLimit)),
            URLQueryItem(name: "prop", value: "extracts|info|pageprops|description"),
            URLQueryItem(name: "exintro", value: "1"),
            URLQueryItem(name: "explaintext", value: "1"),
            URLQueryItem(name: "exlimit", value: "max"),
            URLQueryItem(name: "inprop", value: "url"),
            URLQueryItem(name: "ppprop", value: "disambiguation"),
            URLQueryItem(name: "redirects", value: "1")
        ]
        // URLComponents leaves "+" unencoded, but servers read a query-string "+" as a space,
        // so "Na+/K+ pump" would be searched as "Na /K  pump". Encode it explicitly.
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

        guard let url = components.url else { throw WikipediaError.invalidRequest }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }

    // MARK: - Networking & error handling

    /// Sends the request with async/await and decodes the JSON, translating every failure into a
    /// `WikipediaError` with a readable message. Cancellation is passed through as
    /// `CancellationError` so callers can treat it as a user action, not an error.
    private func perform(_ request: URLRequest) async throws -> WikipediaQueryResponse {
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch let error as URLError {
            throw Self.mapURLError(error)
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            throw WikipediaError.network(error.localizedDescription)
        }

        if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            throw WikipediaError.httpStatus(http.statusCode)
        }

        // Codable parsing: JSONDecoder fills `WikipediaQueryResponse` directly. Because every
        // field the API may leave out is optional, only structurally wrong JSON (an HTML error
        // page, a truncated body) fails here.
        let decoded: WikipediaQueryResponse
        do {
            decoded = try JSONDecoder().decode(WikipediaQueryResponse.self, from: data)
        } catch {
            throw WikipediaError.unreadableResponse
        }

        if let apiError = decoded.error {
            throw WikipediaError.api(apiError.info ?? apiError.code ?? "Unknown error.")
        }
        return decoded
    }

    private nonisolated static func mapURLError(_ error: URLError) -> Error {
        switch error.code {
        case .cancelled:
            // URLSession reports task cancellation as URLError.cancelled.
            return CancellationError()
        case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed, .internationalRoamingOff,
             .cannotFindHost, .cannotConnectToHost, .dnsLookupFailed:
            return WikipediaError.offline
        case .timedOut:
            return WikipediaError.timedOut
        case .badURL, .unsupportedURL:
            return WikipediaError.invalidRequest
        default:
            return WikipediaError.network(error.localizedDescription)
        }
    }

    // MARK: - Response → app model

    /// Turns the decoded pages into a `WikipediaLookupResult`:
    /// - no pages → `.noResults` (e.g. a nonsense concept);
    /// - top-ranked page is a disambiguation page → `.ambiguous` with the real articles as choices;
    /// - otherwise → `.article` with the top match and the rest as "other matches".
    nonisolated static func makeResult(concept: String, response: WikipediaQueryResponse) -> WikipediaLookupResult {
        let pages = (response.query?.pages ?? [])
            .sorted { ($0.index ?? .max) < ($1.index ?? .max) }
        let articles = pages.compactMap(WikipediaArticle.init(page:))

        guard let best = articles.first else {
            return WikipediaLookupResult(concept: concept, outcome: .noResults)
        }

        let realArticles = articles.filter { !$0.isDisambiguation }
        if best.isDisambiguation, !realArticles.isEmpty {
            return WikipediaLookupResult(concept: concept, outcome: .ambiguous(options: realArticles))
        }

        let others = articles.dropFirst().filter { !$0.isDisambiguation }
        return WikipediaLookupResult(concept: concept, outcome: .article(best, otherMatches: Array(others)))
    }

    /// The cache key: case-, accent-, and spacing-insensitive, so "Mitochondria",
    /// " mitochondria " and "MITOCHONDRIA" share one entry.
    nonisolated static func cacheKey(for concept: String) -> String {
        concept
            .folding(options: [.caseInsensitive, .diacriticInsensitive, .widthInsensitive], locale: nil)
            .split(whereSeparator: \.isWhitespace)
            .joined(separator: " ")
    }
}
