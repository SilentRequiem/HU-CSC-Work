import Foundation
import Observation

/// Drives the weather screen: holds the user's input, the loading state,
/// and the most recent result or error.
@Observable
@MainActor
final class WeatherViewModel {
    /// The different states the weather screen can be in.
    enum LoadState: Equatable {
        case idle
        case loading
        case loaded(WeatherReport)
        case failed(String)
    }

    /// The city name typed by the user.
    var cityName = ""

    /// The scale used to display temperatures. Persists across searches.
    var temperatureUnit: TemperatureUnit = .celsius

    /// The current state of the lookup.
    private(set) var state: LoadState = .idle

    /// The condition driving the background. Stays on the last successful
    /// result while a new lookup is loading, and clears when a lookup fails.
    private(set) var backgroundCondition: WeatherCondition?

    private let service: any WeatherService

    /// - Parameter service: The data source to use. Pass `nil` to use Open-Meteo,
    ///   or supply a mock in previews or tests.
    init(service: (any WeatherService)? = nil) {
        self.service = service ?? OpenMeteoWeatherService()
    }

    /// Whether the "Get Weather" button should be enabled.
    var canFetch: Bool {
        !cityName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && state != .loading
    }

    /// Looks up the weather for the current `cityName`.
    func fetchWeather() async {
        guard canFetch else { return }
        state = .loading

        do {
            let report = try await service.weatherReport(forCity: cityName)
            state = .loaded(report)
            backgroundCondition = report.current.weatherCode.condition
        } catch {
            state = .failed(error.localizedDescription)
            backgroundCondition = nil
        }
    }

    /// Switches between Celsius and Fahrenheit.
    func toggleTemperatureUnit() {
        temperatureUnit = temperatureUnit.toggled
    }
}
