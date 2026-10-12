import Foundation
import CoreGraphics
import PDFKit

/// Extracts text from PDFs page by page, in reading order.
///
///  • Pages with selectable text use PDFKit's embedded text (`PDFPage.string`): exact and fast.
///  • Pages without useful text (scanned handouts, photographed slides) are rendered to an image
///    with Core Graphics and read by the existing `VisionTextRecognizer` OCR pipeline.
///
/// Each page is labeled ("--- Page 3 ---") so the model and the user can see page boundaries.
nonisolated struct PDFTextExtractor {
    /// Fewer meaningful characters than this means the page is probably a scan.
    static let minimumEmbeddedCharacters = 25
    /// Longest rendered side for OCR; large enough for small print, small enough for memory.
    static let ocrMaxPixelSize: CGFloat = 2_400

    struct Result {
        let text: String
        let pageCount: Int
        let ocrPageCount: Int
    }

    private let recognizer = VisionTextRecognizer()

    func extract(from url: URL, progress: @Sendable (ImportProgress) -> Void) async throws -> Result {
        let filename = url.lastPathComponent
        guard let document = PDFDocument(url: url) else {
            throw ImportError.unreadable(filename: filename, reason: "It isn't a valid PDF.")
        }
        if document.isLocked {
            throw ImportError.passwordProtected(filename: filename)
        }

        let pageCount = document.pageCount
        var sections: [String] = []
        var ocrPages = 0

        for index in 0..<pageCount {
            try Task.checkCancellation()
            guard let page = document.page(at: index) else { continue }

            // STEP 1: Prefer embedded, selectable text.
            var pageText = (page.string ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            let meaningful = pageText.count { $0.isLetter || $0.isNumber }

            // STEP 2: Fall back to Vision OCR for image-only pages.
            if meaningful < Self.minimumEmbeddedCharacters {
                progress(ImportProgress(
                    fractionCompleted: Double(index) / Double(pageCount),
                    message: "Reading page \(index + 1) of \(pageCount) with Vision OCR…"
                ))
                if let image = Self.render(page) {
                    if let recognized = try? await recognizer.recognizeText(in: image), !recognized.isEmpty {
                        pageText = recognized
                        ocrPages += 1
                    }
                }
            } else {
                progress(ImportProgress(
                    fractionCompleted: Double(index) / Double(pageCount),
                    message: "Reading page \(index + 1) of \(pageCount)…"
                ))
            }

            if !pageText.isEmpty {
                sections.append("--- Page \(index + 1) ---\n\(pageText)")
            }
        }

        return Result(text: sections.joined(separator: "\n\n"), pageCount: pageCount, ocrPageCount: ocrPages)
    }

    /// Renders a PDF page onto a white bitmap with Core Graphics (works the same on iOS and macOS),
    /// respecting the page's rotation and crop box.
    static func render(_ page: PDFPage) -> CGImage? {
        guard let pageRef = page.pageRef else { return nil }
        let box = pageRef.getBoxRect(.cropBox)
        let rotated = pageRef.rotationAngle % 180 != 0
        let pageSize = rotated ? CGSize(width: box.height, height: box.width) : box.size
        guard pageSize.width > 0, pageSize.height > 0 else { return nil }

        let scale = min(Self.ocrMaxPixelSize / max(pageSize.width, pageSize.height), 4)
        let width = Int(pageSize.width * scale)
        let height = Int(pageSize.height * scale)
        guard let context = CGContext(
            data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0,
            space: CGColorSpace(name: CGColorSpace.sRGB) ?? CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return nil }

        let target = CGRect(x: 0, y: 0, width: width, height: height)
        context.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1))
        context.fill(target)
        // `getDrawingTransform` only ever scales *down*, so scale the context up ourselves and use
        // the transform just for the page's rotation and crop-box offset.
        context.scaleBy(x: scale, y: scale)
        context.concatenate(pageRef.getDrawingTransform(
            .cropBox, rect: CGRect(origin: .zero, size: pageSize), rotate: 0, preserveAspectRatio: true
        ))
        context.drawPDFPage(pageRef)
        return context.makeImage()
    }
}
