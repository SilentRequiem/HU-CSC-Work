import SwiftUI
import PhotosUI

/// Lets the user pick a photo, extracts its text with Vision, and saves it as a note.
struct ScanNoteView: View {
    @Environment(NotesViewModel.self) private var notesViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = ScanNoteViewModel()

    var body: some View {
        @Bindable var viewModel = viewModel
        let pickerTitle = viewModel.image == nil ? "Choose Photo" : "Choose Different Photo"

        NavigationStack {
            Form {
                Section {
                    imagePreview

                    PhotosPicker(
                        selection: $viewModel.selectedItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Label(pickerTitle, systemImage: "photo.on.rectangle")
                    }
                    .disabled(viewModel.isBusy)
                } header: {
                    Text("Image")
                } footer: {
                    Text("Pick a clear photo of printed notes, a textbook page, or slides.")
                }

                if viewModel.image != nil || viewModel.errorMessage != nil {
                    recognizedTextSection

                    if !viewModel.recognizedText.isEmpty {
                        Section("Title") {
                            TextField("Note title", text: $viewModel.title)
                        }
                    }
                }
            }
            .navigationTitle("Scan Note")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save Note") {
                        notesViewModel.add(viewModel.makeNote())
                        dismiss()
                    }
                    .disabled(!viewModel.canSave)
                }
            }
        }
    }

    @ViewBuilder
    private var imagePreview: some View {
        if let image = viewModel.image {
            Image(decorative: image, scale: 1)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 280)
                .clipShape(.rect(cornerRadius: 12))
                .accessibilityLabel("Selected photo")
        } else if viewModel.isLoadingImage {
            ProgressView("Loading photo…")
                .frame(maxWidth: .infinity, minHeight: 160)
        } else {
            ContentUnavailableView(
                "No Photo Selected",
                systemImage: "doc.viewfinder",
                description: Text("Choose a photo to extract its text.")
            )
        }
    }

    @ViewBuilder
    private var recognizedTextSection: some View {
        @Bindable var viewModel = viewModel

        Section {
            if viewModel.isRecognizing {
                ProgressView("Recognizing text…")
                    .frame(maxWidth: .infinity, minHeight: 120)
            } else if let errorMessage = viewModel.errorMessage {
                VStack(alignment: .leading, spacing: 12) {
                    Label(errorMessage, systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.orange)
                    if viewModel.image != nil {
                        Button("Try Again", systemImage: "arrow.clockwise") {
                            viewModel.retryRecognition()
                        }
                    }
                }
                .padding(.vertical, 4)
            } else {
                TextEditor(text: $viewModel.recognizedText)
                    .frame(minHeight: 200)
            }
        } header: {
            Text("Recognized Text")
        } footer: {
            if !viewModel.isRecognizing && viewModel.errorMessage == nil {
                Text("Review and correct any recognition mistakes before saving.")
            }
        }
    }
}

#Preview {
    ScanNoteView()
        .environment(NotesViewModel())
}
