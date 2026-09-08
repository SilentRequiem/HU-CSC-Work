import SwiftUI

struct TabButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    var badgeCount: Int? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 4) {
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(isSelected ? .blue : .gray)
                    Text(title)
                        .font(.caption)
                        .foregroundColor(isSelected ? .blue : .gray)
                }

                if let count = badgeCount, count > 0 {
                    Text("\(count)")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.red)
                        .clipShape(Circle())
                        .offset(x: 12, y: -10)
                }
            }
        }
    }
}
