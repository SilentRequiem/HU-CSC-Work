import SwiftUI

/// A card listing the upcoming days with an icon and high/low temperatures.
struct DailyForecastView: View {
    let days: [DailyForecast]
    let unit: TemperatureUnit

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Label("\(days.count)-Day Forecast (\(unit.symbol))", systemImage: "calendar")
                .font(.footnote.weight(.semibold))
                .textCase(.uppercase)
                .foregroundStyle(.white.opacity(0.75))
                .padding(.bottom, 8)

            ForEach(Array(days.enumerated()), id: \.element.id) { index, day in
                if index > 0 {
                    Divider().overlay(.white.opacity(0.25))
                }
                DailyForecastRow(day: day, isToday: index == 0, unit: unit)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .glassEffect(in: .rect(cornerRadius: 20))
    }
}

/// A single forecast row: day, condition icon, low, and high.
struct DailyForecastRow: View {
    let day: DailyForecast
    let isToday: Bool
    let unit: TemperatureUnit

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(isToday ? "Today" : day.date.formatted(.dateTime.weekday(.abbreviated)))
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.white)
                Text(day.date.formatted(.dateTime.month(.abbreviated).day()))
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
            }
            .frame(minWidth: 64, alignment: .leading)

            Image(systemName: day.weatherCode.symbolName)
                .symbolRenderingMode(.multicolor)
                .font(.title2)
                .frame(width: 36)
                .shadow(color: .black.opacity(0.2), radius: 3, y: 1)

            Spacer(minLength: 8)

            Text(unit.formatShort(day.low))
                .foregroundStyle(.white.opacity(0.7))
                .frame(minWidth: 44, alignment: .trailing)
                .contentTransition(.numericText())

            Text(unit.formatShort(day.high))
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(minWidth: 44, alignment: .trailing)
                .contentTransition(.numericText())
        }
        .monospacedDigit()
        .padding(.vertical, 8)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityText)
    }

    private var accessibilityText: String {
        let dayName = isToday ? "Today" : day.date.formatted(.dateTime.weekday(.wide))
        return "\(dayName), \(day.weatherCode.description), high \(unit.format(day.high)), low \(unit.format(day.low))"
    }
}

#Preview {
    let start = Calendar.current.startOfDay(for: .now)
    let codes = [0, 2, 3, 61, 95, 71, 45]
    let days = codes.enumerated().map { offset, code in
        DailyForecast(
            date: Calendar.current.date(byAdding: .day, value: offset, to: start) ?? start,
            weatherCode: WeatherCode(rawValue: code),
            high: Measurement(value: 20 + Double(offset), unit: .celsius),
            low: Measurement(value: 10 + Double(offset) / 2, unit: .celsius)
        )
    }

    ScrollView {
        DailyForecastView(days: days, unit: .celsius)
            .padding()
    }
    .background { WeatherBackgroundView(condition: .rain).ignoresSafeArea() }
    .preferredColorScheme(.dark)
}
