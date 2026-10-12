import SwiftUI

/// A tappable card representing one way to capture study material.
struct CaptureOptionCard: View {
    let option: CaptureOption

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    /// The icon tile grows with the user's text size instead of staying a fixed 52 pt.
    @ScaledMetric(relativeTo: .title2) private var iconSize: CGFloat = 52

    var body: some View {
        // At accessibility text sizes the icon moves above the text, so the title and
        // description get the full width instead of wrapping one word per line.
        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: 12))
            : AnyLayout(HStackLayout(spacing: 16))

        layout {
            Image(systemName: option.systemImage)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: iconSize, height: iconSize)
                .background(option.tint.gradient, in: .rect(cornerRadius: 12))
                .accessibilityHidden(true)

            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(option.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(option.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .accessibilityHidden(true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.background.secondary, in: .rect(cornerRadius: 16))
        .contentShape(.rect(cornerRadius: 16))
        // The enclosing Button supplies the button trait; VoiceOver reads only the title here
        // (the subtitle is the hint), so each card is one short stop.
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(option.title)
    }
}

#Preview {
    VStack {
        ForEach(CaptureOption.allCases) { option in
            CaptureOptionCard(option: option)
        }
    }
    .padding()
}
