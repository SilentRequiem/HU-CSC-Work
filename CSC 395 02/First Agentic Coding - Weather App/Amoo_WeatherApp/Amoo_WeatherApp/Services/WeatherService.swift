import Foundation

/// Errors that can occur while looking up weather.
enum WeatherServiceError: LocalizedError, Equatable {
    case emptyCityName
    case cityNotFound(String)
    case invalidURL
    case badServerResponse(statusCode: Int)
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .emptyCityName:
            "Please enter a city name."
        case .cityNotFound(let city):
            "Couldn't find a city named “\(city)”."
        case .invalidURL:
            "The request URL could not be built."
        case .badServerResponse(let statusCode):
            "The server returned an unexpected response (\(statusCode))."
        case .decodingFailed:
            "The weather data could not be read."
        }
    }
}

/// Abstraction over the weather data source so the view model can be tested
/// or backed by a different provider later.
protocol WeatherService: Sendable {
    /// Resolves a city name to a location using a geocoding service.
    func geocode(city: String) async throws -> Location

    /// Fetches the current weather for the given coordinates.
    func currentWeather(latitude: Double, longitude: Double) async throws -> CurrentWeather

    /// Fetches the daily forecast for the given coordinates, starting with today.
    func dailyForecast(latitude: Double, longitude: Double, days: Int) async throws -> [DailyForecast]
}

extension WeatherService {
    /// Convenience that geocodes the city, then fetches current weather and
    /// the daily forecast in parallel.
    func weatherReport(forCity city: String, forecastDays: Int = 7) async throws -> WeatherReport {
        let location = try await geocode(city: city)
        async let current = currentWeather(latitude: location.latitude, longitude: location.longitude)
        async let daily = dailyForecast(latitude: location.latitude, longitude: location.longitude, days: forecastDays)
        return try await WeatherReport(location: location, current: current, daily: daily)
    }
}

/// A `WeatherService` backed by the free Open-Meteo APIs.
struct OpenMeteoWeatherService: WeatherService {
    private let session: URLSession
    private let decoder: JSONDecoder

    private static let geocodingBaseURL = "https://geocoding-api.open-meteo.com/v1/search"
    private static let forecastBaseURL = "https://api.open-meteo.com/v1/forecast"

    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }

    // MARK: - WeatherService

    func geocode(city: String) async throws -> Location {
        let trimmed = city.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw WeatherServiceError.emptyCityName }

        let url = try makeURL(base: Self.geocodingBaseURL, queryItems: [
            URLQueryItem(name: "name", value: trimmed),
            URLQueryItem(name: "count", value: "1"),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "format", value: "json"),
        ])

        let response: GeocodingResponse = try await fetch(url)
        guard let result = response.results?.first else {
            throw WeatherServiceError.cityNotFound(trimmed)
        }

        return Location(
            name: result.name,
            country: result.country,
            admin1: result.admin1,
            latitude: result.latitude,
            longitude: result.longitude
        )
    }

    func currentWeather(latitude: Double, longitude: Double) async throws -> CurrentWeather {
        let url = try makeURL(base: Self.forecastBaseURL, queryItems: [
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(name: "current", value: "temperature_2m,weather_code"),
            URLQueryItem(name: "timezone", value: "auto"),
        ])

        let response: ForecastResponse = try await fetch(url)

        return CurrentWeather(
            temperature: response.current.temperature2m,
            temperatureUnit: response.currentUnits?.temperature2m ?? "°C",
            weatherCode: WeatherCode(rawValue: response.current.weatherCode),
            observedAt: Self.parseTimestamp(response.current.time)
        )
    }

    func dailyForecast(latitude: Double, longitude: Double, days: Int) async throws -> [DailyForecast] {
        let url = try makeURL(base: Self.forecastBaseURL, queryItems: [
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(name: "daily", value: "weather_code,temperature_2m_max,temperature_2m_min"),
            URLQueryItem(name: "forecast_days", value: String(days)),
            URLQueryItem(name: "timezone", value: "auto"),
        ])

        let response: DailyForecastResponse = try await fetch(url)
        let daily = response.daily
        let unit = TemperatureUnit(apiUnit: response.dailyUnits?.temperature2mMax ?? "°C").unit

        // The API returns parallel arrays; zip them into one value per day,
        // skipping any day with a missing value or an unparseable date.
        let count = min(daily.time.count, daily.weatherCode.count,
                        daily.temperature2mMax.count, daily.temperature2mMin.count)
        return (0..<count).compactMap { index in
            guard let date = Self.parseDay(daily.time[index]),
                  let code = daily.weatherCode[index],
                  let high = daily.temperature2mMax[index],
                  let low = daily.temperature2mMin[index]
            else { return nil }

            return DailyForecast(
                date: date,
                weatherCode: WeatherCode(rawValue: code),
                high: Measurement(value: high, unit: unit),
                low: Measurement(value: low, unit: unit)
            )
        }
    }

    // MARK: - Networking helpers

    private func makeURL(base: String, queryItems: [URLQueryItem]) throws -> URL {
        guard var components = URLComponents(string: base) else {
            throw WeatherServiceError.invalidURL
        }
        components.queryItems = queryItems
        guard let url = components.url else {
            throw WeatherServiceError.invalidURL
        }
        return url
    }

    private func fetch<T: Decodable>(_ url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)

        if let httpResponse = response as? HTTPURLResponse,
           !(200..<300).contains(httpResponse.statusCode) {
            throw WeatherServiceError.badServerResponse(statusCode: httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw WeatherServiceError.decodingFailed
        }
    }

    /// Open-Meteo returns local times like "2026-09-25T14:30" without a zone offset.
    private static func parseTimestamp(_ value: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        return formatter.date(from: value)
    }

    /// Daily entries are plain dates like "2026-09-25", already in the city's local calendar.
    /// Parsing at local midnight keeps the weekday correct when formatted on the device.
    private static func parseDay(_ value: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: value)
    }
}

// MARK: - Open-Meteo response payloads

/// Response shape for `geocoding-api.open-meteo.com/v1/search`.
private struct GeocodingResponse: Decodable {
    struct Result: Decodable {
        let name: String
        let latitude: Double
        let longitude: Double
        let country: String?
        let admin1: String?
    }

    let results: [Result]?
}

/// Response shape for `api.open-meteo.com/v1/forecast` with `current=temperature_2m,weather_code`.
private struct ForecastResponse: Decodable {
    struct Current: Decodable {
        let time: String
        let temperature2m: Double
        let weatherCode: Int

        enum CodingKeys: String, CodingKey {
            case time
            case temperature2m = "temperature_2m"
            case weatherCode = "weather_code"
        }
    }

    struct CurrentUnits: Decodable {
        let temperature2m: String?

        enum CodingKeys: String, CodingKey {
            case temperature2m = "temperature_2m"
        }
    }

    let current: Current
    let currentUnits: CurrentUnits?

    enum CodingKeys: String, CodingKey {
        case current
        case currentUnits = "current_units"
    }
}

/// Response shape for `api.open-meteo.com/v1/forecast` with
/// `daily=weather_code,temperature_2m_max,temperature_2m_min`.
/// Values are optional because Open-Meteo can return `null` for individual days.
private struct DailyForecastResponse: Decodable {
    struct Daily: Decodable {
        let time: [String]
        let weatherCode: [Int?]
        let temperature2mMax: [Double?]
        let temperature2mMin: [Double?]

        enum CodingKeys: String, CodingKey {
            case time
            case weatherCode = "weather_code"
            case temperature2mMax = "temperature_2m_max"
            case temperature2mMin = "temperature_2m_min"
        }
    }

    struct DailyUnits: Decodable {
        let temperature2mMax: String?

        enum CodingKeys: String, CodingKey {
            case temperature2mMax = "temperature_2m_max"
        }
    }

    let daily: Daily
    let dailyUnits: DailyUnits?

    enum CodingKeys: String, CodingKey {
        case daily
        case dailyUnits = "daily_units"
    }
}
