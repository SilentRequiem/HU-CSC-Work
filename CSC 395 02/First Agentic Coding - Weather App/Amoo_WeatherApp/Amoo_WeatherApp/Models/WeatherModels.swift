import Foundation

/// A geographic location returned by the Open-Meteo geocoding API.
struct Location: Equatable, Sendable {
    let name: String
    let country: String?
    let admin1: String?
    let latitude: Double
    let longitude: Double

    /// A human-readable label such as "Paris, Île-de-France, France".
    var displayName: String {
        [name, admin1, country]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }
}

/// The temperature scale used when displaying a reading.
enum TemperatureUnit: Equatable, Sendable {
    case celsius
    case fahrenheit

    /// The Foundation unit used for conversions.
    var unit: UnitTemperature {
        switch self {
        case .celsius: .celsius
        case .fahrenheit: .fahrenheit
        }
    }

    /// The suffix shown after the number, e.g. "°C".
    var symbol: String {
        switch self {
        case .celsius: "°C"
        case .fahrenheit: "°F"
        }
    }

    /// A spoken name for accessibility, e.g. "Celsius".
    var spokenName: String {
        switch self {
        case .celsius: "Celsius"
        case .fahrenheit: "Fahrenheit"
        }
    }

    /// The other scale, used when the user taps to switch.
    var toggled: TemperatureUnit {
        switch self {
        case .celsius: .fahrenheit
        case .fahrenheit: .celsius
        }
    }

    /// Interprets a unit string reported by Open-Meteo, e.g. "°C" or "°F".
    init(apiUnit: String) {
        self = apiUnit.localizedCaseInsensitiveContains("f") ? .fahrenheit : .celsius
    }

    /// Converts a reading to this scale and rounds it to a whole number.
    func roundedValue(of measurement: Measurement<UnitTemperature>) -> Double {
        let value = measurement.converted(to: unit).value.rounded()
        return value == 0 ? 0 : value // Avoid displaying "-0".
    }

    /// A reading formatted with the full unit, e.g. "21°C".
    func format(_ measurement: Measurement<UnitTemperature>) -> String {
        "\(roundedValue(of: measurement).formatted(.number.precision(.fractionLength(0))))\(symbol)"
    }

    /// A compact reading with only the degree sign, e.g. "21°". Used in dense lists.
    func formatShort(_ measurement: Measurement<UnitTemperature>) -> String {
        "\(roundedValue(of: measurement).formatted(.number.precision(.fractionLength(0))))°"
    }
}

/// The current weather conditions at a location.
struct CurrentWeather: Equatable, Sendable {
    let temperature: Double
    /// The unit string reported by the API, e.g. "°C". Used to interpret `temperature`.
    let temperatureUnit: String
    let weatherCode: WeatherCode
    let observedAt: Date?

    /// The reading as a `Measurement`, so it can be converted to any scale.
    var measurement: Measurement<UnitTemperature> {
        Measurement(value: temperature, unit: TemperatureUnit(apiUnit: temperatureUnit).unit)
    }

    /// Temperature formatted for display in the requested scale, e.g. "21°C" or "70°F".
    func formattedTemperature(in unit: TemperatureUnit) -> String {
        unit.format(measurement)
    }

    /// Temperature formatted in the scale reported by the API.
    var formattedTemperature: String {
        formattedTemperature(in: TemperatureUnit(apiUnit: temperatureUnit))
    }
}

/// One day of the multi-day forecast.
struct DailyForecast: Identifiable, Equatable, Sendable {
    /// The calendar day, at local midnight.
    let date: Date
    let weatherCode: WeatherCode
    let high: Measurement<UnitTemperature>
    let low: Measurement<UnitTemperature>

    var id: Date { date }
}

/// A broad category of weather, used to pick icons and background styling.
enum WeatherCondition: Equatable, Sendable {
    case clear
    case partlyCloudy
    case cloudy
    case fog
    case drizzle
    case rain
    case snow
    case thunderstorm
    case unknown
}

/// WMO weather interpretation codes as used by Open-Meteo.
/// Unknown codes are preserved via `rawValue` so new codes don't cause decoding failures.
struct WeatherCode: RawRepresentable, Equatable, Sendable {
    let rawValue: Int

    init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// A short, human-readable description of the weather condition.
    var description: String {
        switch rawValue {
        case 0: "Clear sky"
        case 1: "Mainly clear"
        case 2: "Partly cloudy"
        case 3: "Overcast"
        case 45: "Fog"
        case 48: "Depositing rime fog"
        case 51: "Light drizzle"
        case 53: "Moderate drizzle"
        case 55: "Dense drizzle"
        case 56: "Light freezing drizzle"
        case 57: "Dense freezing drizzle"
        case 61: "Slight rain"
        case 63: "Moderate rain"
        case 65: "Heavy rain"
        case 66: "Light freezing rain"
        case 67: "Heavy freezing rain"
        case 71: "Slight snowfall"
        case 73: "Moderate snowfall"
        case 75: "Heavy snowfall"
        case 77: "Snow grains"
        case 80: "Slight rain showers"
        case 81: "Moderate rain showers"
        case 82: "Violent rain showers"
        case 85: "Slight snow showers"
        case 86: "Heavy snow showers"
        case 95: "Thunderstorm"
        case 96: "Thunderstorm with slight hail"
        case 99: "Thunderstorm with heavy hail"
        default: "Unknown conditions"
        }
    }

    /// The broad category this code belongs to.
    var condition: WeatherCondition {
        switch rawValue {
        case 0, 1: .clear
        case 2: .partlyCloudy
        case 3: .cloudy
        case 45, 48: .fog
        case 51, 53, 55, 56, 57: .drizzle
        case 61, 63, 65, 66, 67, 80, 81, 82: .rain
        case 71, 73, 75, 77, 85, 86: .snow
        case 95, 96, 99: .thunderstorm
        default: .unknown
        }
    }

    /// The SF Symbol name that best represents the condition.
    var symbolName: String {
        switch rawValue {
        case 0, 1: "sun.max.fill"
        case 2: "cloud.sun.fill"
        case 3: "cloud.fill"
        case 45, 48: "cloud.fog.fill"
        case 51, 53, 55: "cloud.drizzle.fill"
        case 56, 57, 66, 67: "cloud.sleet.fill"
        case 61, 63: "cloud.rain.fill"
        case 65, 82: "cloud.heavyrain.fill"
        case 71, 73, 75, 85, 86: "cloud.snow.fill"
        case 77: "snowflake"
        case 80: "cloud.sun.rain.fill"
        case 81: "cloud.rain.fill"
        case 95: "cloud.bolt.fill"
        case 96, 99: "cloud.hail.fill"
        default: "questionmark.circle"
        }
    }
}

/// A combined result of a successful weather lookup.
struct WeatherReport: Equatable, Sendable {
    let location: Location
    let current: CurrentWeather
    /// Upcoming days, starting with today.
    var daily: [DailyForecast] = []
}
