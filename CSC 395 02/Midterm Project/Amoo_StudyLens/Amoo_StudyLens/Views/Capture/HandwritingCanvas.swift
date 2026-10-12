import SwiftUI
import PencilKit

// MARK: - SwiftUI ↔ PencilKit bridge
//
// `HandwritingCanvas` is the single SwiftUI view the Write Note screen uses.
// The drawing itself is owned by the view model (`drawing`); the canvas reports
// every committed change back through `onDrawingChanged`, so undo/redo/clear
// work the same way on every platform.
//
// Platform availability (checked against the installed SDKs):
// - iOS / iPadOS / visionOS: PencilKit ships `PKCanvasView` and `PKToolPicker`.
// - macOS (native AppKit): PencilKit ships `PKDrawing`, `PKStroke`, and `PKInk`, but
//   NOT `PKCanvasView` or `PKToolPicker`. On the Mac we build real `PKStroke`s from
//   mouse/trackpad events in a small `NSView`, so the result is still a `PKDrawing`.

#if os(iOS) || os(visionOS)

/// Wraps PencilKit's `PKCanvasView` for SwiftUI.
struct HandwritingCanvas: UIViewRepresentable {
    /// The drawing to display (source of truth lives in the view model).
    let drawing: PKDrawing
    /// Whether the native PencilKit tool picker should be shown.
    var showsToolPicker: Bool = true
    /// Called after each completed stroke, erase, or lasso edit.
    var onDrawingChanged: (PKDrawing) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onDrawingChanged: onDrawingChanged)
    }

    // PENCILKIT BRIDGE STEP 1: Create and configure the UIKit canvas once.
    func makeUIView(context: Context) -> StudyLensCanvasView {
        let canvas = StudyLensCanvasView()
        canvas.drawing = drawing
        canvas.delegate = context.coordinator

        // `.anyInput` lets a finger draw too (not just Apple Pencil), so the
        // feature can be tested on iPhone and in the Simulator with a mouse.
        canvas.drawingPolicy = .anyInput
        canvas.tool = PKInkingTool(.pen, color: .black, width: 4)

        // A white, light-mode "paper" keeps ink black on white in Dark Mode too,
        // which matches what is later rendered for Vision.
        canvas.backgroundColor = .white
        canvas.isOpaque = true
        canvas.overrideUserInterfaceStyle = .light
        canvas.isScrollEnabled = false

        canvas.onMovedToWindow = { [weak coordinator = context.coordinator] canvas in
            coordinator?.canvasMovedToWindow(canvas, showsToolPicker: showsToolPicker)
        }
        return canvas
    }

    // PENCILKIT BRIDGE STEP 2: Push SwiftUI state (undo/redo/clear) into UIKit.
    func updateUIView(_ canvas: StudyLensCanvasView, context: Context) {
        context.coordinator.onDrawingChanged = onDrawingChanged

        // Only assign when different, otherwise every SwiftUI update would
        // reset PencilKit's internal state.
        if canvas.drawing != drawing {
            canvas.drawing = drawing
        }
        context.coordinator.updateToolPicker(for: canvas, visible: showsToolPicker)
    }

    static func dismantleUIView(_ canvas: StudyLensCanvasView, coordinator: Coordinator) {
        coordinator.toolPicker.setVisible(false, forFirstResponder: canvas)
        coordinator.toolPicker.removeObserver(canvas)
    }

    // PENCILKIT BRIDGE STEP 3: The coordinator receives PencilKit delegate
    // callbacks and forwards the new PKDrawing back to SwiftUI.
    final class Coordinator: NSObject, PKCanvasViewDelegate {
        var onDrawingChanged: (PKDrawing) -> Void
        /// The native PencilKit tool picker (pens, highlighter, eraser, lasso, ruler).
        let toolPicker = PKToolPicker()
        private var didLinkScrollViews = false

        init(onDrawingChanged: @escaping (PKDrawing) -> Void) {
            self.onDrawingChanged = onDrawingChanged
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            onDrawingChanged(canvasView.drawing)
        }

        func canvasMovedToWindow(_ canvas: PKCanvasView, showsToolPicker: Bool) {
            guard canvas.window != nil else { return }
            toolPicker.addObserver(canvas)
            updateToolPicker(for: canvas, visible: showsToolPicker)
            linkEnclosingScrollViews(to: canvas)
        }

        func updateToolPicker(for canvas: PKCanvasView, visible: Bool) {
            guard canvas.window != nil else { return }
            toolPicker.setVisible(visible, forFirstResponder: canvas)
            // The tool picker only appears while the canvas is first responder.
            if visible && !canvas.isFirstResponder {
                canvas.becomeFirstResponder()
            }
        }

        /// The canvas sits inside a SwiftUI ScrollView. Making the outer scroll
        /// gesture wait for PencilKit's drawing gesture lets a finger draw on the
        /// canvas while still scrolling the page everywhere else.
        private func linkEnclosingScrollViews(to canvas: PKCanvasView) {
            guard !didLinkScrollViews else { return }
            didLinkScrollViews = true
            var ancestor = canvas.superview
            while let view = ancestor {
                if let scrollView = view as? UIScrollView {
                    scrollView.panGestureRecognizer.require(toFail: canvas.drawingGestureRecognizer)
                }
                ancestor = view.superview
            }
        }
    }
}

/// `PKCanvasView` that reports when it joins a window, the earliest point at which
/// it can become first responder (required for the tool picker to appear).
final class StudyLensCanvasView: PKCanvasView {
    var onMovedToWindow: ((StudyLensCanvasView) -> Void)?

    override func didMoveToWindow() {
        super.didMoveToWindow()
        onMovedToWindow?(self)
    }
}

#elseif os(macOS)

/// Mac version of the canvas. Native macOS has no `PKCanvasView`, so mouse or
/// trackpad drags are converted into PencilKit `PKStroke`s inside a `PKDrawing`.
struct HandwritingCanvas: NSViewRepresentable {
    let drawing: PKDrawing
    /// Unused on macOS: PencilKit has no tool picker for AppKit.
    var showsToolPicker: Bool = true
    var onDrawingChanged: (PKDrawing) -> Void

    // PENCILKIT BRIDGE (macOS): create the AppKit drawing view.
    func makeNSView(context: Context) -> MouseDrawingCanvasView {
        let view = MouseDrawingCanvasView()
        view.drawing = drawing
        view.onDrawingChanged = onDrawingChanged
        return view
    }

    func updateNSView(_ view: MouseDrawingCanvasView, context: Context) {
        view.onDrawingChanged = onDrawingChanged
        if view.drawing != drawing {
            view.drawing = drawing
        }
    }
}

/// An AppKit view that records mouse/trackpad strokes as PencilKit strokes.
final class MouseDrawingCanvasView: NSView {
    var drawing = PKDrawing() {
        didSet {
            cachedInkImage = nil
            needsDisplay = true
        }
    }
    var onDrawingChanged: ((PKDrawing) -> Void)?

    private let ink = PKInk(.pen, color: .black)
    private let strokeWidth: CGFloat = 4
    private var currentPoints: [PKStrokePoint] = []
    private var strokeStartTime: TimeInterval = 0
    private var strokeStartDate = Date.now
    /// Rendered image of committed strokes, so each mouse drag only draws the live stroke.
    private var cachedInkImage: NSImage?

    // PencilKit drawings use a top-left origin, so flip AppKit's coordinates to match.
    override var isFlipped: Bool { true }
    override var acceptsFirstResponder: Bool { true }
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool { true }

    override func setFrameSize(_ newSize: NSSize) {
        super.setFrameSize(newSize)
        cachedInkImage = nil
    }

    override func mouseDown(with event: NSEvent) {
        strokeStartTime = event.timestamp
        strokeStartDate = .now
        currentPoints = [strokePoint(for: event)]
        needsDisplay = true
    }

    override func mouseDragged(with event: NSEvent) {
        currentPoints.append(strokePoint(for: event))
        needsDisplay = true
    }

    override func mouseUp(with event: NSEvent) {
        currentPoints.append(strokePoint(for: event))

        // Commit the finished gesture as a real PencilKit stroke.
        let path = PKStrokePath(controlPoints: currentPoints, creationDate: strokeStartDate)
        var updated = drawing
        updated.strokes.append(PKStroke(ink: ink, path: path))
        currentPoints = []
        drawing = updated
        onDrawingChanged?(updated)
    }

    private func strokePoint(for event: NSEvent) -> PKStrokePoint {
        let location = convert(event.locationInWindow, from: nil)
        return PKStrokePoint(
            location: location,
            timeOffset: event.timestamp - strokeStartTime,
            size: CGSize(width: strokeWidth, height: strokeWidth),
            opacity: 1,
            force: 1,
            azimuth: 0,
            altitude: .pi / 2
        )
    }

    override func draw(_ dirtyRect: NSRect) {
        NSColor.white.setFill()
        bounds.fill()

        // Committed strokes: let PencilKit render them (light appearance → black ink).
        if cachedInkImage == nil, !drawing.strokes.isEmpty {
            let scale = window?.backingScaleFactor ?? 2
            var image: NSImage?
            let render = { image = self.drawing.image(from: self.bounds, scale: scale) }
            if let light = NSAppearance(named: .aqua) {
                light.performAsCurrentDrawingAppearance(render)
            } else {
                render()
            }
            cachedInkImage = image
        }
        cachedInkImage?.draw(
            in: bounds,
            from: .zero,
            operation: .sourceOver,
            fraction: 1,
            respectFlipped: true,
            hints: nil
        )

        // In-progress stroke: a lightweight Bézier preview until mouse-up.
        guard let first = currentPoints.first else { return }
        let path = NSBezierPath()
        path.lineWidth = strokeWidth
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        path.move(to: first.location)
        for point in currentPoints.dropFirst() {
            path.line(to: point.location)
        }
        NSColor.black.setStroke()
        path.stroke()
    }
}

#endif
