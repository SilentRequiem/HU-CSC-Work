import SwiftUI

/// Notes waiting for the user to confirm deletion. Nothing is deleted until they confirm.
struct PendingNoteDeletion: Identifiable {
    let id = UUID()
    let notes: [StudyNote]
    /// True for Clear All Notes, which gets its own wording.
    let isClearAll: Bool

    var ids: Set<UUID> { Set(notes.map(\.id)) }
}

/// Notes chosen for export. Presents the export sheet when set.
struct NoteExportRequest: Identifiable {
    let id = UUID()
    let notes: [StudyNote]
}

struct NotesListView: View {
    @Environment(NotesViewModel.self) private var notesViewModel
    @Environment(StudyViewModel.self) private var studyViewModel
    @Environment(AppNavigationModel.self) private var navigation

    /// Selection mode for deleting or exporting several notes at once. A custom mode (rather
    /// than the system edit mode) behaves the same on iPhone and Mac.
    @State private var isSelecting = false
    @State private var selection: Set<UUID> = []
    @State private var pendingDeletion: PendingNoteDeletion?
    @State private var exportRequest: NoteExportRequest?

    private var selectedNotes: [StudyNote] { notesViewModel.notes(withIDs: selection) }

    var body: some View {
        NavigationStack {
            Group {
                if notesViewModel.notes.isEmpty {
                    ContentUnavailableView {
                        Label("No Notes Yet", systemImage: "note.text")
                    } description: {
                        Text("Notes you capture will appear here.")
                    }
                } else {
                    notesList
                }
            }
            .navigationTitle(isSelecting ? selectionTitle : "Notes")
            #if os(iOS)
            .navigationBarTitleDisplayMode(isSelecting ? .inline : .automatic)
            #endif
            .toolbar { toolbarContent }
            .navigationDestination(for: StudyNote.self) { note in
                NoteDetailView(note: note)
            }
            .noteDeletionConfirmation($pendingDeletion) { deletion in
                notesViewModel.delete(ids: deletion.ids)
                selection.subtract(deletion.ids)
                if notesViewModel.notes.isEmpty { isSelecting = false }
            }
            .sheet(item: $exportRequest) { request in
                NotesExportSheet(notes: request.notes)
            }
        }
    }

    // MARK: - List

    private var notesList: some View {
        List {
            if let message = notesViewModel.storageWarning ?? notesViewModel.persistenceErrorMessage {
                Label(message, systemImage: "exclamationmark.triangle")
                    .font(.footnote)
                    .foregroundStyle(.orange)
            }

            ForEach(notesViewModel.sortedNotes) { note in
                if isSelecting {
                    selectableRow(for: note)
                } else {
                    NavigationLink(value: note) {
                        NoteRow(note: note)
                    }
                    .swipeActions(edge: .trailing) {
                        // Not `role: .destructive`: the row stays until the user confirms.
                        Button("Delete", systemImage: "trash") {
                            pendingDeletion = PendingNoteDeletion(notes: [note], isClearAll: false)
                        }
                        .tint(.red)
                    }
                    .contextMenu {
                        Button("Export…", systemImage: "square.and.arrow.up") {
                            exportRequest = NoteExportRequest(notes: [note])
                        }
                        Button("Delete…", systemImage: "trash", role: .destructive) {
                            pendingDeletion = PendingNoteDeletion(notes: [note], isClearAll: false)
                        }
                    }
                }
            }
        }
    }

    private func selectableRow(for note: StudyNote) -> some View {
        let isSelected = selection.contains(note.id)
        return Button {
            if isSelected {
                selection.remove(note.id)
            } else {
                selection.insert(note.id)
            }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? AnyShapeStyle(.tint) : AnyShapeStyle(.secondary))
                NoteRow(note: note)
                Spacer(minLength: 0)
            }
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var selectionTitle: String {
        selection.isEmpty ? "Select Notes" : "\(selection.count) Selected"
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        if !notesViewModel.notes.isEmpty {
            if isSelecting {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { endSelecting() }
                }
                #if os(iOS)
                // A bottom bar keeps the nav bar uncluttered on smaller iPhones.
                ToolbarItemGroup(placement: .bottomBar) {
                    selectionActions
                }
                #else
                ToolbarItemGroup(placement: .primaryAction) {
                    selectionActions
                }
                #endif
            } else {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button("Select Notes…", systemImage: "checkmark.circle") {
                            isSelecting = true
                        }
                        Button("Export All Notes…", systemImage: "square.and.arrow.up") {
                            exportRequest = NoteExportRequest(notes: notesViewModel.sortedNotes)
                        }
                        Divider()
                        Button("Clear All Notes…", systemImage: "trash", role: .destructive) {
                            pendingDeletion = PendingNoteDeletion(notes: notesViewModel.sortedNotes, isClearAll: true)
                        }
                    } label: {
                        Label("Manage Notes", systemImage: "ellipsis.circle")
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var selectionActions: some View {
        let allSelected = selection.count == notesViewModel.notes.count
        Button(allSelected ? "Deselect All" : "Select All") {
            selection = allSelected ? [] : Set(notesViewModel.notes.map(\.id))
        }

        Spacer()

        // Selected Notes study source: hand the selection to the Study tab (nothing is generated
        // until the user taps Generate there).
        Button("Study", systemImage: "graduationcap") {
            studyViewModel.scope = .selectedNotes(selection)
            endSelecting()
            navigation.showStudyRoot()
        }
        .disabled(selection.isEmpty || studyViewModel.isGenerating)

        Button("Export", systemImage: "square.and.arrow.up") {
            exportRequest = NoteExportRequest(notes: selectedNotes)
        }
        .disabled(selection.isEmpty)

        Button("Delete", systemImage: "trash", role: .destructive) {
            pendingDeletion = PendingNoteDeletion(notes: selectedNotes, isClearAll: false)
        }
        .disabled(selection.isEmpty)
    }

    private func endSelecting() {
        isSelecting = false
        selection = []
    }
}

// MARK: - Deletion confirmation

extension View {
    /// Asks before deleting notes, and says what will happen to the study guide and Brain Map.
    /// Shared by the Notes list and the note detail screen.
    func noteDeletionConfirmation(
        _ pending: Binding<PendingNoteDeletion?>,
        onConfirm: @escaping (PendingNoteDeletion) -> Void
    ) -> some View {
        modifier(NoteDeletionConfirmation(pending: pending, onConfirm: onConfirm))
    }
}

private struct NoteDeletionConfirmation: ViewModifier {
    @Binding var pending: PendingNoteDeletion?
    let onConfirm: (PendingNoteDeletion) -> Void
    @Environment(StudyViewModel.self) private var studyViewModel

    func body(content: Content) -> some View {
        content.confirmationDialog(
            title,
            isPresented: Binding(
                get: { pending != nil },
                set: { if !$0 { pending = nil } }
            ),
            titleVisibility: .visible,
            presenting: pending
        ) { deletion in
            Button(confirmTitle(for: deletion), role: .destructive) {
                onConfirm(deletion)
            }
            Button("Cancel", role: .cancel) {}
        } message: { deletion in
            Text(message(for: deletion))
        }
    }

    private var title: String {
        guard let pending else { return "" }
        if pending.isClearAll { return "Clear All Notes?" }
        if pending.notes.count == 1, let note = pending.notes.first { return "Delete “\(note.title)”?" }
        return "Delete \(pending.notes.count) Notes?"
    }

    private func confirmTitle(for deletion: PendingNoteDeletion) -> String {
        if deletion.isClearAll { return "Delete All \(deletion.notes.count) Notes" }
        return deletion.notes.count == 1 ? "Delete Note" : "Delete \(deletion.notes.count) Notes"
    }

    private func message(for deletion: PendingNoteDeletion) -> String {
        let count = deletion.notes.count
        let what = deletion.isClearAll
            ? "This permanently deletes all \(count) saved \(count == 1 ? "note" : "notes") from this device."
            : "This permanently deletes \(count == 1 ? "this note" : "these \(count) notes") from this device."

        let impact: String
        switch studyViewModel.deletionImpact(ofDeleting: deletion.ids) {
        case .none:
            impact = ""
        case .outdated:
            impact = " Your study guide and Brain Map will be kept but marked out of date until you regenerate them."
        case .removed:
            impact = " Your study guide, its Quiz Me questions, and the Brain Map were built from \(count == 1 ? "this note" : "these notes"), so they'll be cleared too. Export them first if you want to keep them."
        }
        return what + impact + " This can't be undone."
    }
}

// MARK: - Export

/// The export sheet configured for notes: Markdown or Plain Text, one note or many.
struct NotesExportSheet: View {
    let notes: [StudyNote]

    var body: some View {
        ExportSheet(
            title: notes.count == 1 ? "Export Note" : "Export \(notes.count) Notes",
            message: notes.count == 1
                ? "Share or save this note as a text file."
                : "Share or save these notes as one file, with a heading for each note.",
            formats: NoteExportFormat.allCases,
            initialFormat: .markdown
        ) { format in
            try NoteExporter.makeArtifact(for: notes, format: format)
        }
    }
}

// MARK: - Row

/// A single row in the notes list.
private struct NoteRow: View {
    let note: StudyNote

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: note.source.systemImage)
                .foregroundStyle(.tint)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(note.title)
                    .font(.headline)
                    .lineLimit(1)
                Group {
                    if let info = note.importInfo {
                        Text("\(note.createdAt.formatted(.dateTime.month().day().hour().minute())) · \(info.filename)")
                    } else if note.source == .wikipedia {
                        Text("\(note.createdAt.formatted(.dateTime.month().day().hour().minute())) · From Wikipedia")
                    } else {
                        Text(note.createdAt, format: .dateTime.month().day().hour().minute())
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NotesListView()
        .environment(NotesViewModel(store: InMemoryNoteStore(notes: [
            StudyNote(title: "Photosynthesis", body: "Plants turn light into chemical energy.", source: .scan),
            StudyNote(title: "Cell parts", body: "Mitochondria make ATP.", source: .handwriting),
            StudyNote(title: "Lecture recap", body: "DNA stores genetic information.", source: .voice)
        ])))
        .environment(StudyViewModel())
        .environment(AppNavigationModel())
}
