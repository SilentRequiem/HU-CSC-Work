import SwiftUI

/// A tappable card representing one way to capture study material.
struct CaptureOptionCard: View {
    let option: CaptureOption

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: option.systemImage)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 52, height: 52)
                .background(option.tint.gradient, in: .rect(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(option.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(option.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(.background.secondary, in: .rect(cornerRadius: 16))
        .contentShape(.rect(cornerRadius: 16))
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
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
