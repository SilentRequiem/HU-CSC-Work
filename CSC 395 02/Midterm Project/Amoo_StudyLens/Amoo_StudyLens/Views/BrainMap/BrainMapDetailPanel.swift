import SwiftUI

/// Details for the selected node: its explanation (when the guide has one) and every generated
/// relationship it takes part in. Tapping a connection selects that concept on the map.
struct BrainMapDetailPanel: View {
    let node: BrainMapNode
    let graph: BrainMapGraph
    let onSelect: (String) -> Void
    /// Shown as a close button when set (the iOS panel); the macOS inspector has its own toggle.
    var onClose: (() -> Void)?
    /// Opens the shared Concept Detail screen (with the optional Wikipedia Learn More) for this node.
    var onLearnMore: (() -> Void)?

    private var edges: [BrainMapEdge] { graph.edges(involving: node.id) }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(
                    node.kind == .central ? "Central Topic" : "Concept",
                    systemImage: node.kind == .central ? "brain.head.profile" : "circle.hexagongrid"
                )
                .font(.caption.weight(.semibold))
                .foregroundStyle(.purple)

                Spacer()

                if let onClose {
                    Button("Close", systemImage: "xmark.circle.fill", action: onClose)
                        .labelStyle(.iconOnly)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .buttonStyle(.borderless)
                }
            }

            Text(node.title)
                .font(.title3.bold())
                .fixedSize(horizontal: false, vertical: true)

            if let explanation = node.explanation {
                Text(explanation)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            } else if node.kind == .concept {
                Text("Part of \(graph.central.title).")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if let onLearnMore {
                Button("Concept Details & Learn More", systemImage: "lightbulb", action: onLearnMore)
                    .font(.subheadline)
                    .buttonStyle(.bordered)
                    .tint(.purple)
            }

            Divider()

            Label("Connections (\(edges.count))", systemImage: "point.3.connected.trianglepath.dotted")
                .font(.headline)
                .foregroundStyle(.orange)

            if edges.isEmpty {
                Text("The study guide didn't include any relationships for this \(node.kind == .central ? "topic" : "concept").")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                ForEach(edges) { edge in
                    connectionRow(for: edge)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func connectionRow(for edge: BrainMapEdge) -> some View {
        let isOutgoing = edge.sourceID == node.id
        let otherID = isOutgoing ? edge.targetID : edge.sourceID
        let otherTitle = graph.node(withID: otherID)?.title ?? ""
        let sourceTitle = graph.node(withID: edge.sourceID)?.title ?? ""
        let targetTitle = graph.node(withID: edge.targetID)?.title ?? ""
        let sentence = edge.label.isEmpty
            ? "\(sourceTitle) → \(targetTitle)"
            : "\(sourceTitle) \(edge.label) \(targetTitle)"

        return Button {
            onSelect(otherID)
        } label: {
            HStack(spacing: 10) {
                Image(systemName: isOutgoing ? "arrow.right.circle.fill" : "arrow.left.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.orange)

                VStack(alignment: .leading, spacing: 2) {
                    Text(otherTitle)
                        .font(.subheadline.weight(.semibold))
                    Text(sentence)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(10)
            .background(.orange.opacity(0.1), in: .rect(cornerRadius: 10))
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(sentence)
        .accessibilityHint("Selects \(otherTitle) on the map.")
    }
}
