import Foundation
import Observation

/// Drives the Import File screen: runs `DocumentImportService` on a picked or dropped file,
/// publishes progress, and holds the editable text and title until the user saves.
///
/// Workflow:  choose/drop file → extracting (progress) → review & correct text → Save Note
/// Saving goes through the shared `NotesViewModel`, so imported notes are persisted by SwiftData
/// exactly like scanned, handwritten, and dictated notes.
@MainActor
@Observable
final class ImportFileViewModel {
    enum Phase: Equatable {
        case idle
        case extracting
        case review
        case failed(String)
    }

    private(set) var phase: Phase = .idle
    private(set) var filename: String?
    private(set) var detectedKind: ImportFileKind?
    private(set) var progress: ImportProgress?
    private(set) var fileInfo: ImportedFileInfo?
    private(set) var notices: [String] = []

    /// Extracted text, editable so the user can fix OCR or formatting issues before saving.
    var text = ""
    /// Note title, pre-filled from the file name.
    var title = ""

    @ObservationIgnored
    private let service = DocumentImportService()
    @ObservationIgnored
    private var importTask: Task<Void, Never>?
    /// Distinguishes progress callbacks from a file the user has since replaced.
    @ObservationIgnored
    private var importID = UUID()

    var isExtracting: Bool { phase == .extracting }

    var canSave: Bool {
        phase == .review && !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Starts importing a file. Replaces (and cancels) any import already in progress.
    func importFile(at url: URL) {
        importTask?.cancel()
        let id = UUID()
        importID = id

        filename = url.lastPathComponent
        detectedKind = ImportFileKind.detect(url: url)
        fileInfo = nil
        notices = []
        text = ""
        title = ""
        progress = nil

        // Unsupported files are rejected up front with a clear message, never silently ignored.
        guard detectedKind != nil else {
            phase = .failed(ImportError.unsupportedFile(filename: url.lastPathComponent).localizedDescription)
            return
        }
        phase = .extracting
        title = Self.defaultTitle(for: url)

        let reportProgress = makeProgressHandler(for: id)
        importTask = Task {
            do {
                let document = try await service.importDocument(at: url, progress: reportProgress)
                guard !Task.isCancelled, importID == id else { return }
                text = document.text
                fileInfo = document.info
                notices = document.notices
                phase = .review
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled, importID == id else { return }
                phase = .failed(error.localizedDescription)
            }
        }
    }

    /// Progress arrives on a background thread; this hops to the main actor and ignores updates
    /// from an import the user has since replaced.
    private func makeProgressHandler(for id: UUID) -> @Sendable (ImportProgress) -> Void {
        { [weak self] update in
            Task { @MainActor [weak self] in
                guard let self, self.importID == id, self.phase == .extracting else { return }
                self.progress = update
            }
        }
    }

    /// Rejects a drop that wasn't a file at all (e.g. dragged text or a web link).
    func reportUnsupportedDrop() {
        reportFailure("Only files can be imported. Drop a \(ImportFileKind.supportedFormatsDescription) file.")
    }

    /// Shows a problem (bad drop, file-picker error) in place of the current import.
    func reportFailure(_ message: String) {
        importTask?.cancel()
        phase = .failed(message)
    }

    func cancel() {
        importTask?.cancel()
    }

    /// Builds the note to save, with `.imported` source and the original file's metadata.
    func makeNote() -> StudyNote {
        let body = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        return StudyNote(
            title: trimmedTitle.isEmpty ? ScanNoteViewModel.generateTitle(from: body, fallbackPrefix: "Imported Note") : trimmedTitle,
            body: body,
            source: .imported,
            importInfo: fileInfo
        )
    }

    /// "Week 3 - Cell Biology.pptx" → "Week 3 - Cell Biology".
    private static func defaultTitle(for url: URL) -> String {
        url.deletingPathExtension().lastPathComponent
            .replacingOccurrences(of: "_", with: " ")
            .trimmingCharacters(in: .whitespaces)
    }
}
