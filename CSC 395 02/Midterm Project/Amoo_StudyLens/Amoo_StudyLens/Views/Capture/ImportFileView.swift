import SwiftUI

/// Import File: choose (or drop) a document, watch extraction progress, review and correct the
/// extracted text, give it a title, and save it as a note.
///
/// The file can arrive three ways, all feeding `ImportFileViewModel.importFile(at:)`:
///   1. the Choose File button (system file picker, `.fileImporter`) — iOS, iPadOS, and macOS;
///   2. a drop onto this sheet;
///   3. a drop onto the Capture screen, handed over through `AppNavigationModel.pendingImport`.
struct ImportFileView: View {
    @Environment(NotesViewModel.self) private var notesViewModel
    @Environment(AppNavigationModel.self) private var navigation
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = ImportFileViewModel()
    @State private var isPickingFile = false
    @State private var isDropTargeted = false

    var body: some View {
        NavigationStack {
            Form {
                sourceSection

                if viewModel.phase != .idle {
                    fileSection
                }

                if viewModel.phase == .review {
                    reviewSections
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Import File")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { close() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save Note") {
                        // SAVE AS .imported: the same shared NotesViewModel (and SwiftData store) as
                        // every other capture method, so the note appears in Notes and can be studied.
                        notesViewModel.add(viewModel.makeNote())
                        close()
                    }
                    .disabled(!viewModel.canSave)
                }
            }
            // The whole sheet is a drop target too, so a different file can be dropped at any time.
            .studyFileDropDestination(isTargeted: $isDropTargeted) { url in
                handleDrop(url)
            }
            .fileImporter(isPresented: $isPickingFile, allowedContentTypes: ImportFileKind.allowedContentTypes) { result in
                switch result {
                case .success(let url): viewModel.importFile(at: url)
                case .failure(let error): if (error as NSError).code != NSUserCancelledError { viewModel.reportFailure(error.localizedDescription) }
                }
            }
        }
        .studyLensSheetFrame()
        .onAppear {
            // Pick up a file that was dropped onto the Capture screen.
            switch navigation.takePendingImport() {
            case .file(let url): viewModel.importFile(at: url)
            case .unsupportedDrop: viewModel.reportUnsupportedDrop()
            case nil: break
            }
        }
        .onDisappear { viewModel.cancel() }
    }

    private func close() {
        viewModel.cancel()
        dismiss()
    }

    private func handleDrop(_ url: URL?) {
        if let url {
            viewModel.importFile(at: url)
        } else {
            viewModel.reportUnsupportedDrop()
        }
    }

    // MARK: - Sections

    @ViewBuilder
    private var sourceSection: some View {
        Section {
            FileDropZone(
                isTargeted: isDropTargeted,
                chooseTitle: viewModel.phase == .idle ? "Choose File…" : "Choose Different File…",
                onChoose: { isPickingFile = true }
            )
            .disabled(viewModel.isExtracting)
            .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
        } footer: {
            Text("Supported: \(ImportFileKind.supportedFormatsDescription). StudyLens saves the extracted text, not the file.")
        }
    }

    @ViewBuilder
    private var fileSection: some View {
        Section("File") {
            if let filename = viewModel.filename {
                LabeledContent("Name") {
                    Text(filename)
                        .lineLimit(2)
                        .truncationMode(.middle)
                        .textSelection(.enabled)
                }
            }
            LabeledContent("Detected Type") {
                Label(
                    viewModel.detectedKind?.displayName ?? "Unsupported",
                    systemImage: viewModel.detectedKind?.systemImage ?? "questionmark.square.dashed"
                )
            }
            if let unit = viewModel.fileInfo.flatMap({ $0.kind.unitDescription(count: $0.unitCount) }) {
                LabeledContent("Contains", value: unit)
            }

            switch viewModel.phase {
            case .extracting:
                VStack(alignment: .leading, spacing: 8) {
                    if let fraction = viewModel.progress?.fractionCompleted {
                        ProgressView(value: fraction)
                    } else {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Text(viewModel.progress?.message ?? "Extracting text…")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            case .failed(let message):
                // Retry for a supported file that failed to extract; otherwise the drop zone's
                // Choose Different File… above is the next step.
                StatusMessageView(
                    message: message,
                    actionTitle: viewModel.canRetry ? "Try Again" : nil,
                    action: viewModel.retry
                )
                .padding(.vertical, 4)
            case .idle, .review:
                EmptyView()
            }

            ForEach(viewModel.notices, id: \.self) { notice in
                Label(notice, systemImage: "info.circle")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder
    private var reviewSections: some View {
        @Bindable var viewModel = viewModel

        Section("Title") {
            TextField("Note title", text: $viewModel.title)
        }

        Section {
            TextEditor(text: $viewModel.text)
                .frame(minHeight: 260)
        } header: {
            Text("Extracted Text")
        } footer: {
            Text("Review and correct the text before saving. Only this text is stored in StudyLens.")
        }
    }
}

#Preview {
    ImportFileView()
        .environment(NotesViewModel())
        .environment(AppNavigationModel())
}
