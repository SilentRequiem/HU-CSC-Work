import Foundation
import AVFoundation
import Observation
import Speech

/// Live transcription updates delivered to whoever started recording.
enum SpeechRecognitionEvent {
    /// The best transcription so far; replaces any earlier partial text.
    case partial(String)
    /// Recognition finished with this final transcription.
    case final(String)
    /// Recognition stopped because of a problem the user should see.
    case failed(SpeechRecognitionError)
}

/// Speech and microphone problems, already phrased for the user.
nonisolated enum SpeechRecognitionError: LocalizedError, Equatable {
    case microphoneDenied
    case speechRecognitionDenied
    case speechRecognitionRestricted
    case recognizerUnavailable
    case microphoneUnavailable
    case noSpeechDetected
    case recognitionFailed

    var errorDescription: String? {
        switch self {
        case .microphoneDenied:
            #if os(macOS)
            "StudyLens doesn't have microphone access. Turn it on in System Settings › Privacy & Security › Microphone."
            #else
            "StudyLens doesn't have microphone access. Turn it on in Settings › Privacy & Security › Microphone."
            #endif
        case .speechRecognitionDenied:
            #if os(macOS)
            "StudyLens doesn't have speech recognition access. Turn it on in System Settings › Privacy & Security › Speech Recognition."
            #else
            "StudyLens doesn't have speech recognition access. Turn it on in Settings › Privacy & Security › Speech Recognition."
            #endif
        case .speechRecognitionRestricted:
            "Speech recognition is restricted on this device, so voice features can't be used."
        case .recognizerUnavailable:
            "Speech recognition isn't available right now. Check your internet connection or try again in a moment."
        case .microphoneUnavailable:
            "No microphone is available. Connect a microphone, or try on a device with one."
        case .noSpeechDetected:
            "StudyLens didn't hear any speech. Move closer to the microphone and try again."
        case .recognitionFailed:
            "Speech recognition stopped unexpectedly. Please try recording again."
        }
    }
}

/// Lets the audio-thread tap hold the recognition request. Apple designed
/// `SFSpeechAudioBufferRecognitionRequest.append(_:)` to be fed straight from an audio tap,
/// and the request is only appended to (never mutated elsewhere) while the tap is installed.
nonisolated final class RecognitionAudioSink: @unchecked Sendable {
    let request: SFSpeechAudioBufferRecognitionRequest

    init(request: SFSpeechAudioBufferRecognitionRequest) {
        self.request = request
    }
}

/// Owns all microphone + Speech framework work for StudyLens: permissions, the
/// `AVAudioEngine` microphone tap, and the `SFSpeechRecognizer` task that turns audio into text.
/// Dictate Note and Quiz Me both use this service; neither talks to Speech directly.
@MainActor
@Observable
final class SpeechRecognitionService {
    private(set) var isRecording = false

    /// Speech framework: the recognizer for the user's language (falls back to U.S. English).
    @ObservationIgnored
    private let recognizer = SFSpeechRecognizer(locale: .current) ?? SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    /// AVFoundation: captures live microphone audio.
    @ObservationIgnored
    private let audioEngine = AVAudioEngine()
    @ObservationIgnored
    private var request: SFSpeechAudioBufferRecognitionRequest?
    @ObservationIgnored
    private var task: SFSpeechRecognitionTask?
    @ObservationIgnored
    private var onEvent: ((SpeechRecognitionEvent) -> Void)?
    /// The latest text heard, used to decide whether "no speech" errors matter.
    @ObservationIgnored
    private var latestTranscript = ""
    /// True after the user taps Stop, so the cancellation errors that follow are ignored.
    @ObservationIgnored
    private var isStopping = false
    /// Increments for each recording so stale callbacks can be recognized and dropped.
    @ObservationIgnored
    private var sessionID = 0

    // MARK: - Permissions

    /// Asks for speech-recognition and microphone permission (only prompts the first time).
    func requestPermissions() async throws {
        switch await Self.requestSpeechAuthorization() {
        case .authorized: break
        case .denied: throw SpeechRecognitionError.speechRecognitionDenied
        case .restricted: throw SpeechRecognitionError.speechRecognitionRestricted
        default: throw SpeechRecognitionError.speechRecognitionDenied
        }

        guard await Self.requestMicrophonePermission() else {
            throw SpeechRecognitionError.microphoneDenied
        }
    }

    /// The authorization callback runs on a background queue, so it's bridged from a
    /// nonisolated context instead of a main-actor closure.
    private nonisolated static func requestSpeechAuthorization() async -> SFSpeechRecognizerAuthorizationStatus {
        await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status)
            }
        }
    }

    private nonisolated static func requestMicrophonePermission() async -> Bool {
        await withCheckedContinuation { continuation in
            AVAudioApplication.requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
    }

    // MARK: - Recording

    /// Requests permission if needed, then starts streaming microphone audio into the recognizer.
    /// `onEvent` receives the live transcript on the main actor until recording stops.
    func startRecording(onEvent: @escaping (SpeechRecognitionEvent) -> Void) async throws {
        guard !isRecording else { return }
        try await requestPermissions()

        guard let recognizer, recognizer.isAvailable else {
            throw SpeechRecognitionError.recognizerUnavailable
        }

        resetRecognition()
        #if os(iOS) || os(visionOS)
        try configureAudioSession()
        #endif

        // MICROPHONE → BUFFERS: the input node is the device microphone. Its hardware
        // format reports 0 Hz / 0 channels when no microphone exists (common in Simulator).
        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        guard format.sampleRate > 0, format.channelCount > 0 else {
            deactivateAudioSession()
            throw SpeechRecognitionError.microphoneUnavailable
        }

        // BUFFERS → SPEECH: a buffer request accepts audio as it arrives and reports
        // partial results, which is what makes the transcript appear while the user talks.
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        request.addsPunctuation = true
        request.taskHint = .dictation
        // Keep audio on the device when the language supports it.
        if recognizer.supportsOnDeviceRecognition {
            request.requiresOnDeviceRecognition = true
        }
        self.request = request
        self.onEvent = onEvent

        audioEngine.prepare()
        do {
            // iOS/macOS 27 tap API: the closure is @Sendable and receives read-only buffers.
            try inputNode.installAudioTap(onBus: 0, bufferSize: 1024, format: format,
                                          tapProvider: Self.makeTapProvider(for: RecognitionAudioSink(request: request)))
            try audioEngine.start()
        } catch {
            inputNode.removeTap(onBus: 0)
            resetRecognition()
            deactivateAudioSession()
            throw SpeechRecognitionError.microphoneUnavailable
        }

        sessionID += 1
        task = recognizer.recognitionTask(with: request, resultHandler: makeResultHandler(session: sessionID))
        isRecording = true
    }

    /// Stops listening. The recognizer still delivers a final result for audio already captured.
    func stopRecording() {
        guard isRecording else { return }
        isStopping = true
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        request?.endAudio()
        isRecording = false
        deactivateAudioSession()
    }

    /// Stops immediately and discards any pending result (used when leaving the screen).
    func cancel() {
        stopRecording()
        resetRecognition()
    }

    // MARK: - Callbacks

    /// The tap runs on a real-time audio thread, so the closure is built in a nonisolated
    /// context; it only copies each microphone buffer into the recognition request.
    private nonisolated static func makeTapProvider(for sink: RecognitionAudioSink) -> @Sendable (AVReadOnlyAudioPCMBuffer, AVAudioTime) -> Void {
        { buffer, _ in
            sink.request.append(AVAudioPCMBuffer(copying: buffer))
        }
    }

    /// Speech calls the result handler on a background queue; it hops to the main actor
    /// before touching any state.
    private nonisolated func makeResultHandler(session: Int) -> (SFSpeechRecognitionResult?, Error?) -> Void {
        { [weak self] result, error in
            let text = result?.bestTranscription.formattedString
            let isFinal = result?.isFinal ?? false
            let failure = error.map(Self.classify)
            Task { @MainActor [weak self] in
                self?.handle(text: text, isFinal: isFinal, failure: failure, session: session)
            }
        }
    }

    private func handle(text: String?, isFinal: Bool, failure: RecognitionFailure?, session: Int) {
        // Ignore late callbacks from a recording that has already been replaced or cancelled.
        guard session == sessionID, onEvent != nil else { return }

        if let text {
            latestTranscript = text
            onEvent?(isFinal ? .final(text) : .partial(text))
        }

        if let failure {
            switch failure {
            case .cancelled:
                break
            case .noSpeech:
                // Only worth reporting if nothing at all was heard.
                if latestTranscript.isEmpty {
                    onEvent?(.failed(.noSpeechDetected))
                }
            case .other:
                if !isStopping || latestTranscript.isEmpty {
                    onEvent?(.failed(latestTranscript.isEmpty ? .noSpeechDetected : .recognitionFailed))
                }
            }
        }

        if isFinal || failure != nil {
            // Recognition is over (final result, error, or the ~1 minute server limit).
            if isRecording { stopRecording() }
            resetRecognition()
        }
    }

    /// Speech reports errors as `NSError`s with undocumented codes. These groupings keep
    /// raw framework errors away from the user.
    private enum RecognitionFailure: Sendable { case cancelled, noSpeech, other }

    private nonisolated static func classify(_ error: Error) -> RecognitionFailure {
        let nsError = error as NSError
        if nsError.domain == "kAFAssistantErrorDomain" {
            switch nsError.code {
            case 203, 1110: return .noSpeech          // "Retry" / "No speech detected"
            case 216, 301, 1101: return .cancelled    // Request cancelled / ended by the app
            default: return .other
            }
        }
        if nsError.domain == "kLSRErrorDomain" && nsError.code == 301 {
            return .cancelled
        }
        return .other
    }

    // MARK: - Helpers

    private func resetRecognition() {
        task?.cancel()
        task = nil
        request = nil
        onEvent = nil
        latestTranscript = ""
        isStopping = false
    }

    #if os(iOS) || os(visionOS)
    /// iOS routes audio through a shared session; `.playAndRecord` with `.defaultToSpeaker`
    /// lets Quiz Me read a question aloud right after recording without switching to the earpiece.
    private func configureAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .measurement, options: [.duckOthers, .defaultToSpeaker])
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            throw SpeechRecognitionError.microphoneUnavailable
        }
    }
    #endif

    private func deactivateAudioSession() {
        #if os(iOS) || os(visionOS)
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        #endif
    }
}
