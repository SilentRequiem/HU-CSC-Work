import SwiftUI

/// The main weather screen: a city field, a button, and the current conditions,
/// drawn over a background that reflects the weather.
struct ContentView: View {
    @State private var viewModel = WeatherViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    searchSection
                    resultSection
                }
                .padding()
            }
            .scrollDismissesKeyboard(.interactively)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                WeatherBackgroundView(condition: viewModel.backgroundCondition)
                    .ignoresSafeArea()
            }
            .navigationTitle("Weather")
        }
        // The backgrounds are all mid-to-dark, so light text and dark-variant
        // glass keep everything readable regardless of condition.
        .preferredColorScheme(.dark)
    }

    // MARK: - Subviews

    private var searchSection: some View {
        VStack(spacing: 12) {
            TextField("City name", text: $viewModel.cityName)
                .textFieldStyle(.plain)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .submitLabel(.search)
                .onSubmit { fetchWeather() }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .glassEffect(in: .rect(cornerRadius: 12))

            Button("Get Weather") { fetchWeather() }
                .buttonStyle(.glassProminent)
                .disabled(!viewModel.canFetch)
        }
    }

    @ViewBuilder
    private var resultSection: some View {
        switch viewModel.state {
        case .idle:
            Text("Enter a city to see the current weather.")
                .foregroundStyle(.white.opacity(0.85))
                .padding()
                .glassEffect(in: .rect(cornerRadius: 16))

        case .loading:
            ProgressView("Loading…")
                .tint(.white)
                .foregroundStyle(.white)
                .padding()
                .glassEffect(in: .rect(cornerRadius: 16))

        case .loaded(let report):
            VStack(spacing: 16) {
                WeatherSummaryView(
                    report: report,
                    unit: viewModel.temperatureUnit,
                    onToggleUnit: { toggleUnit() }
                )

                if !report.daily.isEmpty {
                    DailyForecastView(days: report.daily, unit: viewModel.temperatureUnit)
                }
            }

        case .failed(let message):
            Label(message, systemImage: "exclamationmark.triangle.fill")
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)
                .padding()
                .glassEffect(.regular.tint(.red.opacity(0.55)), in: .rect(cornerRadius: 16))
        }
    }

    // MARK: - Actions

    private func fetchWeather() {
        Task { await viewModel.fetchWeather() }
    }

    private func toggleUnit() {
        withAnimation(.snappy) {
            viewModel.toggleTemperatureUnit()
        }
    }
}

/// Displays a single weather report: condition icon, temperature, and description.
struct WeatherSummaryView: View {
    let report: WeatherReport
    let unit: TemperatureUnit
    let onToggleUnit: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Text(report.location.displayName)
                .font(.title2)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            Image(systemName: report.current.weatherCode.symbolName)
                .font(.system(size: 96))
                .symbolRenderingMode(.multicolor)
                .padding(.vertical, 8)
                .shadow(color: .black.opacity(0.25), radius: 6, y: 3)
                .accessibilityHidden(true)

            temperatureButton

            Text(report.current.weatherCode.description)
                .font(.headline)
                .foregroundStyle(.white.opacity(0.85))

            if let observedAt = report.current.observedAt {
                Text("Updated \(observedAt.formatted(date: .omitted, time: .shortened))")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .glassEffect(in: .rect(cornerRadius: 20))
    }

    /// The temperature reading. Tapping it switches between Celsius and Fahrenheit.
    private var temperatureButton: some View {
        Button {
            onToggleUnit()
        } label: {
            Text(report.current.formattedTemperature(in: unit))
                .font(.system(size: 64, weight: .thin))
                .foregroundStyle(.white)
                .contentTransition(.numericText())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Temperature \(report.current.formattedTemperature(in: unit)), \(unit.spokenName)")
        .accessibilityHint("Switches to \(unit.toggled.spokenName)")
    }
}

#Preview {
    ContentView()
}

#Preview("Summary") {
    @Previewable @State var unit: TemperatureUnit = .celsius

    WeatherSummaryView(
        report: WeatherReport(
            location: Location(name: "Paris", country: "France", admin1: "Île-de-France", latitude: 48.85, longitude: 2.35),
            current: CurrentWeather(temperature: 18, temperatureUnit: "°C", weatherCode: WeatherCode(rawValue: 2), observedAt: .now)
        ),
        unit: unit,
        onToggleUnit: { unit = unit.toggled }
    )
    .padding()
    .background { WeatherBackgroundView(condition: .partlyCloudy).ignoresSafeArea() }
    .preferredColorScheme(.dark)
}
