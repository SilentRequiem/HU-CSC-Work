import Foundation
import CoreGraphics
import PencilKit
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// Errors raised while turning a drawing into an image for OCR.
nonisolated enum HandwritingRenderingError: LocalizedError {
    case emptyDrawing
    case renderFailed

    var errorDescription: String? {
        switch self {
        case .emptyDrawing:
            "Write something on the canvas first, then tap Recognize Handwriting."
        case .renderFailed:
            "Your handwriting couldn't be prepared for recognition. Please try again."
        }
    }
}

/// Converts a PencilKit `PKDrawing` into the `CGImage` that `VisionTextRecognizer` expects.
///
/// This type only renders pixels; it contains no OCR logic.
struct HandwritingRenderer {
    /// Blank margin kept around the ink so Vision doesn't see text touching the edges.
    var padding: CGFloat = 32

    /// Renders only the inked region of `drawing` as black ink on an opaque white background.
    func renderImage(from drawing: PKDrawing) throws -> CGImage {
        // PKDRAWING RENDER STEP 1: Crop to the ink instead of the whole canvas.
        // `drawing.bounds` is the tight box around every stroke, so a few words in
        // the corner of a large canvas don't become a huge, mostly empty image.
        let inkBounds = drawing.bounds
        guard !drawing.strokes.isEmpty, !inkBounds.isNull, !inkBounds.isEmpty else {
            throw HandwritingRenderingError.emptyDrawing
        }
        let renderRect = inkBounds.insetBy(dx: -padding, dy: -padding)
        let scale = Self.renderScale(for: renderRect.size)

        // PKDRAWING RENDER STEP 2: Ask PencilKit to rasterize the strokes.
        // The result has a transparent background.
        guard let inkImage = Self.rasterize(drawing, in: renderRect, scale: scale) else {
            throw HandwritingRenderingError.renderFailed
        }

        // IMAGE CONVERSION: Flatten the transparent ink onto opaque white so Vision
        // gets maximum black-on-white contrast, and output a plain `CGImage`.
        let pixelWidth = Int((renderRect.width * scale).rounded(.up))
        let pixelHeight = Int((renderRect.height * scale).rounded(.up))
        guard let image = Self.flattenOnWhite(inkImage, width: pixelWidth, height: pixelHeight) else {
            throw HandwritingRenderingError.renderFailed
        }
        return image
    }

    // MARK: - Helpers

    /// Picks a scale that upsamples small writing (Vision prefers taller glyphs)
    /// while capping the longest side at 4096 px to bound memory use.
    private static func renderScale(for size: CGSize) -> CGFloat {
        let longestSide = max(size.width, size.height, 1)
        let preferred = min(4, max(2, 2000 / longestSide))
        return min(preferred, 4096 / longestSide)
    }

    /// Renders the drawing with PencilKit in a light appearance, so ink colors are
    /// not inverted for Dark Mode, and returns the underlying `CGImage`.
    private static func rasterize(_ drawing: PKDrawing, in rect: CGRect, scale: CGFloat) -> CGImage? {
        #if canImport(UIKit)
        var image: UIImage?
        UITraitCollection(userInterfaceStyle: .light).performAsCurrent {
            image = drawing.image(from: rect, scale: scale)
        }
        return image?.cgImage
        #elseif canImport(AppKit)
        var image: NSImage?
        let render = { image = drawing.image(from: rect, scale: scale) }
        if let light = NSAppearance(named: .aqua) {
            light.performAsCurrentDrawingAppearance(render)
        } else {
            render()
        }
        return image?.cgImage(forProposedRect: nil, context: nil, hints: nil)
        #endif
    }

    /// Draws `ink` over a white background in an opaque RGB bitmap.
    private static func flattenOnWhite(_ ink: CGImage, width: Int, height: Int) -> CGImage? {
        guard width > 0, height > 0,
              let context = CGContext(
                data: nil,
                width: width,
                height: height,
                bitsPerComponent: 8,
                bytesPerRow: 0,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
              )
        else { return nil }

        let fullRect = CGRect(x: 0, y: 0, width: width, height: height)
        context.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1))
        context.fill(fullRect)
        context.interpolationQuality = .high
        context.draw(ink, in: fullRect)
        return context.makeImage()
    }
}
