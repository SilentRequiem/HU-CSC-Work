import Foundation
import Observation

/// A generated study guide plus the context it was created from.
struct GeneratedStudyGuide: Identifiable {
    let id = UUID()
    let analysis: StudyAnalysis
    /// Exactly which notes (and versions of them) the guide was built from. Quiz Me, Flashcards,
    /// and Brain Map show this so the user always knows what they're studying.
    let source: StudySource
    let includedNoteCount: Int
    let wasTruncated: Bool

    /// IDs of the notes the guide was built from, used to detect when notes change.
    var sourceNoteIDs: Set<UUID> { source.noteIDSet }
}

/// Drives the Study workflow: which notes to study (`scope`), model availability, loading state,
/// the generated guide, and errors. Owned by `ContentView` and shared through the environment, so
/// the guide survives tab switches and is reused by Quiz Me, Flashcards, and Brain Map without
/// any further Foundation Models requests.
///
/// This type holds *data* only. It never decides navigation; see `AppNavigationModel`.
@MainActor
@Observable
final class StudyViewModel {
    private(set) var availability: StudyModelAvailability = .available
    private(set) var isGenerating = false
    private(set) var guide: GeneratedStudyGuide?
    private(set) var errorMessage: String?
    /// True when `errorMessage` came from a failed model request, so trying again may succeed
    /// (as opposed to "choose at least one note", which needs a different fix).
    private(set) var canRetryAfterError = false
    /// The study material the user has chosen for the *next* generation. Changing it never
    /// discards the current guide; the guide keeps describing its own `source`.
    var scope: StudyScope = .allNotes {
        didSet {
            // Remember picks so switching between the source options doesn't lose them.
            switch scope {
            case .selectedNotes(let ids): rememberedSelection = ids
            case .singleNote(let id): rememberedSingleNote = id
            case .allNotes: break
            }
        }
    }

    @ObservationIgnored
    private var rememberedSelection: Set<UUID> = []
    @ObservationIgnored
    private var rememberedSingleNote: UUID?
    @ObservationIgnored
    private let service: StudyAnalysisService

    init(service: StudyAnalysisService? = nil) {
        self.service = service ?? StudyAnalysisService()
        refreshAvailability()
    }

    /// The structured brain-map data from the latest guide.
    var brainMap: BrainMap? { guide?.analysis.brainMap }

    func refreshAvailability() {
        let latest = service.checkAvailability()
        // Only publish real changes, so views reading `availability` aren't invalidated needlessly.
        if latest != availability { availability = latest }
    }

    // MARK: - Study source selection

    /// Switches between All Notes / Selected Notes / Single Note, restoring earlier picks.
    func selectScopeKind(_ kind: StudyScopeKind, notes: [StudyNote]) {
        guard kind != scope.kind else { return }
        let existingIDs = Set(notes.map(\.id))
        switch kind {
        case .allNotes:
            scope = .allNotes
        case .selectedNotes:
            scope = .selectedNotes(rememberedSelection.intersection(existingIDs))
        case .singleNote:
            // Default to the newest note if nothing was picked before.
            let newest = notes.max { $0.createdAt < $1.createdAt }?.id
            guard let id = rememberedSingleNote.flatMap({ existingIDs.contains($0) ? $0 : nil }) ?? newest else { return }
            scope = .singleNote(id)
        }
    }

    /// Ticks or unticks one note in the Selected Notes scope.
    func toggleSelection(of id: UUID) {
        guard case .selectedNotes(var ids) = scope else {
            scope = .selectedNotes([id])
            return
        }
        if ids.contains(id) { ids.remove(id) } else { ids.insert(id) }
        scope = .selectedNotes(ids)
    }

    /// Re-runs generation for the notes the current guide came from (used by "Regenerate" on an
    /// outdated guide), even if the user has since picked a different source on the Study screen.
    func regenerateCurrentGuide(using allNotes: [StudyNote]) async {
        guard let guide else { return }
        scope = guide.source.scope.pruned(keeping: Set(allNotes.map(\.id)))
        await generate(using: allNotes)
    }

    // MARK: - Freshness

    /// True when the guide's source notes were changed or deleted (or, for an All Notes guide,
    /// notes were added) since it was generated.
    func isOutdated(for notes: [StudyNote]) -> Bool {
        outdatedReason(for: notes) != nil
    }

    /// A sentence explaining why the guide is outdated, or nil when it's current.
    func outdatedReason(for notes: [StudyNote]) -> String? {
        guide?.source.outdatedReason(comparedWith: notes)
    }

    /// True when the current scope is the one the guide was generated from (same notes).
    func guideMatchesScope(in notes: [StudyNote]) -> Bool {
        guard let guide else { return false }
        return guide.source.kind == scope.kind
            && Set(scope.resolve(in: notes).map(\.id)) == guide.sourceNoteIDs
    }

    // MARK: - Note deletion

    /// What deleting notes would do to the current guide, so confirmation dialogs can say so up front.
    enum DeletionImpact {
        /// The guide doesn't use any of the notes.
        case none
        /// The guide still has other source notes; it stays but is marked out of date.
        case outdated
        /// Every note the guide was built from would be gone, so the guide and Brain Map are cleared.
        case removed
    }

    func deletionImpact(ofDeleting ids: Set<UUID>) -> DeletionImpact {
        guard let guide, !guide.sourceNoteIDs.isDisjoint(with: ids) else { return .none }
        return guide.sourceNoteIDs.isSubset(of: ids) ? .removed : .outdated
    }

    /// Keeps study state consistent with the saved notes after they change.
    /// A guide whose source notes are all gone no longer describes anything the user has, so it's
    /// cleared (which also clears the Brain Map and Quiz Me questions). A guide that still has some
    /// source notes is kept, and `outdatedReason(for:)` tells each screen to offer regeneration.
    /// The selected scope also forgets notes that no longer exist.
    func reconcile(with notes: [StudyNote]) {
        let existingIDs = Set(notes.map(\.id))
        let prunedScope = scope.pruned(keeping: existingIDs)
        if prunedScope != scope { scope = prunedScope }

        guard let guide, !isGenerating else { return }
        if guide.sourceNoteIDs.isDisjoint(with: existingIDs) {
            self.guide = nil
            errorMessage = nil
        }
    }

    #if DEBUG
    /// Lets previews show screens with a guide without calling Foundation Models.
    func loadPreviewGuide(_ analysis: StudyAnalysis) {
        guide = GeneratedStudyGuide(
            analysis: analysis,
            source: StudySource(kind: .allNotes, notes: []),
            includedNoteCount: 0,
            wasTruncated: false
        )
    }
    #endif

    // MARK: - Generation

    /// Generates a study guide from the notes in the current `scope`.
    func generate(using allNotes: [StudyNote]) async {
        await generate(scope: scope, allNotes: allNotes)
    }

    /// Generates a study guide from the notes in `scope`. Ignores duplicate requests while one is
    /// running. The notes are captured *now*, so editing the scope mid-generation can't change
    /// what the finished guide claims to describe.
    func generate(scope: StudyScope, allNotes: [StudyNote]) async {
        guard !isGenerating else { return }

        // Always confirm availability before creating a generation request.
        refreshAvailability()
        guard availability == .available else { return }

        canRetryAfterError = false
        let notes = scope.resolve(in: allNotes)
        guard !notes.isEmpty else {
            errorMessage = scope.kind == .selectedNotes
                ? "Choose at least one note to study."
                : "There are no notes to study yet."
            return
        }

        // Only the selected notes are turned into model input; nothing else reaches the model.
        let material = service.makeStudyMaterial(from: notes)
        guard material.includedNoteCount > 0 else {
            errorMessage = "The selected notes don't contain any text to study yet."
            return
        }

        isGenerating = true
        errorMessage = nil
        defer { isGenerating = false }

        do {
            let analysis = try await service.generateAnalysis(from: material)
            guide = GeneratedStudyGuide(
                analysis: analysis,
                source: StudySource(kind: scope.kind, notes: notes),
                includedNoteCount: material.includedNoteCount,
                wasTruncated: material.wasTruncated
            )
        } catch is CancellationError {
            return
        } catch {
            errorMessage = error.localizedDescription
            canRetryAfterError = true
            // The model may have become unavailable mid-request; update the screen if so.
            refreshAvailability()
        }
    }
}
