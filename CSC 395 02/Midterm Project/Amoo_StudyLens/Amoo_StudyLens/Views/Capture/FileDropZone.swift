import SwiftUI
import CoreTransferable
import UniformTypeIdentifiers

// MARK: - Drag and drop
//
// Both the Capture screen and the Import File sheet accept dropped files through the same
// `.studyFileDropDestination` modifier, and both hand the file to the same import pipeline as the
// Import File button (`ImportFileViewModel.importFile(at:)` → `DocumentImportService`).
//
// The drop accepts *any* item (`.item`) on purpose: that way an unsupported file still triggers a
// drop, and StudyLens can explain what went wrong instead of the drop silently doing nothing.

/// A file dragged onto StudyLens (from Finder, Files, Mail, Safari downloads…).
nonisolated struct DroppedFile: Transferable {
    /// A private copy in the temporary directory, keeping the original file name (and extension,
    /// which `ImportFileKind.detect` relies on).
    let url: URL

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(importedContentType: .item) { received in
            // The received file is only guaranteed to exist inside this closure, so copy it.
            let folder = URL.temporaryDirectory.appending(path: "DroppedImports/\(UUID().uuidString)", directoryHint: .isDirectory)
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
            let destination = folder.appending(path: received.file.lastPathComponent)
            try FileManager.default.copyItem(at: received.file, to: destination)
            return DroppedFile(url: destination)
        }
    }
}

extension View {
    /// Accepts a dropped file for import. `onDrop` receives the file's URL, or nil when the drop
    /// contained something that isn't a file (so the caller can show a clear rejection message).
    func studyFileDropDestination(isTargeted: Binding<Bool>, onDrop: @escaping (URL?) -> Void) -> some View {
        dropDestination(for: DroppedFile.self) { files, _ in
            onDrop(files.first?.url)
            return true
        } isTargeted: { targeted in
            isTargeted.wrappedValue = targeted
        }
    }
}

/// The visible drop target: a dashed card that highlights while a file is dragged over it.
struct FileDropZone: View {
    let isTargeted: Bool
    /// Shown as a button inside the zone (e.g. "Choose File…"); nil hides it.
    var chooseTitle: String? = "Choose File…"
    var onChoose: () -> Void = {}

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: isTargeted ? "arrow.down.doc.fill" : "arrow.down.doc")
                .font(.system(size: 36))
                .foregroundStyle(isTargeted ? AnyShapeStyle(.white) : AnyShapeStyle(Color.teal))
                .symbolEffect(.bounce, value: isTargeted)

            Text(isTargeted ? "Release to Import" : "Drop a file here")
                .font(.headline)

            Text("PDF, Word document, PowerPoint, spreadsheet, image, or text file")
                .font(.subheadline)
                .foregroundStyle(isTargeted ? AnyShapeStyle(.white.opacity(0.9)) : AnyShapeStyle(.secondary))
                .multilineTextAlignment(.center)

            if let chooseTitle, !isTargeted {
                Button(chooseTitle, systemImage: "folder", action: onChoose)
                    .buttonStyle(.borderedProminent)
                    .tint(.teal)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(isTargeted ? AnyShapeStyle(Color.teal.gradient) : AnyShapeStyle(Color.teal.opacity(0.06)))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.teal.opacity(isTargeted ? 1 : 0.5), style: StrokeStyle(lineWidth: isTargeted ? 3 : 1.5, dash: [8, 6]))
        }
        .scaleEffect(isTargeted ? 1.02 : 1)
        .animation(.spring(duration: 0.25), value: isTargeted)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Import File drop zone")
    }
}

#Preview {
    VStack(spacing: 20) {
        FileDropZone(isTargeted: false)
        FileDropZone(isTargeted: true)
    }
    .padding()
}
