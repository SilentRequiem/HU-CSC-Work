import SwiftUI

/// Previews an export and hands it to the system: the Share Sheet (AirDrop, Mail, Messages,
/// Save to Files on iOS) or the file exporter (a save panel on macOS, the Files browser on iOS).
/// Used for notes and for the Brain Map; `makeArtifact` builds the file for the chosen format.
struct ExportSheet<Format: ExportFormat>: View {
    let title: String
    let message: String
    let formats: [Format]
    let makeArtifact: (Format) throws -> ExportArtifact

    @Environment(\.dismiss) private var dismiss
    @State private var format: Format
    @State private var artifact: ExportArtifact?
    @State private var errorMessage: String?
    @State private var isSaving = false
    @State private var savedFileName: String?

    init(
        title: String,
        message: String,
        formats: [Format],
        initialFormat: Format,
        makeArtifact: @escaping (Format) throws -> ExportArtifact
    ) {
        self.title = title
        self.message = message
        self.formats = formats
        self.makeArtifact = makeArtifact
        _format = State(initialValue: initialFormat)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if formats.count > 1 {
                        Picker("Format", selection: $format) {
                            ForEach(formats) { format in
                                Text(format.title).tag(format)
                            }
                        }
                        .pickerStyle(.segmented)
                        .labelsHidden()
                    }

                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)

                    if let errorMessage {
                        Label(errorMessage, systemImage: "exclamationmark.triangle")
                            .font(.subheadline)
                            .foregroundStyle(.red)
                    }

                    if let artifact {
                        Label(artifact.file.fileName, systemImage: format.systemImage)
                            .font(.footnote.weight(.semibold))
                        preview(artifact.preview)
                        actions(for: artifact.file)
                    } else if errorMessage == nil {
                        ProgressView("Preparing export…")
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
            }
            .navigationTitle(title)
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        #if os(macOS)
        .frame(minWidth: 520, idealWidth: 600, minHeight: 520, idealHeight: 640)
        #endif
        // Builds the file when the sheet opens and again whenever the format changes.
        .task(id: format) { build() }
        .fileExporter(
            isPresented: $isSaving,
            item: artifact?.file,
            contentTypes: artifact.map { [$0.file.contentType] } ?? [],
            defaultFilename: artifact?.file.baseName
        ) { result in
            switch result {
            case .success(let url):
                savedFileName = url.lastPathComponent
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }

    private func build() {
        savedFileName = nil
        do {
            artifact = try makeArtifact(format)
            errorMessage = nil
        } catch {
            artifact = nil
            errorMessage = error.localizedDescription
        }
    }

    @ViewBuilder
    private func preview(_ preview: ExportPreview) -> some View {
        switch preview {
        case .text(let text):
            ScrollView([.vertical]) {
                Text(text)
                    .font(.footnote.monospaced())
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
            }
            .frame(maxHeight: 320)
            .background(.background.secondary, in: .rect(cornerRadius: 12))
        case .image(let image, let scale):
            Image(decorative: image, scale: scale)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 360)
                .clipShape(.rect(cornerRadius: 12))
                .overlay {
                    RoundedRectangle(cornerRadius: 12).strokeBorder(.primary.opacity(0.12))
                }
            Text("\(image.width) × \(image.height) pixels · the entire map, including parts outside the visible area.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private func actions(for file: ExportFile) -> some View {
        VStack(spacing: 10) {
            ShareLink(
                item: file,
                preview: SharePreview(file.fileName, image: Image(systemName: format.systemImage))
            ) {
                Label("Share…", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            Button {
                isSaving = true
            } label: {
                #if os(macOS)
                Label("Save As…", systemImage: "arrow.down.doc")
                    .frame(maxWidth: .infinity)
                #else
                Label("Save to Files…", systemImage: "folder")
                    .frame(maxWidth: .infinity)
                #endif
            }
            .buttonStyle(.bordered)
            .controlSize(.large)

            if let savedFileName {
                Label("Saved \(savedFileName)", systemImage: "checkmark.circle.fill")
                    .font(.footnote)
                    .foregroundStyle(.green)
            }
        }
    }
}
