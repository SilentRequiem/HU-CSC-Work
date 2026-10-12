import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Sheet sizing

extension View {
    /// Gives Capture and editing sheets a usable size on macOS, where a sheet otherwise shrinks
    /// to its content and forms or scroll views can open tiny. No effect on iPhone or iPad.
    func studyLensSheetFrame() -> some View {
        #if os(macOS)
        frame(minWidth: 520, idealWidth: 620, minHeight: 560, idealHeight: 720)
        #else
        self
        #endif
    }

    /// Centers scrolling content at a readable width on wide Mac windows and iPad, while
    /// staying full width on iPhone.
    func readableContentWidth(_ maxWidth: CGFloat = 760) -> some View {
        frame(maxWidth: maxWidth)
            .frame(maxWidth: .infinity)
    }
}

// MARK: - Status colors

extension Color {
    /// Text color for warnings and "out of date" notices. System orange is only about 2.2:1
    /// against a light background, so Light Mode uses a darker orange (about 4.5–5:1 on StudyLens's
    /// light surfaces, WCAG AA for body text); Dark Mode keeps system orange, which already contrasts well on dark surfaces.
    /// Section headings keep their bright identity colors; this is only for status text.
    static let studyLensWarning: Color = {
        let light = (red: 0.70, green: 0.33, blue: 0.0)
        #if os(macOS)
        return Color(nsColor: NSColor(name: nil) { appearance in
            appearance.bestMatch(from: [.darkAqua, .vibrantDark, .accessibilityHighContrastDarkAqua]) != nil
                ? .systemOrange
                : NSColor(srgbRed: light.red, green: light.green, blue: light.blue, alpha: 1)
        })
        #else
        return Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? .systemOrange
                : UIColor(red: light.red, green: light.green, blue: light.blue, alpha: 1)
        })
        #endif
    }()
}

// MARK: - Open Settings

/// Opens the system settings page where the user can grant a privacy permission StudyLens needs.
/// Shown next to "permission denied" messages so the next step is one tap away.
struct OpenSettingsButton: View {
    let link: PrivacySettingsLink
    @Environment(\.openURL) private var openURL

    var body: some View {
        if let url {
            Button("Open Settings", systemImage: "gear") {
                openURL(url)
            }
            .buttonStyle(.bordered)
            .accessibilityHint(hint)
        }
    }

    private var url: URL? {
        #if os(macOS)
        // System Settings › Privacy & Security, opened at the matching pane.
        switch link {
        case .microphone: URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Microphone")
        case .speechRecognition: URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_SpeechRecognition")
        }
        #else
        // StudyLens's own page in Settings, which lists its Microphone and Speech Recognition switches.
        URL(string: UIApplication.openSettingsURLString)
        #endif
    }

    private var hint: String {
        switch link {
        case .microphone: "Opens Settings so you can allow microphone access."
        case .speechRecognition: "Opens Settings so you can allow speech recognition."
        }
    }
}

// MARK: - Status message

/// An inline status or error message with an optional next action (Retry, Try Again, …),
/// used where a feature fails so it never fails silently.
struct StatusMessageView: View {
    let message: String
    var systemImage = "exclamationmark.triangle"
    var tint: Color = .studyLensWarning
    var actionTitle: String?
    var actionSystemImage = "arrow.clockwise"
    var action: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(message, systemImage: systemImage)
                .font(.subheadline)
                .foregroundStyle(tint)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let actionTitle, let action {
                Button(actionTitle, systemImage: actionSystemImage, action: action)
                    .buttonStyle(.bordered)
            }
        }
    }
}
