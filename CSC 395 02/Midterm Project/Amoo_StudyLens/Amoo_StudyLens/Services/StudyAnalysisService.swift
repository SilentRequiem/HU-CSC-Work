import Foundation
import FoundationModels

/// Whether the on-device model can be used right now, translated into app terms
/// so the UI doesn't need to know about Foundation Models types.
enum StudyModelAvailability: Equatable {
    case available
    case unavailable(title: String, message: String)
}

/// Study material assembled from saved notes, ready to send to the model.
struct StudyMaterial {
    let text: String
    let includedNoteCount: Int
    let wasTruncated: Bool
}

/// Errors surfaced to the Study screen with user-facing messages.
struct StudyAnalysisError: LocalizedError {
    let message: String
    var errorDescription: String? { message }
}

/// Owns all Foundation Models logic for StudyLens: availability checks,
/// prompt construction from saved notes, and guided generation of a `StudyAnalysis`.
struct StudyAnalysisService {
    /// Approximate character budget for note content. The on-device model has a limited
    /// context window shared by instructions, the generation schema, the notes, and the
    /// response, so very long note collections are trimmed to fit.
    static let maxMaterialCharacters = 6_000

    /// Apple's on-device system language model (the model behind Apple Intelligence).
    private let model = SystemLanguageModel.default

    // MARK: - Availability

    /// Checks whether the on-device model is ready before any generation request is made.
    func checkAvailability() -> StudyModelAvailability {
        // Foundation Models: `availability` reports whether this device can run the model now.
        switch model.availability {
        case .available:
            return .available
        case .unavailable(.deviceNotEligible):
            return .unavailable(
                title: "Device Not Supported",
                message: "This device can't run Apple Intelligence, so AI study guides aren't available. Your notes still work normally."
            )
        case .unavailable(.appleIntelligenceNotEnabled):
            return .unavailable(
                title: "Apple Intelligence Is Off",
                message: "Turn on Apple Intelligence in Settings to generate study guides from your notes."
            )
        case .unavailable(.modelNotReady):
            return .unavailable(
                title: "Model Not Ready",
                message: "The on-device model is still downloading or preparing. Try again in a few minutes."
            )
        case .unavailable:
            return .unavailable(
                title: "Study Guide Unavailable",
                message: "The on-device language model isn't available right now. Try again later."
            )
        }
    }

    // MARK: - Prompt construction

    /// Combines the *selected* notes' titles and bodies into clearly separated, numbered blocks so
    /// the model can tell where one note ends and the next begins. Callers pass only the notes in
    /// the user's study scope (All Notes, Selected Notes, or a Single Note); nothing else is sent.
    func makeStudyMaterial(from notes: [StudyNote]) -> StudyMaterial {
        let ordered = notes
            .filter { !$0.body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .sorted { $0.createdAt < $1.createdAt }
        let bodies = ordered.map { $0.body.trimmingCharacters(in: .whitespacesAndNewlines) }
        let allowances = Self.fairShares(of: Self.maxMaterialCharacters, for: bodies.map(\.count))

        var blocks: [String] = []
        var wasTruncated = false

        for (index, note) in ordered.enumerated() {
            var body = bodies[index]
            if body.count > allowances[index] {
                body = String(body.prefix(allowances[index])) + " […]"
                wasTruncated = true
            }

            let title = note.title.trimmingCharacters(in: .whitespacesAndNewlines)
            blocks.append("""
                ### NOTE \(index + 1)
                Title: \(title.isEmpty ? "Untitled" : title)
                Content:
                \(body)
                ### END NOTE \(index + 1)
                """)
        }

        return StudyMaterial(
            text: blocks.joined(separator: "\n\n"),
            includedNoteCount: blocks.count,
            wasTruncated: wasTruncated
        )
    }

    /// Splits the character budget fairly across notes ("water filling"): short notes keep all of
    /// their text, and whatever they don't use is shared equally among the longer ones. Without
    /// this, one long imported PDF at the start of a study set would crowd out every later note.
    static func fairShares(of budget: Int, for lengths: [Int]) -> [Int] {
        var allowances = Array(repeating: 0, count: lengths.count)
        var remainingBudget = budget
        // Visit notes from shortest to longest so leftovers flow to the notes that need them.
        let order = lengths.indices.sorted { lengths[$0] < lengths[$1] }
        for (position, index) in order.enumerated() {
            let share = remainingBudget / max(order.count - position, 1)
            allowances[index] = min(lengths[index], share)
            remainingBudget -= allowances[index]
        }
        return allowances
    }

    /// Instructions keep the model grounded in the user's notes rather than outside knowledge.
    private static let instructions = """
        You are a study assistant that turns a student's notes into a short study guide.
        Base everything only on the information in the provided notes.
        Do not add outside facts, examples, or details just to make the guide longer.
        If the notes do not contain enough information for a concept, question, or answer, \
        say that the notes do not cover it instead of inventing one.
        Keep every explanation and answer concise and useful for studying.
        """

    // MARK: - Generation

    /// Sends the study material to the on-device model and returns a structured `StudyAnalysis`.
    func generateAnalysis(from material: StudyMaterial) async throws -> StudyAnalysis {
        // Re-check availability right before generating; the state can change at any time.
        guard case .available = checkAvailability() else {
            throw StudyAnalysisError(message: "The on-device model isn't available right now.")
        }

        // Foundation Models: a fresh LanguageModelSession per guide, configured with
        // grounding instructions. A new session keeps earlier guides out of the context window.
        let session = LanguageModelSession(model: model, instructions: Self.instructions)

        let prompt = """
            Create a study guide using only the student's notes below. \
            Each note is between "### NOTE" and "### END NOTE" markers.

            \(material.text)
            """

        do {
            // Foundation Models guided generation: `generating: StudyAnalysis.self` makes the
            // model fill in the @Generable type directly — no JSON prompt, no manual parsing.
            let response = try await session.respond(
                to: prompt,
                generating: StudyAnalysis.self,
                options: GenerationOptions(temperature: 0.3)
            )
            return response.content
        } catch let error as LanguageModelError {
            throw StudyAnalysisError(message: Self.message(for: error))
        } catch is LanguageModelSession.Error {
            throw StudyAnalysisError(message: "A study guide is already being generated. Please wait for it to finish.")
        } catch is SystemLanguageModel.Error {
            throw StudyAnalysisError(message: "The on-device model isn't ready yet. Try again in a few minutes.")
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            throw StudyAnalysisError(message: "The study guide couldn't be generated. Please try again.")
        }
    }

    /// Maps Foundation Models generation errors (the iOS/macOS 27 `LanguageModelError` type)
    /// to messages a student can act on.
    private static func message(for error: LanguageModelError) -> String {
        switch error {
        case .contextSizeExceeded:
            "Your notes are too long to analyze at once. Try removing some notes and generate again."
        case .guardrailViolation, .refusal:
            "The model couldn't create a study guide for this content. Try different notes."
        case .unsupportedLanguageOrLocale:
            "Your notes are in a language the on-device model doesn't support yet."
        case .rateLimited, .timeout:
            "The model is busy right now. Wait a moment and try again."
        default:
            "The study guide couldn't be generated. Please try again."
        }
    }
}
