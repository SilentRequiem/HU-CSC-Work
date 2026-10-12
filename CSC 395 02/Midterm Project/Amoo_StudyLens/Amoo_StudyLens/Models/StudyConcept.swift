import Foundation

/// A concept the user picked from their generated study material, used to open `ConceptDetailView`.
///
/// It is a small value copy (name + the guide's explanation), so it can be pushed onto a
/// navigation path. The detail screen never changes the guide; it only shows this copy next to
/// optional, clearly labeled Wikipedia information.
struct StudyConcept: Hashable {
    /// Where in StudyLens the concept was opened from, shown on the detail screen.
    enum Origin: Hashable {
        case keyConcepts
        case flashcards
        case brainMap

        var displayName: String {
            switch self {
            case .keyConcepts: "Key Concepts"
            case .flashcards: "Key Concept Flashcard"
            case .brainMap: "Brain Map"
            }
        }
    }

    let name: String
    /// The explanation generated from the user's notes. Nil for Brain Map nodes that aren't also
    /// Key Concepts (the map only stores their names).
    let explanation: String?
    let origin: Origin
}
