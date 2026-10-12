import SwiftUI

/// Shown when the user reaches the end of a pass through the deck.
struct FlashcardSessionSummaryView: View {
    let summary: FlashcardSessionSummary
    let pass: Int
    let onStudyReviewCards: () -> Void
    let onRestartAll: () -> Void
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 6) {
                Image(systemName: summary.review == 0 && summary.studied > 0 ? "checkmark.seal.fill" : "rectangle.stack.fill")
                    .font(.largeTitle)
                    .foregroundStyle(Color.flashcardsAccent)
                Text(pass > 1 ? "Review Round \(pass) Complete" : "Session Complete")
                    .font(.title2.bold())
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            KnownGauge(fraction: summary.fractionKnown)

            Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                GridRow {
                    StatTile(value: summary.studied, title: "Cards Studied", systemImage: "rectangle.stack", tint: .flashcardsAccent)
                    StatTile(value: summary.known, title: "Know It", systemImage: "checkmark.circle", tint: .green)
                }
                GridRow {
                    StatTile(value: summary.review, title: "Review Again", systemImage: "arrow.counterclockwise.circle", tint: .orange)
                    StatTile(value: summary.skipped, title: "Skipped", systemImage: "forward.circle", tint: .secondary)
                }
            }

            VStack(spacing: 10) {
                Button(action: onStudyReviewCards) {
                    Label(
                        summary.review == 0 ? "No Cards to Review" : "Study \(summary.review) Review \(summary.review == 1 ? "Card" : "Cards") Again",
                        systemImage: "arrow.counterclockwise"
                    )
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                .disabled(summary.review == 0)

                Button(action: onRestartAll) {
                    Label("Restart All Cards", systemImage: "arrow.trianglehead.2.clockwise.rotate.90")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(.flashcardsAccent)

                Button("Done", action: onDone)
                    .buttonStyle(.borderless)
                    .padding(.top, 4)
            }
            .controlSize(.large)
        }
        .padding(24)
        .frame(maxWidth: 520)
        .background(Color.flashcardSurface, in: .rect(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
    }

    private var message: String {
        if summary.studied == 0 {
            return "You went through the deck without rating any cards. Flip a card and choose Know It or Review Again to track progress."
        } else if summary.review == 0 {
            return "You marked every card you studied as Know It."
        } else {
            return "Study the cards you marked Review Again, or start over with the full deck."
        }
    }
}

/// A ring showing the percentage of studied cards marked Know It.
private struct KnownGauge: View {
    let fraction: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.flashcardsAccent.opacity(0.15), lineWidth: 12)
            Circle()
                .trim(from: 0, to: fraction)
                .stroke(Color.flashcardsAccent.gradient, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(-90))
            VStack(spacing: 0) {
                Text(fraction, format: .percent.precision(.fractionLength(0)))
                    .font(.title.bold().monospacedDigit())
                Text("known")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 130, height: 130)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(fraction.formatted(.percent.precision(.fractionLength(0)))) known")
    }
}

private struct StatTile: View {
    let value: Int
    let title: String
    let systemImage: String
    let tint: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value, format: .number)
                .font(.title2.bold().monospacedDigit())
            Label(title, systemImage: systemImage)
                .font(.caption)
                .foregroundStyle(tint)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(.secondary.opacity(0.08), in: .rect(cornerRadius: 14))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    FlashcardSessionSummaryView(
        summary: FlashcardSessionSummary(cardsInPass: 12, known: 8, review: 3),
        pass: 1,
        onStudyReviewCards: {},
        onRestartAll: {},
        onDone: {}
    )
    .padding()
}
