import SwiftUI

/// Visual concept map of the latest study guide.
///
/// Reads the brain-map data the Study tab already generated through the shared `StudyViewModel`;
/// it never makes its own Foundation Models request. Layout lives in `BrainMapLayout`.
struct BrainMapView: View {
    @Environment(NotesViewModel.self) private var notesViewModel
    @Environment(StudyViewModel.self) private var studyViewModel
    /// The format chosen from the Export menu; presents the export sheet when set.
    @State private var exportFormat: BrainMapExportFormat?

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Brain Map")
                #if os(iOS)
                // A large title would sit behind the legend bar and waste vertical space on the map.
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .toolbar {
                    if studyViewModel.isGenerating {
                        ToolbarItem {
                            ProgressView()
                                .controlSize(.small)
                        }
                    }
                    if studyViewModel.guide != nil {
                        ToolbarItem(placement: .primaryAction) {
                            exportMenu
                        }
                    }
                }
                .sheet(item: $exportFormat) { format in
                    if let graph = currentGraph {
                        ExportSheet(
                            title: "Export Brain Map",
                            message: "Exports the Brain Map from your current study guide. Nothing is regenerated.",
                            formats: BrainMapExportFormat.allCases,
                            initialFormat: format
                        ) { format in
                            try BrainMapExporter.makeArtifact(for: graph, format: format)
                        }
                    }
                }
        }
    }

    /// Built from the brain-map data the study guide already contains.
    private var currentGraph: BrainMapGraph? {
        guard let guide = studyViewModel.guide else { return nil }
        return BrainMapGraph(brainMap: guide.analysis.brainMap, keyConcepts: guide.analysis.keyConcepts)
    }

    private var exportMenu: some View {
        Menu {
            ForEach(BrainMapExportFormat.allCases) { format in
                Button {
                    exportFormat = format
                } label: {
                    Label(format == .image ? "Image (PNG)…" : "Outline (\(format.title))…", systemImage: format.systemImage)
                }
            }
        } label: {
            Label("Export", systemImage: "square.and.arrow.up")
        }
        .disabled(studyViewModel.isGenerating)
    }

    @ViewBuilder
    private var content: some View {
        if let guide = studyViewModel.guide {
            BrainMapScreen(
                graph: BrainMapGraph(brainMap: guide.analysis.brainMap, keyConcepts: guide.analysis.keyConcepts),
                sourceSummary: guide.source.summary,
                outdatedReason: studyViewModel.outdatedReason(for: notesViewModel.notes)
            )
            // A new guide gets a fresh screen, which clears any selection from the old map.
            .id(guide.id)
        } else if studyViewModel.isGenerating {
            ProgressView("Generating study guide…")
        } else {
            ContentUnavailableView {
                Label("No Brain Map Yet", systemImage: "brain.head.profile")
            } description: {
                Text("Generate a study guide from the Study tab first. Its concept map will appear here automatically.")
            }
        }
    }
}

// MARK: - Map screen

/// The scrollable map plus the selection detail (a bottom panel on iOS, an inspector on macOS).
private struct BrainMapScreen: View {
    let graph: BrainMapGraph
    /// The study source the map was generated from, e.g. "Selected Notes · 3 notes".
    var sourceSummary: String?
    /// Why the map no longer matches the notes (edited, deleted, or added), or nil if current.
    var outdatedReason: String?

    @State private var selectedID: String?

    /// `initialSelection` lets previews show the map with a concept already selected.
    init(graph: BrainMapGraph, sourceSummary: String? = nil, outdatedReason: String? = nil, initialSelection: String? = nil) {
        self.graph = graph
        self.sourceSummary = sourceSummary
        self.outdatedReason = outdatedReason
        _selectedID = State(initialValue: initialSelection)
    }

    private var selectedNode: BrainMapNode? {
        selectedID.flatMap { graph.node(withID: $0) }
    }

    var body: some View {
        GeometryReader { proxy in
            let layout = BrainMapLayout(graph: graph, availableSize: proxy.size)
            ScrollView([.horizontal, .vertical]) {
                BrainMapDiagram(graph: graph, layout: layout, selectedID: $selectedID)
            }
            // Start centered, but don't re-center when the iOS panel margin changes,
            // or the node the user just tapped would scroll away.
            .defaultScrollAnchor(.center, for: .initialOffset)
            #if os(iOS)
            // Lets the bottom of the map scroll above the detail panel instead of hiding under it.
            .contentMargins(.bottom, selectedNode == nil ? 0 : 280, for: .scrollContent)
            #endif
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            legend
        }
        #if os(macOS)
        .inspector(isPresented: inspectorBinding) {
            if let node = selectedNode {
                ScrollView {
                    detailPanel(for: node, showsCloseButton: false)
                        .padding()
                }
                .inspectorColumnWidth(min: 240, ideal: 280, max: 360)
            }
        }
        #else
        // An overlay (not a safe-area inset) so opening the panel never resizes or moves the map.
        .overlay(alignment: .bottom) {
            if let node = selectedNode {
                ViewThatFits(in: .vertical) {
                    detailCard(for: node)
                    ScrollView { detailCard(for: node) }
                }
                .frame(maxHeight: 300)
                .background(.background.secondary, in: .rect(cornerRadius: 20))
                .shadow(color: .black.opacity(0.15), radius: 12, y: 4)
                .padding()
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        #endif
        .animation(.snappy, value: selectedID)
    }

    private var inspectorBinding: Binding<Bool> {
        Binding(
            get: { selectedID != nil },
            set: { isPresented in
                if !isPresented { selectedID = nil }
            }
        )
    }

    private func detailPanel(for node: BrainMapNode, showsCloseButton: Bool) -> BrainMapDetailPanel {
        BrainMapDetailPanel(
            node: node,
            graph: graph,
            onSelect: { selectedID = $0 },
            onClose: showsCloseButton ? { selectedID = nil } : nil
        )
    }

    private func detailCard(for node: BrainMapNode) -> some View {
        detailPanel(for: node, showsCloseButton: true)
            .padding()
    }

    private var legend: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("\(graph.concepts.count) concepts · \(graph.edges.count) connections · Tap a concept for details")
                .font(.footnote)
                .foregroundStyle(.secondary)

            HStack(spacing: 16) {
                legendItem("Relationship", dashed: false)
                legendItem("Linked to topic", dashed: true)
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            if let sourceSummary {
                Label("From \(sourceSummary)", systemImage: "square.stack.3d.up")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.purple)
            }

            if let outdatedReason {
                Label("\(outdatedReason) Regenerate in the Study tab.", systemImage: "arrow.triangle.2.circlepath")
                    .font(.caption)
                    .foregroundStyle(.orange)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.bar)
    }

    private func legendItem(_ title: String, dashed: Bool) -> some View {
        HStack(spacing: 6) {
            Path { path in
                path.move(to: CGPoint(x: 0, y: 5))
                path.addLine(to: CGPoint(x: 24, y: 5))
            }
            .stroke(
                Color.primary.opacity(dashed ? 0.35 : 0.6),
                style: StrokeStyle(lineWidth: dashed ? 1 : 1.5, dash: dashed ? [4, 4] : [])
            )
            .frame(width: 24, height: 10)
            Text(title)
        }
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Diagram

/// Draws the map at the positions computed by `BrainMapLayout`.
/// Layers from back to front: spokes, relationship lines, nodes, relationship labels.
/// Also used by `BrainMapExporter` (non-interactive) so exported images match the screen.
struct BrainMapDiagram: View {
    let graph: BrainMapGraph
    let layout: BrainMapLayout
    @Binding var selectedID: String?
    /// False when rendering an image: nodes are drawn directly instead of as buttons.
    var isInteractive = true

    var body: some View {
        let neighbors = selectedID.map { graph.neighborIDs(of: $0) } ?? []

        ZStack(alignment: .topLeading) {
            // Tapping empty space clears the selection.
            if isInteractive {
                Color.clear
                    .contentShape(.rect)
                    .onTapGesture { selectedID = nil }
            }

            ForEach(graph.concepts) { concept in
                if let geometry = layout.spokeLines[concept.id] {
                    BrainMapSpokeView(geometry: geometry, style: spokeStyle(for: concept.id))
                }
            }

            ForEach(graph.edges) { edge in
                if let geometry = layout.edgeLines[edge.id] {
                    BrainMapEdgeView(geometry: geometry, style: lineStyle(for: edge))
                }
            }

            ForEach(graph.nodes) { node in
                if let position = layout.positions[node.id] {
                    Group {
                        if isInteractive {
                            nodeButton(for: node, emphasis: emphasis(for: node, neighbors: neighbors))
                        } else {
                            BrainMapNodeView(node: node, emphasis: emphasis(for: node, neighbors: neighbors))
                        }
                    }
                    .position(position)
                }
            }

            // Labels sit on top so a crowded label is never fully hidden. They ignore taps,
            // so the nodes underneath stay tappable.
            ForEach(graph.edges) { edge in
                if let geometry = layout.edgeLines[edge.id], !edge.label.isEmpty {
                    BrainMapEdgeLabel(text: edge.label, style: lineStyle(for: edge))
                        .position(geometry.labelPoint)
                }
            }
        }
        .frame(width: layout.canvasSize.width, height: layout.canvasSize.height)
    }

    private func nodeButton(for node: BrainMapNode, emphasis: BrainMapEmphasis) -> some View {
        Button {
            // Tapping the selected node again deselects it.
            selectedID = selectedID == node.id ? nil : node.id
        } label: {
            BrainMapNodeView(node: node, emphasis: emphasis)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(node.kind == .central ? "Central topic, \(node.title)" : node.title)
        .accessibilityValue("\(graph.edges(involving: node.id).count) connections")
        .accessibilityAddTraits(emphasis == .selected ? .isSelected : [])
    }

    private func emphasis(for node: BrainMapNode, neighbors: Set<String>) -> BrainMapEmphasis {
        guard let selectedID else { return .normal }
        if node.id == selectedID { return .selected }
        if neighbors.contains(node.id) { return .connected }
        // The central topic stays fully visible as the map's anchor.
        return node.kind == .central ? .normal : .dimmed
    }

    private func lineStyle(for edge: BrainMapEdge) -> BrainMapLineStyle {
        guard let selectedID else { return .normal }
        return edge.sourceID == selectedID || edge.targetID == selectedID ? .highlighted : .dimmed
    }

    private func spokeStyle(for conceptID: String) -> BrainMapLineStyle {
        guard let selectedID else { return .normal }
        return conceptID == selectedID || selectedID == BrainMapGraph.centralID ? .highlighted : .dimmed
    }
}

#Preview("Empty") {
    BrainMapView()
        .environment(NotesViewModel())
        .environment(StudyViewModel())
}

#Preview("Sample Map") {
    NavigationStack {
        BrainMapScreen(graph: .previewSample)
            .navigationTitle("Brain Map")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
    }
}

#Preview("Selected Concept") {
    NavigationStack {
        BrainMapScreen(graph: .previewSample, initialSelection: "concept-atp")
            .navigationTitle("Brain Map")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
    }
}

private extension BrainMapGraph {
    // Preview-only sample data; the app always uses the model-generated brain map.
    static let previewSample = BrainMapGraph(brainMap: BrainMap(
        centralTopic: "Cell Biology",
        concepts: ["Cell Membrane", "Nucleus", "Mitochondria", "ATP", "DNA", "Ribosomes", "Proteins"],
        relationships: [
            ConceptRelationship(source: "Mitochondria", target: "ATP", relationship: "produces"),
            ConceptRelationship(source: "Nucleus", target: "DNA", relationship: "stores"),
            ConceptRelationship(source: "DNA", target: "Proteins", relationship: "encodes"),
            ConceptRelationship(source: "Ribosomes", target: "Proteins", relationship: "build"),
            ConceptRelationship(source: "Cell Membrane", target: "Cell Biology", relationship: "surrounds the cell in"),
            ConceptRelationship(source: "ATP", target: "Ribosomes", relationship: "powers")
        ]
    ))
}

#Preview("Export Image") {
    let graph = BrainMapGraph.previewSample
    ScrollView([.horizontal, .vertical]) {
        BrainMapExportView(graph: graph, layout: BrainMapLayout(graph: graph, availableSize: .zero))
    }
}
