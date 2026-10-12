import CoreGraphics
import Foundation
import ImageIO
import SwiftUI
import UniformTypeIdentifiers

// MARK: - Shared export types

/// A format offered in `ExportSheet`'s picker.
protocol ExportFormat: Hashable, Identifiable {
    var title: String { get }
    var systemImage: String { get }
}

/// A finished export file in the temporary folder, shared with the Share Sheet or saved with
/// the system file exporter. The file is written once, so sharing and saving send identical bytes.
nonisolated struct ExportFile: Transferable, Sendable {
    let url: URL
    let contentType: UTType

    var fileName: String { url.lastPathComponent }
    /// File name without the extension, used as the save panel's default name.
    var baseName: String { url.deletingPathExtension().lastPathComponent }

    static var transferRepresentation: some TransferRepresentation {
        // One representation per type; the condition makes each file offer only its own type,
        // so apps receiving it (Files, Mail, AirDrop) see the right extension and kind.
        FileRepresentation(exportedContentType: .png) { SentTransferredFile($0.url) }
            .exportingCondition { $0.contentType == .png }
        FileRepresentation(exportedContentType: .markdown) { SentTransferredFile($0.url) }
            .exportingCondition { $0.contentType == .markdown }
        FileRepresentation(exportedContentType: .utf8PlainText) { SentTransferredFile($0.url) }
            .exportingCondition { $0.contentType == .utf8PlainText }
    }
}

/// What `ExportSheet` shows before the user shares or saves.
enum ExportPreview {
    case text(String)
    case image(CGImage, scale: CGFloat)
}

struct ExportArtifact {
    let file: ExportFile
    let preview: ExportPreview
}

struct ExportError: LocalizedError {
    let message: String
    var errorDescription: String? { message }
}

enum ExportFileWriter {
    /// Writes `data` into its own temporary folder so the file keeps a readable name
    /// (e.g. "Cell Biology.md") even when several exports happen in one session.
    static func write(_ data: Data, baseName: String, fileExtension: String, contentType: UTType) throws -> ExportFile {
        let folder = FileManager.default.temporaryDirectory
            .appending(path: "StudyLensExports", directoryHint: .isDirectory)
            .appending(path: UUID().uuidString, directoryHint: .isDirectory)
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)

        let url = folder.appending(path: "\(sanitizedFileName(baseName)).\(fileExtension)")
        try data.write(to: url, options: .atomic)
        return ExportFile(url: url, contentType: contentType)
    }

    /// Removes characters that aren't allowed in file names on macOS, iOS, or other systems
    /// the file might be sent to, and keeps names a reasonable length.
    static func sanitizedFileName(_ name: String) -> String {
        let disallowed = CharacterSet(charactersIn: "/\\:?%*|\"<>").union(.newlines).union(.controlCharacters)
        let cleaned = name.components(separatedBy: disallowed).joined(separator: " ")
            .split(separator: " ", omittingEmptySubsequences: true)
            .joined(separator: " ")
        let trimmed = String(cleaned.prefix(60)).trimmingCharacters(in: .whitespaces.union(CharacterSet(charactersIn: ".")))
        return trimmed.isEmpty ? "StudyLens Export" : trimmed
    }
}

// MARK: - Notes

/// Formats for exporting saved notes.
enum NoteExportFormat: String, ExportFormat, CaseIterable {
    case markdown
    case plainText

    var id: String { rawValue }

    var title: String {
        switch self {
        case .markdown: "Markdown"
        case .plainText: "Plain Text"
        }
    }

    var systemImage: String {
        switch self {
        case .markdown: "number"
        case .plainText: "doc.plaintext"
        }
    }

    var fileExtension: String {
        switch self {
        case .markdown: "md"
        case .plainText: "txt"
        }
    }

    var contentType: UTType {
        switch self {
        case .markdown: .markdown
        case .plainText: .utf8PlainText
        }
    }
}

/// Turns saved notes into `.txt` or `.md` documents. Pure string building, no model calls.
enum NoteExporter {
    static func makeArtifact(for notes: [StudyNote], format: NoteExportFormat, exportedAt date: Date = .now) throws -> ExportArtifact {
        guard !notes.isEmpty else {
            throw ExportError(message: "There are no notes to export.")
        }
        let text = document(for: notes, format: format, exportedAt: date)
        let file = try ExportFileWriter.write(
            Data(text.utf8),
            baseName: suggestedBaseName(for: notes, exportedAt: date),
            fileExtension: format.fileExtension,
            contentType: format.contentType
        )
        return ExportArtifact(file: file, preview: .text(text))
    }

    /// One note is named after its title; several notes get a dated collection name.
    static func suggestedBaseName(for notes: [StudyNote], exportedAt date: Date) -> String {
        if notes.count == 1, let note = notes.first {
            return displayTitle(of: note)
        }
        return "StudyLens Notes \(date.formatted(.iso8601.year().month().day()))"
    }

    static func document(for notes: [StudyNote], format: NoteExportFormat, exportedAt date: Date) -> String {
        switch format {
        case .markdown: markdown(for: notes, exportedAt: date)
        case .plainText: plainText(for: notes, exportedAt: date)
        }
    }

    // MARK: Markdown

    private static func markdown(for notes: [StudyNote], exportedAt date: Date) -> String {
        if notes.count == 1, let note = notes.first {
            // # Note Title, the note, then source and date metadata.
            return """
                # \(displayTitle(of: note))

                \(body(of: note))

                ---

                \(markdownMetadata(for: note))

                """
        }

        // Several notes: a collection heading, then one level-2 heading per note, separated by rules.
        var lines = [
            "# StudyLens Notes",
            "",
            "*Exported \(date.formatted(date: .long, time: .shortened)) · \(notes.count) notes*",
            ""
        ]
        for (index, note) in notes.enumerated() {
            lines += [
                "---",
                "",
                "## \(index + 1). \(displayTitle(of: note))",
                "",
                markdownMetadata(for: note),
                "",
                body(of: note),
                ""
            ]
        }
        return lines.joined(separator: "\n")
    }

    private static func markdownMetadata(for note: StudyNote) -> String {
        "**Source:** \(note.source.displayName) · **Created:** \(formattedDate(note.createdAt))"
    }

    // MARK: Plain text

    private static func plainText(for notes: [StudyNote], exportedAt date: Date) -> String {
        if notes.count == 1, let note = notes.first {
            return """
                \(underlined(displayTitle(of: note), with: "="))

                Source: \(note.source.displayName)
                Created: \(formattedDate(note.createdAt))

                \(body(of: note))

                """
        }

        var lines = [
            underlined("StudyLens Notes", with: "="),
            "Exported \(date.formatted(date: .long, time: .shortened)) - \(notes.count) notes",
            ""
        ]
        for (index, note) in notes.enumerated() {
            lines += [
                "",
                underlined("Note \(index + 1) of \(notes.count): \(displayTitle(of: note))", with: "-"),
                "Source: \(note.source.displayName)",
                "Created: \(formattedDate(note.createdAt))",
                "",
                body(of: note),
                ""
            ]
        }
        return lines.joined(separator: "\n")
    }

    private static func underlined(_ text: String, with character: Character) -> String {
        "\(text)\n\(String(repeating: character, count: max(3, min(text.count, 72))))"
    }

    // MARK: Helpers

    private static func displayTitle(of note: StudyNote) -> String {
        let title = note.title.trimmingCharacters(in: .whitespacesAndNewlines)
        return title.isEmpty ? "Untitled Note" : title
    }

    private static func body(of note: StudyNote) -> String {
        let text = note.body.trimmingCharacters(in: .whitespacesAndNewlines)
        return text.isEmpty ? "(This note has no text.)" : text
    }

    private static func formattedDate(_ date: Date) -> String {
        date.formatted(date: .long, time: .shortened)
    }
}

// MARK: - Brain Map

/// Formats for exporting the generated Brain Map.
enum BrainMapExportFormat: String, ExportFormat, CaseIterable {
    case image
    case markdown
    case plainText

    var id: String { rawValue }

    var title: String {
        switch self {
        case .image: "PNG Image"
        case .markdown: "Markdown"
        case .plainText: "Text"
        }
    }

    var systemImage: String {
        switch self {
        case .image: "photo"
        case .markdown: "number"
        case .plainText: "doc.plaintext"
        }
    }
}

/// Exports the Brain Map that the study guide already generated. Uses `BrainMapGraph` and
/// `BrainMapLayout` only; it never makes another Foundation Models request.
enum BrainMapExporter {
    /// Pixels per point. 2× keeps text crisp when the image is zoomed or printed, on any device.
    static let imageScale: CGFloat = 2

    static func makeArtifact(for graph: BrainMapGraph, format: BrainMapExportFormat, exportedAt date: Date = .now) throws -> ExportArtifact {
        let baseName = "\(graph.central.title) Brain Map"
        switch format {
        case .image:
            let image = try renderImage(of: graph)
            let file = try ExportFileWriter.write(try pngData(from: image), baseName: baseName, fileExtension: "png", contentType: .png)
            return ExportArtifact(file: file, preview: .image(image, scale: imageScale))
        case .markdown, .plainText:
            let text = outline(for: graph, markdown: format == .markdown, exportedAt: date)
            let file = try ExportFileWriter.write(
                Data(text.utf8),
                baseName: baseName,
                fileExtension: format == .markdown ? "md" : "txt",
                contentType: format == .markdown ? .markdown : .utf8PlainText
            )
            return ExportArtifact(file: file, preview: .text(text))
        }
    }

    // MARK: Image

    /// Renders the entire map, not just the part visible in the scroll view.
    ///
    /// The map is laid out again with a zero "available size", which makes `BrainMapLayout` size
    /// the canvas to exactly fit every node and label. The same `BrainMapDiagram` used on screen
    /// draws it, so the central topic, concept nodes, lines, arrows, and labels keep their styling.
    static func renderImage(of graph: BrainMapGraph) throws -> CGImage {
        let layout = BrainMapLayout(graph: graph, availableSize: .zero)
        let renderer = ImageRenderer(content: BrainMapExportView(graph: graph, layout: layout))
        renderer.scale = imageScale
        guard let image = renderer.cgImage else {
            throw ExportError(message: "StudyLens couldn't draw the Brain Map image.")
        }
        return image
    }

    /// Encodes with ImageIO, which works the same on iOS and macOS.
    static func pngData(from image: CGImage) throws -> Data {
        let data = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(data, UTType.png.identifier as CFString, 1, nil) else {
            throw ExportError(message: "StudyLens couldn't create the PNG file.")
        }
        CGImageDestinationAddImage(destination, image, nil)
        guard CGImageDestinationFinalize(destination) else {
            throw ExportError(message: "StudyLens couldn't create the PNG file.")
        }
        return data as Data
    }

    // MARK: Outline

    /// The map's structure as an indented outline: each node, then the relationships that start
    /// from it ("relationship → Target"). Every generated relationship appears exactly once.
    static func outline(for graph: BrainMapGraph, markdown: Bool, exportedAt date: Date) -> String {
        func title(_ id: String) -> String { graph.node(withID: id)?.title ?? id }

        var lines: [String] = markdown
            ? ["# \(graph.central.title)", ""]
            : ["\(graph.central.title)", String(repeating: "=", count: max(3, min(graph.central.title.count, 72))), ""]

        let summary = "Brain Map exported from StudyLens on \(date.formatted(date: .long, time: .shortened)) · \(graph.concepts.count) concepts, \(graph.edges.count) relationships"
        lines += [markdown ? "*\(summary)*" : summary, ""]

        for node in graph.nodes {
            let outgoing = graph.edges.filter { $0.sourceID == node.id }
            // The central topic is the heading, so only list it when it has its own relationships.
            if node.kind == .central && outgoing.isEmpty { continue }

            let name = node.kind == .central ? "\(node.title) (central topic)" : node.title
            lines.append(markdown ? "- **\(name)**" : "- \(name)")
            for edge in outgoing {
                let label = edge.label.isEmpty ? "relates to" : edge.label
                lines.append("  - \(label) → \(title(edge.targetID))")
            }
        }
        lines.append("")
        return lines.joined(separator: "\n")
    }
}

/// The image drawn by `BrainMapExporter`: a title header above the full diagram, on a solid
/// background in light appearance so the PNG reads well anywhere it's shared.
struct BrainMapExportView: View {
    let graph: BrainMapGraph
    let layout: BrainMapLayout

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 2) {
                    Label("StudyLens Brain Map", systemImage: "brain.head.profile")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.purple)
                    Text(graph.central.title)
                        .font(.title2.bold())
                        .lineLimit(2)
                }
                Spacer(minLength: 16)
                Text("\(graph.concepts.count) concepts · \(graph.edges.count) connections")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, BrainMapMetrics.canvasPadding)
            .padding(.top, BrainMapMetrics.canvasPadding)

            BrainMapDiagram(graph: graph, layout: layout, selectedID: .constant(nil), isInteractive: false)
        }
        .frame(width: layout.canvasSize.width)
        .background(Color.white)
        .environment(\.colorScheme, .light)
    }
}
