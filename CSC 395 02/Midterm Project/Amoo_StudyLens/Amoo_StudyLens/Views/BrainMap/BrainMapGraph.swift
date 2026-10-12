import Foundation

/// A node in the Brain Map: either the central topic or one generated concept.
struct BrainMapNode: Identifiable, Equatable {
    enum Kind {
        case central
        case concept
    }

    let id: String
    let title: String
    let kind: Kind
    /// The matching explanation from the guide's key concepts, when the model produced one.
    let explanation: String?
}

/// A directed, labeled connection taken from one generated `ConceptRelationship`.
struct BrainMapEdge: Identifiable, Equatable {
    let id: Int
    let sourceID: String
    let targetID: String
    let label: String
}

/// View-ready graph built from the model's `BrainMap`.
///
/// The model writes relationships as free text, so their source/target names don't always match
/// the concept list exactly. This type resolves each name to a node so lines can be drawn.
/// It contains no layout code and never calls the model.
struct BrainMapGraph: Equatable {
    static let centralID = "central-topic"

    /// The central topic first, then concepts in the order the model generated them.
    let nodes: [BrainMapNode]
    let edges: [BrainMapEdge]

    var central: BrainMapNode { nodes[0] }
    var concepts: ArraySlice<BrainMapNode> { nodes.dropFirst() }

    init(brainMap: BrainMap, keyConcepts: [KeyConcept] = []) {
        let explanations = Dictionary(
            keyConcepts.map { (Self.normalize($0.name), $0.explanation) },
            uniquingKeysWith: { first, _ in first }
        )

        let topic = brainMap.centralTopic.trimmingCharacters(in: .whitespacesAndNewlines)
        let centralTitle = topic.isEmpty ? "Your Notes" : topic
        let centralKey = Self.normalize(centralTitle)

        var nodes = [
            BrainMapNode(
                id: Self.centralID,
                title: centralTitle,
                kind: .central,
                explanation: explanations[centralKey]
            )
        ]
        // Normalized name -> node ID. A concept that repeats the central topic merges into it.
        var idsByKey = [centralKey: Self.centralID]

        func addConcept(named name: String) -> String? {
            let title = name.trimmingCharacters(in: .whitespacesAndNewlines)
            let key = Self.normalize(title)
            guard !key.isEmpty else { return nil }
            if let existing = idsByKey[key] { return existing }

            let id = "concept-\(key)"
            idsByKey[key] = id
            nodes.append(BrainMapNode(id: id, title: title, kind: .concept, explanation: explanations[key]))
            return id
        }

        func resolve(_ name: String) -> String? {
            let key = Self.normalize(name)
            guard !key.isEmpty else { return nil }
            if let exact = idsByKey[key] { return exact }

            // The model sometimes shortens or extends a name ("Cell" vs. "The cell membrane").
            // Accept a containment match only when exactly one node qualifies.
            if key.count >= 3 {
                let matches = idsByKey.filter { $0.key.contains(key) || key.contains($0.key) }
                if matches.count == 1, let match = matches.first {
                    return match.value
                }
            }

            // Otherwise the relationship names a generated concept that wasn't in the concept list.
            return addConcept(named: name)
        }

        for concept in brainMap.concepts {
            _ = addConcept(named: concept)
        }

        var edges: [BrainMapEdge] = []
        var seenPairs = Set<String>()
        for relationship in brainMap.relationships {
            guard let sourceID = resolve(relationship.source),
                  let targetID = resolve(relationship.target),
                  sourceID != targetID,
                  seenPairs.insert("\(sourceID)->\(targetID)").inserted
            else { continue }

            edges.append(
                BrainMapEdge(
                    id: edges.count,
                    sourceID: sourceID,
                    targetID: targetID,
                    label: relationship.relationship.trimmingCharacters(in: .whitespacesAndNewlines)
                )
            )
        }

        self.nodes = nodes
        self.edges = edges
    }

    func node(withID id: String) -> BrainMapNode? {
        nodes.first { $0.id == id }
    }

    func edges(involving id: String) -> [BrainMapEdge] {
        edges.filter { $0.sourceID == id || $0.targetID == id }
    }

    /// IDs of every node joined to `id` by a generated relationship, in either direction.
    func neighborIDs(of id: String) -> Set<String> {
        Set(edges(involving: id).map { $0.sourceID == id ? $0.targetID : $0.sourceID })
    }

    /// Lowercased, accent-free, punctuation-free form used to match concept names.
    static func normalize(_ name: String) -> String {
        name.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil)
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}
