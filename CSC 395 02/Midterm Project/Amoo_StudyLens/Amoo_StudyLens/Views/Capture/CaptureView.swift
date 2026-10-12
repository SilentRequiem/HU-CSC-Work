import SwiftUI

/// The capture methods offered on the Capture tab.
enum CaptureOption: String, CaseIterable, Identifiable {
    case scanImage
    case speakNote
    case writeNote
    case importFile

    var id: String { rawValue }

    var title: String {
        switch self {
        case .scanImage: "Scan Image"
        case .speakNote: "Speak Note"
        case .writeNote: "Write Note"
        case .importFile: "Import File"
        }
    }

    var subtitle: String {
        switch self {
        case .scanImage: "Extract text from a photo of printed notes or slides"
        case .speakNote: "Dictate a note, hear notes read aloud, or quiz yourself out loud"
        case .writeNote: "Handwrite notes with Apple Pencil"
        case .importFile: "Bring in PDFs, Word, PowerPoint, Excel, CSV, text files, or images"
        }
    }

    var systemImage: String {
        switch self {
        case .scanImage: "doc.viewfinder"
        case .speakNote: "mic.fill"
        case .writeNote: "pencil.and.scribble"
        case .importFile: "square.and.arrow.down.on.square"
        }
    }

    var tint: Color {
        switch self {
        case .scanImage: .blue
        case .speakNote: .orange
        case .writeNote: .purple
        case .importFile: .teal
        }
    }
}

struct CaptureView: View {
    /// Owns which Capture sheet is open. Only the explicit taps below (or a file drop, which opens
    /// Import File) write `activeCapture`, so no other screen can open Speak Note by accident.
    @Environment(AppNavigationModel.self) private var navigation
    @State private var isDropTargeted = false

    var body: some View {
        @Bindable var navigation = navigation

        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Add study material from paper, your voice, your own handwriting, or files you already have.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    ForEach(CaptureOption.allCases) { option in
                        Button {
                            navigation.presentCapture(option)
                        } label: {
                            CaptureOptionCard(option: option)
                        }
                        .buttonStyle(.plain)
                    }

                    // A visible drop target; the whole screen also accepts drops (see below).
                    FileDropZone(isTargeted: isDropTargeted, chooseTitle: "Import File…") {
                        navigation.presentCapture(.importFile)
                    }
                    .padding(.top, 4)
                }
                .padding()
            }
            .navigationTitle("Capture")
            // DRAG AND DROP: dropping anywhere on the Capture screen starts the same import pipeline
            // as the Import File button; unsupported files are explained on the Import File sheet.
            .studyFileDropDestination(isTargeted: $isDropTargeted) { url in
                navigation.beginImport(of: url)
            }
            .sheet(item: $navigation.activeCapture) { option in
                switch option {
                case .scanImage:
                    ScanNoteView()
                case .writeNote:
                    HandwritingNoteView()
                case .speakNote:
                    SpeakNoteView()
                case .importFile:
                    ImportFileView()
                }
            }
        }
    }
}

#Preview {
    CaptureView()
        .environment(NotesViewModel())
        .environment(StudyViewModel())
        .environment(AppNavigationModel())
}
