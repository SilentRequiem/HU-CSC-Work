import Foundation
import Observation

/// Drives Dictate Note: records the microphone through `SpeechRecognitionService`,
/// keeps an editable transcript and title, and builds the `.voice` `StudyNote` to save.
@MainActor
@Observable
final class DictateNoteViewModel {
    /// Editable transcript. While recording, live speech is appended after `textBeforeRecording`.
    var transcript = "" {
        didSet { updateDefaultTitle() }
    }
    /// Editable note title. Follows the transcript until the user types their own.
    var title = ""

    private(set) var errorMessage: String?
    /// The speech error behind `errorMessage`, so the screen can offer Open Settings when it's a permission.
    private(set) var speechError: SpeechRecognitionError?
    private(set) var isStarting = false

    @ObservationIgnored
    private let recognizer: SpeechRecognitionService
    /// Text that existed before the current recording, so the user can dictate in several takes.
    @ObservationIgnored
    private var textBeforeRecording = ""
    /// The last title StudyLens generated; if `title` still equals it, the user hasn't edited it.
    @ObservationIgnored
    private var lastGeneratedTitle = ""

    init(recognizer: SpeechRecognitionService) {
        self.recognizer = recognizer
    }

    var isRecording: Bool { recognizer.isRecording }

    private var trimmedTranscript: String {
        transcript.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Blank transcripts are never saved.
    var canSave: Bool {
        !isRecording && !isStarting && trimmedTranscript.contains { $0.isLetter || $0.isNumber }
    }

    // MARK: - Recording

    func toggleRecording() {
        isRecording ? stopRecording() : startRecording()
    }

    func startRecording() {
        guard !isRecording, !isStarting else { return }
        showError(nil)
        isStarting = true
        textBeforeRecording = trimmedTranscript

        Task {
            defer { isStarting = false }
            do {
                // MICROPHONE → TEXT: each event carries the best transcription so far
                // for this take, which replaces the previous partial text on screen.
                // The service releases this closure when recording ends, so a strong capture is safe.
                try await recognizer.startRecording { event in
                    self.handle(event)
                }
            } catch {
                showError(error)
            }
        }
    }

    /// Publishes an error (or clears it with nil), keeping the typed speech error when there is one.
    private func showError(_ error: Error?) {
        errorMessage = error?.localizedDescription
        speechError = error as? SpeechRecognitionError
    }

    func stopRecording() {
        recognizer.stopRecording()
    }

    /// Stops the microphone and drops pending results (used when leaving Dictate mode).
    func cancelRecording() {
        recognizer.cancel()
    }

    private func handle(_ event: SpeechRecognitionEvent) {
        switch event {
        case .partial(let text), .final(let text):
            transcript = textBeforeRecording.isEmpty ? text : "\(textBeforeRecording) \(text)"
        case .failed(let error):
            showError(error)
        }
    }

    func clearTranscript() {
        recognizer.cancel()
        transcript = ""
        title = ""
        lastGeneratedTitle = ""
        showError(nil)
    }

    // MARK: - Title

    /// Keeps the default title in sync with the transcript unless the user has typed a title.
    private func updateDefaultTitle() {
        guard title.isEmpty || title == lastGeneratedTitle else { return }
        let generated = trimmedTranscript.isEmpty ? "" : Self.generateTitle(from: trimmedTranscript)
        lastGeneratedTitle = generated
        title = generated
    }

    /// Builds a title from the first meaningful sentence of the dictation, skipping filler
    /// words like "um" or "okay so", then reuses the Scan screen's word-boundary truncation.
    static func generateTitle(from transcript: String) -> String {
        let firstSentence = transcript
            .split(whereSeparator: { ".?!\n".contains($0) })
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .first { $0.filter(\.isLetter).count >= 3 } ?? ""

        var words = firstSentence.split(separator: " ").map(String.init)
        while let first = words.first,
              fillerWords.contains(first.lowercased().trimmingCharacters(in: .punctuationCharacters)) {
            words.removeFirst()
        }

        var sentence = words.joined(separator: " ")
        if let firstCharacter = sentence.first {
            sentence = firstCharacter.uppercased() + sentence.dropFirst()
        }
        return ScanNoteViewModel.generateTitle(from: sentence, fallbackPrefix: "Voice Note")
    }

    private static let fillerWords: Set<String> = [
        "um", "uh", "uhm", "er", "ah", "so", "okay", "ok", "well", "like", "alright", "right", "hey", "and"
    ]

    // MARK: - Saving

    /// SAVE AS .voice: builds the note handed to the shared `NotesViewModel`, the same
    /// path Scan Image and Write Note use, so it shows up in Notes and the Study Guide.
    func makeNote() -> StudyNote {
        let body = trimmedTranscript
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        return StudyNote(
            title: trimmedTitle.isEmpty ? Self.generateTitle(from: body) : trimmedTitle,
            body: body,
            source: .voice
        )
    }
}
