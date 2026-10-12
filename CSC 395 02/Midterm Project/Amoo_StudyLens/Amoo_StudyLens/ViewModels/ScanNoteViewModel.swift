import Foundation
import CoreGraphics
import ImageIO
import Observation
import PhotosUI
import SwiftUI

/// Drives the Scan Note screen: loads a picked photo, runs Vision OCR on it,
/// and builds the `StudyNote` the user saves.
@MainActor
@Observable
final class ScanNoteViewModel {
    /// The photo currently selected in the picker.
    var selectedItem: PhotosPickerItem? {
        didSet {
            if selectedItem != oldValue { processSelectedItem() }
        }
    }

    /// The decoded, upright image shown on screen and passed to Vision.
    private(set) var image: CGImage?
    private(set) var isLoadingImage = false
    private(set) var isRecognizing = false
    private(set) var errorMessage: String?

    /// Editable OCR output; the user can correct mistakes before saving.
    var recognizedText = ""
    /// Editable note title, pre-filled from the recognized text.
    var title = ""

    @ObservationIgnored
    private let recognizer = VisionTextRecognizer()

    @ObservationIgnored
    private var processingTask: Task<Void, Never>?

    var isBusy: Bool { isLoadingImage || isRecognizing }

    var canSave: Bool {
        !isBusy && !recognizedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Creates the note to save, falling back to a generated title if the field is blank.
    func makeNote() -> StudyNote {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let body = recognizedText.trimmingCharacters(in: .whitespacesAndNewlines)
        return StudyNote(
            title: trimmedTitle.isEmpty ? Self.generateTitle(from: body) : trimmedTitle,
            body: body,
            source: .scan
        )
    }

    /// Re-runs text recognition on the current image (e.g. after an error).
    func retryRecognition() {
        guard let image else { return }
        processingTask?.cancel()
        processingTask = Task { await recognize(image) }
    }

    // MARK: - Pipeline

    /// Loads the picked photo's data, decodes it, then hands it to Vision.
    private func processSelectedItem() {
        processingTask?.cancel()
        image = nil
        recognizedText = ""
        title = ""
        errorMessage = nil

        guard let item = selectedItem else { return }

        processingTask = Task {
            isLoadingImage = true
            defer { isLoadingImage = false }

            do {
                // Pull the raw image bytes out of the photo library item.
                guard let data = try await item.loadTransferable(type: Data.self) else {
                    errorMessage = "The selected photo couldn't be loaded."
                    return
                }
                guard let decoded = await Self.decodeImage(from: data) else {
                    errorMessage = "The selected file isn't a supported image."
                    return
                }
                guard !Task.isCancelled else { return }
                image = decoded
            } catch {
                guard !Task.isCancelled else { return }
                errorMessage = "The selected photo couldn't be loaded. \(error.localizedDescription)"
                return
            }

            if let image {
                await recognize(image)
            }
        }
    }

    /// Calls the Vision service and publishes its result or a user-facing error.
    private func recognize(_ image: CGImage) async {
        isRecognizing = true
        errorMessage = nil
        defer { isRecognizing = false }

        do {
            // Vision work happens off the main actor inside VisionTextRecognizer.
            let text = try await recognizer.recognizeText(in: image)
            guard !Task.isCancelled else { return }
            recognizedText = text
            title = Self.generateTitle(from: text)
        } catch is CancellationError {
            return
        } catch {
            guard !Task.isCancelled else { return }
            recognizedText = ""
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Helpers

    /// Decodes image data into an upright `CGImage` off the main actor.
    ///
    /// Uses ImageIO's thumbnail API so the EXIF orientation is applied to the pixels
    /// (Vision then sees upright text) and very large photos are downsampled to save memory.
    /// Also reused by the Write Note screen for images dragged onto it.
    @concurrent
    nonisolated static func decodeImage(from data: Data) async -> CGImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: 4096
        ]
        return CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary)
    }

    /// Builds a short title from the first meaningful line of recognized text.
    /// `fallbackPrefix` names the note when no usable line exists (e.g. "Handwritten Note").
    static func generateTitle(from text: String, fallbackPrefix: String = "Scanned Note") -> String {
        let maxLength = 50
        let firstLine = text
            .split(whereSeparator: \.isNewline)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .first { $0.count >= 3 } ?? ""

        guard !firstLine.isEmpty else {
            return "\(fallbackPrefix) \(Date.now.formatted(date: .abbreviated, time: .shortened))"
        }
        guard firstLine.count > maxLength else { return firstLine }

        // Truncate at a word boundary so titles don't end mid-word.
        let prefix = String(firstLine.prefix(maxLength))
        if let lastSpace = prefix.lastIndex(of: " ") {
            return String(prefix[..<lastSpace]) + "…"
        }
        return prefix + "…"
    }
}
