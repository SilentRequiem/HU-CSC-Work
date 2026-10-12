import SwiftUI

/// Lets the user handwrite notes with PencilKit (or drop an image of handwriting),
/// extracts the text with Vision, and saves it as a `.handwriting` note.
struct HandwritingNoteView: View {
    @Environment(NotesViewModel.self) private var notesViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var viewModel = HandwritingNoteViewModel()
    @State private var isDropTargeted = false

    /// Taller writing area on iPad / Mac, still comfortable on iPhone.
    private var canvasHeight: CGFloat {
        horizontalSizeClass == .compact ? 380 : 520
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    inputSection
                    recognizeButton
                    if viewModel.showsResults {
                        resultsSection
                    }
                }
                .padding()
                .readableContentWidth(900)
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Write Note")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save Note") {
                        // SAVE AS .handwriting: same shared NotesViewModel as Scan Image,
                        // so the note appears in Notes and feeds the Study Guide.
                        notesViewModel.add(viewModel.makeNote())
                        dismiss()
                    }
                    .disabled(!viewModel.canSave)
                }
            }
        }
        .studyLensSheetFrame()
    }

    // MARK: - Input (canvas or dropped image)

    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.droppedImage == nil ? "Handwriting" : "Dropped Image")
                .font(.headline)

            inputArea
                .frame(maxWidth: .infinity)
                .frame(height: canvasHeight)
                .clipShape(.rect(cornerRadius: 16))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(
                            isDropTargeted ? Color.purple : Color.secondary.opacity(0.3),
                            style: StrokeStyle(lineWidth: isDropTargeted ? 3 : 1, dash: isDropTargeted ? [8] : [])
                        )
                }
                // DRAG IMAGE INPUT: accept an image of handwritten notes dragged
                // from Photos, Files, Finder, or another app.
                .dropDestination(for: DroppedImage.self) { items, _ in
                    viewModel.handleDroppedImages(items)
                    return !items.isEmpty
                } isTargeted: { isDropTargeted = $0 }

            if viewModel.droppedImage == nil {
                drawingControls
            } else {
                Button("Remove Image and Handwrite Instead", systemImage: "pencil.and.scribble") {
                    viewModel.removeDroppedImage()
                }
                .disabled(viewModel.isBusy)
            }

            Text(inputFooter)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.background.secondary, in: .rect(cornerRadius: 16))
    }

    @ViewBuilder
    private var inputArea: some View {
        if let image = viewModel.droppedImage {
            Image(decorative: image, scale: 1)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.background)
                .accessibilityLabel("Dropped image")
        } else if viewModel.isLoadingDroppedImage {
            ProgressView("Loading image…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.background)
        } else {
            HandwritingCanvas(
                drawing: viewModel.drawing,
                showsToolPicker: viewModel.showsToolPicker
            ) { newDrawing in
                viewModel.drawingDidChange(newDrawing)
            }
            .overlay {
                if !viewModel.hasInk {
                    canvasPlaceholder
                }
            }
            .accessibilityLabel("Handwriting canvas")
        }
    }

    private var canvasPlaceholder: some View {
        VStack(spacing: 8) {
            Image(systemName: "pencil.and.scribble")
                .font(.largeTitle)
            Text("Write your notes here")
                .font(.headline)
            Text("or drag in an image of handwritten notes")
                .font(.subheadline)
        }
        .foregroundStyle(Color.gray.opacity(0.6))
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private var drawingControls: some View {
        @Bindable var viewModel = viewModel

        return HStack(spacing: 12) {
            Button("Undo", systemImage: "arrow.uturn.backward") { viewModel.undo() }
                .disabled(!viewModel.canUndo || viewModel.isBusy)
            Button("Redo", systemImage: "arrow.uturn.forward") { viewModel.redo() }
                .disabled(!viewModel.canRedo || viewModel.isBusy)
            Button("Clear", systemImage: "trash", role: .destructive) { viewModel.clearCanvas() }
                .disabled(!viewModel.hasInk || viewModel.isBusy)

            #if os(iOS) || os(visionOS)
            Spacer(minLength: 0)
            Toggle(isOn: $viewModel.showsToolPicker) {
                Label("Tools", systemImage: "pencil.tip.crop.circle")
            }
            .toggleStyle(.button)
            #endif
        }
        .labelStyle(.iconOnly)
        .buttonStyle(.bordered)
        .controlSize(.large)
    }

    private var inputFooter: String {
        if viewModel.droppedImage != nil {
            return "Vision will read the writing in this image."
        }
        #if os(macOS)
        return "Write with your mouse or trackpad. Larger, neater writing is recognized more accurately."
        #else
        return "Write with Apple Pencil or your finger. Larger, neater writing is recognized more accurately."
        #endif
    }

    // MARK: - Recognition

    private var recognizeButton: some View {
        Button {
            viewModel.recognizeHandwriting()
        } label: {
            Group {
                if viewModel.isRecognizing {
                    ProgressView()
                } else {
                    Label("Recognize Handwriting", systemImage: "text.viewfinder")
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(.purple)
        .controlSize(.large)
        .disabled(!viewModel.canRecognize)
    }

    @ViewBuilder
    private var resultsSection: some View {
        @Bindable var viewModel = viewModel

        VStack(alignment: .leading, spacing: 16) {
            if viewModel.isRecognizing {
                ProgressView("Recognizing handwriting…")
                    .frame(maxWidth: .infinity, minHeight: 120)
            } else {
                if let errorMessage = viewModel.errorMessage {
                    Label(errorMessage, systemImage: "exclamationmark.triangle")
                        .foregroundStyle(Color.studyLensWarning)
                }

                if !viewModel.recognizedText.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(.headline)
                        TextField("Note title", text: $viewModel.title)
                            .textFieldStyle(.roundedBorder)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Recognized Text")
                            .font(.headline)
                        TextEditor(text: $viewModel.recognizedText)
                            .frame(minHeight: 200)
                            .scrollContentBackground(.hidden)
                            .padding(8)
                            .background(.background, in: .rect(cornerRadius: 12))
                        Text("Review and correct any recognition mistakes before saving.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(.background.secondary, in: .rect(cornerRadius: 16))
    }
}

#Preview {
    HandwritingNoteView()
        .environment(NotesViewModel())
}
