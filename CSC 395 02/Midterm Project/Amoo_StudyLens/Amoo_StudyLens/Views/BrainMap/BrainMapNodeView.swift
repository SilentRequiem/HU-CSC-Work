import SwiftUI

/// How a node is styled relative to the current selection.
enum BrainMapEmphasis {
    case normal
    case selected
    /// Joined to the selected node by a generated relationship.
    case connected
    /// A selection exists and this node isn't part of it.
    case dimmed
}

/// One bubble in the Brain Map. The central topic gets a bold gradient card; concepts get
/// restrained cards whose tint reflects the selection.
struct BrainMapNodeView: View {
    let node: BrainMapNode
    let emphasis: BrainMapEmphasis

    var body: some View {
        switch node.kind {
        case .central: centralBody
        case .concept: conceptBody
        }
    }

    private var centralBody: some View {
        VStack(spacing: 4) {
            Image(systemName: "brain.head.profile")
                .font(.title3)
            Text(node.title)
                .font(.headline)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
        }
        .foregroundStyle(.white)
        .padding(10)
        .frame(width: BrainMapMetrics.centralSize.width, height: BrainMapMetrics.centralSize.height)
        .background(
            LinearGradient(colors: [.purple, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing),
            in: .rect(cornerRadius: 22)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .strokeBorder(borderColor, lineWidth: emphasis == .normal ? 0 : 3)
        }
        .shadow(color: .purple.opacity(0.35), radius: 8, y: 3)
    }

    private var conceptBody: some View {
        Text(node.title)
            .font(.subheadline.weight(.medium))
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .minimumScaleFactor(0.75)
            .foregroundStyle(emphasis == .selected ? Color.white : Color.primary)
            .padding(.horizontal, 10)
            .frame(width: BrainMapMetrics.conceptSize.width, height: BrainMapMetrics.conceptSize.height)
            .background(conceptFill, in: .rect(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(borderColor, lineWidth: emphasis == .normal || emphasis == .dimmed ? 1 : 2)
            }
            .opacity(emphasis == .dimmed ? 0.45 : 1)
    }

    private var conceptFill: AnyShapeStyle {
        switch emphasis {
        case .selected: AnyShapeStyle(Color.purple)
        case .connected: AnyShapeStyle(Color.orange.opacity(0.18))
        case .normal, .dimmed: AnyShapeStyle(.background.secondary)
        }
    }

    private var borderColor: Color {
        switch emphasis {
        case .selected: node.kind == .central ? .orange : .purple
        case .connected: .orange
        case .normal, .dimmed: .primary.opacity(0.15)
        }
    }
}

#Preview {
    let central = BrainMapNode(id: "c", title: "Cell Biology", kind: .central, explanation: nil)
    let concept = BrainMapNode(id: "a", title: "Mitochondria", kind: .concept, explanation: nil)
    VStack(spacing: 16) {
        BrainMapNodeView(node: central, emphasis: .normal)
        HStack {
            BrainMapNodeView(node: concept, emphasis: .normal)
            BrainMapNodeView(node: concept, emphasis: .selected)
        }
        HStack {
            BrainMapNodeView(node: concept, emphasis: .connected)
            BrainMapNodeView(node: concept, emphasis: .dimmed)
        }
    }
    .padding()
}
