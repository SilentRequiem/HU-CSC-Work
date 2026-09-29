import SwiftUI

/// A full-screen gradient that reflects the current weather condition.
///
/// Every palette is kept mid-to-dark so white foreground text stays readable.
/// All palettes have the same number of stops so SwiftUI can animate between them.
struct WeatherBackgroundView: View {
    /// The condition to depict, or `nil` for the neutral default before a lookup.
    let condition: WeatherCondition?

    var body: some View {
        LinearGradient(
            colors: Self.colors(for: condition),
            startPoint: .top,
            endPoint: .bottom
        )
        .animation(.easeInOut(duration: 0.8), value: condition)
    }

    /// The gradient stops for a condition, listed from top to bottom.
    static func colors(for condition: WeatherCondition?) -> [Color] {
        switch condition {
        case .clear:
            [Color(red: 0.05, green: 0.36, blue: 0.82),
             Color(red: 0.16, green: 0.55, blue: 0.92),
             Color(red: 0.32, green: 0.68, blue: 0.95)]

        case .partlyCloudy:
            [Color(red: 0.22, green: 0.42, blue: 0.72),
             Color(red: 0.40, green: 0.56, blue: 0.76),
             Color(red: 0.58, green: 0.66, blue: 0.78)]

        case .cloudy:
            [Color(red: 0.30, green: 0.36, blue: 0.45),
             Color(red: 0.42, green: 0.48, blue: 0.56),
             Color(red: 0.55, green: 0.60, blue: 0.66)]

        case .fog:
            [Color(red: 0.40, green: 0.43, blue: 0.48),
             Color(red: 0.52, green: 0.55, blue: 0.60),
             Color(red: 0.63, green: 0.66, blue: 0.70)]

        case .drizzle:
            [Color(red: 0.20, green: 0.30, blue: 0.45),
             Color(red: 0.30, green: 0.42, blue: 0.58),
             Color(red: 0.42, green: 0.54, blue: 0.68)]

        case .rain:
            [Color(red: 0.12, green: 0.20, blue: 0.36),
             Color(red: 0.20, green: 0.30, blue: 0.48),
             Color(red: 0.28, green: 0.40, blue: 0.58)]

        case .snow:
            [Color(red: 0.38, green: 0.50, blue: 0.68),
             Color(red: 0.55, green: 0.65, blue: 0.80),
             Color(red: 0.70, green: 0.78, blue: 0.88)]

        case .thunderstorm:
            [Color(red: 0.08, green: 0.08, blue: 0.18),
             Color(red: 0.18, green: 0.16, blue: 0.32),
             Color(red: 0.30, green: 0.26, blue: 0.46)]

        case .unknown, nil:
            [Color(red: 0.16, green: 0.32, blue: 0.58),
             Color(red: 0.26, green: 0.46, blue: 0.72),
             Color(red: 0.38, green: 0.58, blue: 0.82)]
        }
    }
}

#Preview("Conditions") {
    let conditions: [WeatherCondition?] = [
        nil, .clear, .partlyCloudy, .cloudy, .fog, .drizzle, .rain, .snow, .thunderstorm,
    ]

    ScrollView {
        VStack(spacing: 8) {
            ForEach(Array(conditions.enumerated()), id: \.offset) { _, condition in
                WeatherBackgroundView(condition: condition)
                    .frame(height: 60)
                    .overlay {
                        Text(String(describing: condition ?? .unknown))
                            .foregroundStyle(.white)
                    }
                    .clipShape(.rect(cornerRadius: 8))
            }
        }
        .padding()
    }
}
