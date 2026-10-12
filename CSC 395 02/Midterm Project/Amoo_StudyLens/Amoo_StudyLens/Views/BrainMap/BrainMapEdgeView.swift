import SwiftUI

/// How a line is styled relative to the current selection.
enum BrainMapLineStyle {
    case normal
    case highlighted
    case dimmed
}

/// A generated relationship drawn as a curve with an arrowhead pointing at the target concept.
struct BrainMapEdgeView: View {
    let geometry: BrainMapLineGeometry
    let style: BrainMapLineStyle

    var body: some View {
        ZStack {
            Path { path in
                path.move(to: geometry.start)
                path.addQuadCurve(to: geometry.end, control: geometry.control)
            }
            .stroke(color, style: StrokeStyle(lineWidth: style == .highlighted ? 2.5 : 1.5, lineCap: .round))

            Path { path in
                path.move(to: geometry.arrowLeft)
                path.addLine(to: geometry.arrowTip)
                path.addLine(to: geometry.arrowRight)
                path.closeSubpath()
            }
            .fill(color)
        }
        .allowsHitTesting(false)
    }

    private var color: Color {
        switch style {
        // `primary` adapts to light and dark mode, so plain lines stay visible in both.
        case .normal: .primary.opacity(0.45)
        case .highlighted: .purple
        case .dimmed: .primary.opacity(0.12)
        }
    }
}

/// A faint dashed line that attaches a concept to the central topic when no generated
/// relationship already does. It has no label because it isn't a generated relationship.
struct BrainMapSpokeView: View {
    let geometry: BrainMapLineGeometry
    let style: BrainMapLineStyle

    var body: some View {
        Path { path in
            path.move(to: geometry.start)
            path.addQuadCurve(to: geometry.end, control: geometry.control)
        }
        .stroke(color, style: StrokeStyle(lineWidth: 1, lineCap: .round, dash: [4, 5]))
        .allowsHitTesting(false)
    }

    private var color: Color {
        switch style {
        case .normal: .primary.opacity(0.25)
        case .highlighted: .purple.opacity(0.6)
        case .dimmed: .primary.opacity(0.08)
        }
    }
}

/// The generated relationship text ("produces", "is part of") shown at the middle of a line.
struct BrainMapEdgeLabel: View {
    let text: String
    let style: BrainMapLineStyle

    var body: some View {
        Text(text)
            .font(.caption2.weight(style == .highlighted ? .semibold : .regular))
            .foregroundStyle(style == .highlighted ? Color.purple : Color.secondary)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .frame(maxWidth: 96)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(.background, in: .rect(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(style == .highlighted ? Color.purple.opacity(0.6) : Color.primary.opacity(0.12))
            }
            .opacity(style == .dimmed ? 0.35 : 1)
            .allowsHitTesting(false)
    }
}
