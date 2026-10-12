import Foundation
import CoreGraphics
import Vision

/// Errors surfaced to the user when text recognition can't produce a result.
nonisolated enum TextRecognitionError: LocalizedError {
    case noTextFound

    var errorDescription: String? {
        switch self {
        case .noTextFound:
            "No text was detected in this image. Try a clearer, well-lit photo where the text fills more of the frame."
        }
    }
}

/// Extracts printed text from an image using Apple's Vision framework.
///
/// The service is `nonisolated` and its work runs via `@concurrent`, so the
/// synchronous Vision request executes on a background thread instead of the main actor.
nonisolated struct VisionTextRecognizer {

    /// Runs OCR on the given image and returns the recognized lines joined by newlines.
    ///
    /// - Parameters:
    ///   - image: The image to analyze. Should already be oriented upright.
    ///   - orientation: The EXIF orientation of `image`, if it isn't upright.
    /// - Throws: `TextRecognitionError.noTextFound` when Vision finds no text,
    ///   or any error thrown by the Vision request handler.
    @concurrent
    func recognizeText(
        in image: CGImage,
        orientation: CGImagePropertyOrientation = .up
    ) async throws -> String {
        // VISION STEP 1: Create the text recognition request.
        // `.accurate` uses Vision's neural-network recognizer (slower, but far better
        // for dense notes and slides than `.fast`). Language correction lets Vision
        // fix likely misreads using its language model.
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        request.automaticallyDetectsLanguage = true

        // VISION STEP 2: Wrap the image in a request handler and perform the request.
        // `perform(_:)` is synchronous and CPU/Neural Engine heavy, which is why this
        // method is `@concurrent` (runs off the main actor).
        let handler = VNImageRequestHandler(cgImage: image, orientation: orientation, options: [:])
        try handler.perform([request])

        try Task.checkCancellation()

        // VISION STEP 3: Read the results. Each VNRecognizedTextObservation is one
        // detected line/region of text; `topCandidates(1)` returns Vision's
        // highest-confidence transcription for that region.
        let observations = request.results ?? []
        let lines = observations.compactMap { observation in
            observation.topCandidates(1).first?.string
        }

        let text = lines
            .joined(separator: "\n")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !text.isEmpty else {
            throw TextRecognitionError.noTextFound
        }
        return text
    }
}
