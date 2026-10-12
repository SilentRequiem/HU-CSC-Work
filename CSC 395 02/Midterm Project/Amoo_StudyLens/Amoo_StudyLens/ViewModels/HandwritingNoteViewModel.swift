import Foundation
import CoreGraphics
import CoreTransferable
import Observation
import PencilKit
import UniformTypeIdentifiers

/// Drives the Write Note screen: owns the PencilKit drawing and its undo history,
/// renders it for Vision OCR, and builds the `.handwriting` `StudyNote` the user saves.
///
/// Images of handwritten notes can also be dragged onto the screen; they go through
/// the same Vision recognizer instead of the drawing.
@MainActor
@Observable
final class HandwritingNoteViewModel {
    // MARK: Drawing state

    /// The current handwriting. The canvas displays this and reports changes back.
    private(set) var drawing = PKDrawing()
    private var undoStack: [PKDrawing] = []
    private var redoStack: [PKDrawing] = []
    private let maxHistory = 100

    /// Whether the native PencilKit tool picker is shown (iOS/iPadOS only).
    var showsToolPicker = true

    // MARK: Dropped image state

    /// An image dragged onto the screen. When set, it is recognized instead of the drawing.
    private(set) var droppedImage: CGImage?
    private(set) var isLoadingDroppedImage = false

    // MARK: Recognition state

    private(set) var isRecognizing = false
    private(set) var errorMessage: String?

    /// Editable OCR output; the user can correct mistakes before saving.
    var recognizedText = ""
    /// Editable note title, pre-filled from the recognized text.
    var title = ""

    @ObservationIgnored
    private let renderer = HandwritingRenderer()
    @ObservationIgnored
    private let recognizer = VisionTextRecognizer()
    @ObservationIgnored
    private var recognitionTask: Task<Void, Never>?

    var hasInk: Bool { !drawing.strokes.isEmpty }
    var canUndo: Bool { !undoStack.isEmpty }
    var canRedo: Bool { !redoStack.isEmpty }
    var isBusy: Bool { isRecognizing || isLoadingDroppedImage }

    var canRecognize: Bool {
        !isBusy && (droppedImage != nil || hasInk)
    }

    var canSave: Bool {
        !isBusy && !recognizedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// True once there is OCR output (or an error) to show below the canvas.
    var showsResults: Bool {
        isRecognizing || errorMessage != nil || !recognizedText.isEmpty
    }

    // MARK: - Drawing edits

    /// Called by the canvas after each stroke/erase. Records undo history.
    func drawingDidChange(_ newDrawing: PKDrawing) {
        // The canvas also reports changes we pushed into it (undo/redo/clear); ignore those.
        guard newDrawing != drawing else { return }
        pushUndo(drawing)
        redoStack.removeAll()
        drawing = newDrawing
    }

    func undo() {
        guard let previous = undoStack.popLast() else { return }
        redoStack.append(drawing)
        drawing = previous
    }

    func redo() {
        guard let next = redoStack.popLast() else { return }
        pushUndo(drawing)
        drawing = next
    }

    /// Clears the canvas. This is undoable so an accidental tap isn't destructive.
    func clearCanvas() {
        guard hasInk else { return }
        pushUndo(drawing)
        redoStack.removeAll()
        drawing = PKDrawing()
    }

    private func pushUndo(_ snapshot: PKDrawing) {
        undoStack.append(snapshot)
        if undoStack.count > maxHistory {
            undoStack.removeFirst(undoStack.count - maxHistory)
        }
    }

    // MARK: - Dropped images

    /// Loads an image dragged onto the screen and immediately recognizes it.
    func handleDroppedImages(_ items: [DroppedImage]) {
        guard let item = items.first else { return }
        recognitionTask?.cancel()
        errorMessage = nil

        recognitionTask = Task {
            isLoadingDroppedImage = true
            // Reuses the Scan screen's decoder (applies EXIF orientation, downsamples).
            let decoded = await ScanNoteViewModel.decodeImage(from: item.data)
            isLoadingDroppedImage = false
            guard !Task.isCancelled else { return }

            guard let decoded else {
                errorMessage = "The dropped file isn't a supported image."
                return
            }
            droppedImage = decoded
            await recognize(decoded, fromDrawing: false)
        }
    }

    /// Discards the dropped image and returns to the handwriting canvas.
    func removeDroppedImage() {
        recognitionTask?.cancel()
        droppedImage = nil
        errorMessage = nil
    }

    // MARK: - Recognition

    /// Renders the handwriting (or uses the dropped image) and runs Vision OCR on it.
    /// The drawing is never cleared here, so the user can fix it and retry after a failure.
    func recognizeHandwriting() {
        recognitionTask?.cancel()
        errorMessage = nil

        if let droppedImage {
            recognitionTask = Task { await recognize(droppedImage, fromDrawing: false) }
            return
        }

        do {
            // HANDWRITING → IMAGE: PKDrawing becomes a cropped, white-background CGImage.
            let image = try renderer.renderImage(from: drawing)
            recognitionTask = Task { await recognize(image, fromDrawing: true) }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    /// Sends an image through the app's existing Vision OCR service.
    private func recognize(_ image: CGImage, fromDrawing: Bool) async {
        isRecognizing = true
        defer { isRecognizing = false }

        do {
            // HANDWRITING → VISION: the same `VisionTextRecognizer` used by Scan Image.
            // It runs off the main actor (`@concurrent`) and returns recognized lines.
            let text = try await recognizer.recognizeText(in: image)
            guard !Task.isCancelled else { return }

            guard Self.isMeaningful(text) else {
                errorMessage = Self.noTextMessage(fromDrawing: fromDrawing)
                return
            }
            recognizedText = text
            title = ScanNoteViewModel.generateTitle(from: text, fallbackPrefix: "Handwritten Note")
        } catch is CancellationError {
            return
        } catch TextRecognitionError.noTextFound {
            guard !Task.isCancelled else { return }
            errorMessage = Self.noTextMessage(fromDrawing: fromDrawing)
        } catch {
            guard !Task.isCancelled else { return }
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Saving

    /// SAVE AS .handwriting: builds the note handed to the shared `NotesViewModel`.
    /// Only the (corrected) text is stored; the drawing itself is not persisted.
    func makeNote() -> StudyNote {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let body = recognizedText.trimmingCharacters(in: .whitespacesAndNewlines)
        return StudyNote(
            title: trimmedTitle.isEmpty
                ? ScanNoteViewModel.generateTitle(from: body, fallbackPrefix: "Handwritten Note")
                : trimmedTitle,
            body: body,
            source: .handwriting
        )
    }

    // MARK: - Helpers

    /// Rejects results that are only stray marks or punctuation.
    private static func isMeaningful(_ text: String) -> Bool {
        text.filter { $0.isLetter || $0.isNumber }.count >= 2
    }

    private static func noTextMessage(fromDrawing: Bool) -> String {
        if fromDrawing {
            "StudyLens couldn't read any words in your handwriting. Recognition works best with clear, larger writing in straight lines. Try writing bigger or more neatly, then tap Recognize Handwriting again."
        } else {
            "No text was found in the dropped image. Try a clearer image where the writing is large and high-contrast."
        }
    }
}

/// Image data dragged onto the Write Note screen (from Photos, Files, Finder, Safari…).
nonisolated struct DroppedImage: Transferable {
    let data: Data

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            DroppedImage(data: data)
        }
        FileRepresentation(importedContentType: .image) { received in
            DroppedImage(data: try Data(contentsOf: received.file))
        }
    }
}
