import SwiftUI

/// A card used for sections whose functionality hasn't been built yet.
struct PlaceholderCard: View {
    let title: String
    let systemImage: String
    let message: String
    var tint: Color = .accentColor

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: systemImage)
                .font(.headline)
                .foregroundStyle(tint)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.background.secondary, in: .rect(cornerRadius: 16))
    }
}

#Preview {
    PlaceholderCard(
        title: "Summary",
        systemImage: "text.alignleft",
        message: "A summary of your notes will appear here."
    )
    .padding()
}
