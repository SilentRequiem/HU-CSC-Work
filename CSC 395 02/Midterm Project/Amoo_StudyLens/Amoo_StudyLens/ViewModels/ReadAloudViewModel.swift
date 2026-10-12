import Foundation
import Observation

/// Drives Listen / Read Aloud: picks one of the existing saved notes and plays it through
/// `SpeechSynthesisService`. Notes are read straight from `NotesViewModel`, never copied.
@MainActor
@Observable
final class ReadAloudViewModel {
    var selectedNoteID: StudyNote.ID?
    /// Speech rate for AVSpeechUtterance; applied the next time Play is tapped.
    var rate: Float = SpeechSynthesisService.defaultRate

    @ObservationIgnored
    let synthesizer: SpeechSynthesisService

    init(synthesizer: SpeechSynthesisService) {
        self.synthesizer = synthesizer
    }

    var isSpeaking: Bool { synthesizer.isSpeaking }
    var isPaused: Bool { synthesizer.isPaused }

    /// Resolves the selection against the live note list so deleted notes aren't played.
    func selectedNote(in notes: [StudyNote]) -> StudyNote? {
        notes.first { $0.id == selectedNoteID }
    }

    /// Picks the newest note if nothing (or a deleted note) is selected.
    func ensureSelection(in notes: [StudyNote]) {
        if selectedNote(in: notes) == nil {
            selectedNoteID = notes.first?.id
        }
    }

    func play(_ note: StudyNote) {
        synthesizer.speak(.note(note), rate: rate)
    }

    func togglePause() {
        synthesizer.togglePause()
    }

    func stop() {
        synthesizer.stop()
    }

    /// Stops playback when a different note is picked so the screen never shows one note
    /// while reading another.
    func selectionChanged() {
        if isSpeaking { stop() }
    }
}
