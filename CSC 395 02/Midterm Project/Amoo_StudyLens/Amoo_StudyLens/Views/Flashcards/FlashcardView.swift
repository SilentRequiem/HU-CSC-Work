import SwiftUI

/// A two-sided study card that flips in 3D when `isFlipped` changes inside an animation.
/// Purely presentational: the parent owns the flip state and decides what tapping does.
struct FlashcardView: View {
    let card: Flashcard
    let isFlipped: Bool
    /// e.g. "3 of 12"
    let position: String

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        // Reduce Motion swaps the 3D turn for a simple cross-fade between sides.
        FlipContainer(angle: isFlipped ? 180 : 0, rotates: !reduceMotion) {
            FlashcardFace(card: card, isBack: false, position: position)
        } back: {
            FlashcardFace(card: card, isBack: true, position: position)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(card.kind.displayName) card, \(position). \(isFlipped ? card.kind.backHeading : card.kind.frontHeading): \(isFlipped ? card.back : card.front)")
        .accessibilityHint(isFlipped ? "Flips back to the front." : "Reveals the \(card.kind.backHeading.lowercased()).")
    }
}

// MARK: - Flip

/// Rotates its content around the vertical axis. Because it's `Animatable`, SwiftUI calls
/// `body` with every in-between angle, so the front can be swapped for the back exactly when
/// the card is edge-on (90°) instead of the two sides fading over each other.
private struct FlipContainer<Front: View, Back: View>: View, Animatable {
    var angle: Double
    let rotates: Bool
    @ViewBuilder let front: Front
    @ViewBuilder let back: Back

    var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }

    private var showsBack: Bool { angle >= 90 }

    var body: some View {
        // Both faces stay in the layout so the card keeps the size of its larger side and
        // doesn't jump when it flips.
        ZStack {
            front
                .opacity(showsBack ? 0 : 1)
                .accessibilityHidden(showsBack)
            back
                // Pre-rotate the back so it reads correctly once the card has turned over.
                .rotation3DEffect(.degrees(rotates ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                .opacity(showsBack ? 1 : 0)
                .accessibilityHidden(!showsBack)
        }
        .rotation3DEffect(.degrees(rotates ? angle : 0), axis: (x: 0, y: 1, z: 0), perspective: 0.45)
    }
}

// MARK: - Face

/// One side of the card, styled like a paper index card.
private struct FlashcardFace: View {
    let card: Flashcard
    let isBack: Bool
    let position: String

    private var tint: Color { card.kind.tint }

    var body: some View {
        VStack(spacing: 14) {
            header

            Spacer(minLength: 4)

            Text(isBack ? card.kind.backHeading : card.kind.frontHeading)
                .font(.caption.weight(.semibold))
                .textCase(.uppercase)
                .kerning(1.2)
                .foregroundStyle(isBack ? tint : .secondary)

            Text(isBack ? card.back : card.front)
                .font(contentFont)
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)
                // Long answers make the card taller instead of being cut off.
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity)

            Spacer(minLength: 4)

            footer
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 18)
        .frame(maxWidth: .infinity, minHeight: 300)
        .background { FlashcardPaper(tint: tint, isRuled: isBack) }
    }

    /// A concept's front is a short term, so it's shown large like a vocabulary card; a
    /// question is a full sentence, so it's smaller. Backs use body-sized reading text.
    private var contentFont: Font {
        switch (card.kind, isBack) {
        case (.keyConcept, false): .largeTitle.bold()
        case (.question, false): .title2.weight(.semibold)
        case (_, true): .title3
        }
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            Label(card.kind.displayName, systemImage: card.kind.systemImage)
                .font(.caption.weight(.semibold))
                .foregroundStyle(tint)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(tint.opacity(0.14), in: .capsule)

            Spacer(minLength: 8)

            Text(position)
                .font(.caption.weight(.medium).monospacedDigit())
                .foregroundStyle(.secondary)
        }
    }

    private var footer: some View {
        ViewThatFits(in: .horizontal) {
            HStack {
                sourceLabel
                Spacer(minLength: 8)
                instructionLabel
            }
            VStack(spacing: 4) {
                instructionLabel
                sourceLabel
            }
        }
        .font(.caption)
        .foregroundStyle(.secondary)
    }

    private var sourceLabel: some View {
        Text(card.sourceDescription)
            .lineLimit(1)
    }

    private var instructionLabel: some View {
        Label(isBack ? "Tap to see front" : card.kind.revealInstruction, systemImage: "hand.tap")
            .lineLimit(1)
    }
}

/// The card stock: rounded corners, a colored top edge, faint ruled lines on the back, and a
/// soft shadow so it reads as a physical card rather than a settings panel.
private struct FlashcardPaper: View {
    let tint: Color
    let isRuled: Bool

    private let shape = RoundedRectangle(cornerRadius: 24, style: .continuous)

    var body: some View {
        shape
            .fill(Color.flashcardSurface)
            .overlay {
                ZStack(alignment: .top) {
                    if isRuled {
                        RuledLines()
                    }
                    Rectangle()
                        .fill(tint.gradient)
                        .frame(height: 6)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .clipShape(shape)
            }
            .overlay { shape.strokeBorder(tint.opacity(0.25), lineWidth: 1) }
            .shadow(color: .black.opacity(0.14), radius: 14, x: 0, y: 8)
    }
}

/// Index-card style horizontal rules.
private struct RuledLines: View {
    var body: some View {
        Canvas { context, size in
            var y: CGFloat = 64
            while y < size.height - 24 {
                var line = Path()
                line.move(to: CGPoint(x: 20, y: y))
                line.addLine(to: CGPoint(x: size.width - 20, y: y))
                context.stroke(line, with: .color(.primary.opacity(0.06)), lineWidth: 1)
                y += 30
            }
        }
        .accessibilityHidden(true)
    }
}

// MARK: - Colors

extension FlashcardKind {
    /// Matches the Study tab: green for Practice Questions, orange for Key Concepts.
    var tint: Color {
        switch self {
        case .question: .green
        case .keyConcept: .orange
        }
    }
}

extension Color {
    /// The Flashcards feature color in the Study tab, distinct from the guide's purple,
    /// Quiz Me's green, and Key Concepts' orange.
    static let flashcardsAccent = Color.indigo

    /// A card surface that stands out from `flashcardsBackground` in Light and Dark Mode.
    static var flashcardSurface: Color {
        #if os(macOS)
        Color(nsColor: .controlBackgroundColor)
        #else
        Color(uiColor: .secondarySystemGroupedBackground)
        #endif
    }

    /// The screen behind the cards.
    static var flashcardsBackground: Color {
        #if os(macOS)
        Color(nsColor: .windowBackgroundColor)
        #else
        Color(uiColor: .systemGroupedBackground)
        #endif
    }
}

#Preview("Question and Concept") {
    let cards = Flashcard.deck(from: .flashcardsPreviewSample)
    ScrollView {
        VStack(spacing: 24) {
            FlashcardView(card: cards[0], isFlipped: false, position: "1 of \(cards.count)")
            FlashcardView(card: cards[0], isFlipped: true, position: "1 of \(cards.count)")
            FlashcardView(card: cards[2], isFlipped: false, position: "3 of \(cards.count)")
        }
        .padding()
    }
    .background(Color.flashcardsBackground)
}
