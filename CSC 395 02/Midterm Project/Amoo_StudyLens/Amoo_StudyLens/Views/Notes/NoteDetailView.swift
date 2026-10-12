import SwiftUI

/// Shows the full contents of a captured note, with Study This Note, Edit, Export, and Delete actions.
///
/// Pushed by note *ID* (`AppNavigationModel.notesPath`) and always reads the saved version from
/// `NotesViewModel`, so an edit shows immediately and a deleted note never lingers on screen.
struct NoteDetailView: View {
    let noteID: UUID

    @Environment(NotesViewModel.self) private var notesViewModel

    var body: some View {
        if let note = notesViewModel.note(withID: noteID) {
            NoteDetailContent(note: note)
        } else {
            // Only visible for a moment: ContentView pops deleted notes off the Notes stack.
            ContentUnavailableView(
                "Note Deleted",
                systemImage: "trash",
                description: Text("This note is no longer saved on this device.")
            )
        }
    }
}

private struct NoteDetailContent: View {
    let note: StudyNote

    @Environment(NotesViewModel.self) private var notesViewModel
    @Environment(StudyViewModel.self) private var studyViewModel
    @Environment(AppNavigationModel.self) private var navigation
    @State private var pendingDeletion: PendingNoteDeletion?
    @State private var isExporting = false
    @State private var isEditing = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ViewThatFits(in: .horizontal) {
                    HStack {
                        sourceLabel
                        Spacer()
                        dateLabel
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        sourceLabel
                        dateLabel
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)

                if let info = note.importInfo {
                    Label("\(info.filename) · \(info.summary)", systemImage: info.kind.systemImage)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textSelection(.enabled)
                }

                // Notes saved from Learn More keep their Wikipedia attribution and link.
                if let external = note.externalSource {
                    VStack(alignment: .leading, spacing: 4) {
                        Label("External source: Wikipedia — “\(external.articleTitle)”", systemImage: "globe")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.teal)
                        if let url = external.url {
                            Link(destination: url) {
                                Label("Open Original Article", systemImage: "safari")
                            }
                            .font(.caption)
                            .tint(.teal)
                        }
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.teal.opacity(0.1), in: .rect(cornerRadius: 10))
                }

                if studyViewModel.guide?.sourceNoteIDs.contains(note.id) == true,
                   studyViewModel.isOutdated(for: notesViewModel.notes) {
                    Label("Your current study guide uses this note and is out of date. Regenerate it on the Study tab.",
                          systemImage: "arrow.triangle.2.circlepath")
                        .font(.footnote)
                        .foregroundStyle(Color.studyLensWarning)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Button {
                    studyThisNote()
                } label: {
                    Label("Study This Note", systemImage: "graduationcap")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.purple)
                .controlSize(.large)
                .disabled(studyViewModel.isGenerating)

                Text(note.body)
                    .font(.body)
                    .textSelection(.enabled)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
            // Comfortable reading width on a wide Mac window or iPad; full width on iPhone.
            .frame(maxWidth: 760, alignment: .leading)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle(note.title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button("Edit", systemImage: "pencil") {
                    isEditing = true
                }
                .keyboardShortcut("e", modifiers: .command)
                Button("Export", systemImage: "square.and.arrow.up") {
                    isExporting = true
                }
                Button("Delete", systemImage: "trash", role: .destructive) {
                    pendingDeletion = PendingNoteDeletion(notes: [note], isClearAll: false)
                }
            }
        }
        .noteDeletionConfirmation($pendingDeletion) { deletion in
            notesViewModel.delete(ids: deletion.ids)
            navigation.closeNote(note.id)
        }
        .sheet(isPresented: $isExporting) {
            NotesExportSheet(notes: [note])
        }
        .sheet(isPresented: $isEditing) {
            NoteEditorSheet(note: note) { edited in
                notesViewModel.update(edited)
            }
        }
    }

    private var sourceLabel: some View {
        Label(note.source.displayName, systemImage: note.source.systemImage)
    }

    private var dateLabel: some View {
        Text(note.createdAt, format: .dateTime.month().day().year())
    }

    /// Single Note study source: scope the Study workflow to just this note, show the Study tab,
    /// and generate — unless an up-to-date guide for exactly this note already exists, in which
    /// case it's reused instead of making another Foundation Models request.
    private func studyThisNote() {
        studyViewModel.scope = .singleNote(note.id)
        navigation.showStudyRoot()

        let notes = notesViewModel.notes
        let hasCurrentGuide = studyViewModel.guideMatchesScope(in: notes) && !studyViewModel.isOutdated(for: notes)
        guard !hasCurrentGuide, studyViewModel.availability == .available else { return }
        Task { await studyViewModel.generate(using: notes) }
    }
}

// MARK: - Editing

/// Edits a saved note's title and text. Nothing is written until Save; Cancel discards changes.
/// The source, date, and import / Wikipedia attribution are kept, so an edited note stays
/// identifiable. Any study guide built from the note is then marked outdated (see `StudySource`).
private struct NoteEditorSheet: View {
    let note: StudyNote
    let onSave: (StudyNote) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @State private var bodyText: String

    init(note: StudyNote, onSave: @escaping (StudyNote) -> Void) {
        self.note = note
        self.onSave = onSave
        _title = State(initialValue: note.title)
        _bodyText = State(initialValue: note.body)
    }

    private var trimmedBody: String { bodyText.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var hasChanges: Bool { title != note.title || bodyText != note.body }

    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Note title", text: $title)
                }
                Section {
                    TextEditor(text: $bodyText)
                        .frame(minHeight: 260)
                } header: {
                    Text("Text")
                } footer: {
                    Text(trimmedBody.isEmpty
                         ? "A note needs some text. Delete the note instead if you no longer need it."
                         : "Study guides made from this note will be marked out of date until you regenerate them.")
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Edit Note")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        var edited = note
                        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
                        // A blank title keeps the old one rather than saving an unnamed note.
                        edited.title = trimmedTitle.isEmpty ? note.title : trimmedTitle
                        edited.body = trimmedBody
                        onSave(edited)
                        dismiss()
                    }
                    .disabled(!hasChanges || trimmedBody.isEmpty)
                }
            }
        }
        .studyLensSheetFrame()
    }
}
