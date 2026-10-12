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
    /// Search, source filter, and sort. Display-only: it never changes what's saved.
    @State private var query = NoteListQuery()

    /// The notes currently shown, after search, filter, and sort.
    private var visibleNotes: [StudyNote] { query.apply(to: notesViewModel.notes) }
    private var selectedNotes: [StudyNote] { notesViewModel.notes(withIDs: selection) }

    var body: some View {
        @Bindable var navigation = navigation

        NavigationStack(path: $navigation.notesPath) {
            Group {
                if notesViewModel.notes.isEmpty {
                    noNotesState
                } else {
                    notesList
                        .searchable(text: $query.searchText, prompt: "Search titles and text")
                }
            }
            .navigationTitle(isSelecting ? selectionTitle : "Notes")
            #if os(iOS)
            .navigationBarTitleDisplayMode(isSelecting ? .inline : .automatic)
            #endif
            .toolbar { toolbarContent }
            .navigationDestination(for: UUID.self) { id in
                NoteDetailView(noteID: id)
            }
            .noteDeletionConfirmation($pendingDeletion) { deletion in
                notesViewModel.delete(ids: deletion.ids)
                selection.subtract(deletion.ids)
                if notesViewModel.notes.isEmpty { isSelecting = false }
            }
            .sheet(item: $exportRequest) { request in
                NotesExportSheet(notes: request.notes)
            }
            // Selection only ever covers notes the user can see, so Delete / Export / Study never
            // act on a note hidden by search or a filter.
            .onChange(of: query) {
                selection.formIntersection(visibleNotes.map(\.id))
            }
        }
    }

    // MARK: - Empty states

    private var noNotesState: some View {
        ContentUnavailableView {
            Label("No Notes Yet", systemImage: "note.text")
        } description: {
            Text("Scan, write, dictate, or import study material on the Capture tab. Saved notes appear here.")
        } actions: {
            Button("Capture a Note", systemImage: "camera.viewfinder") {
                navigation.show(.capture)
            }
            .buttonStyle(.borderedProminent)
            Button("Import File…", systemImage: "square.and.arrow.down.on.square") {
                navigation.beginCapture(.importFile)
            }
            .buttonStyle(.bordered)
        }
    }

    /// Search or filters matched nothing; the notes still exist, so say how to get them back.
    private var noMatchesState: some View {
        ContentUnavailableView {
            Label("No Matching Notes", systemImage: "magnifyingglass")
        } description: {
            Text(noMatchesMessage)
        } actions: {
            Button("Show All Notes") { clearFilters() }
                .buttonStyle(.bordered)
        }
    }

    private var noMatchesMessage: String {
        let search = query.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let sources = query.sources.map(\.displayName).sorted().formatted(.list(type: .or))
        switch (search.isEmpty, query.sources.isEmpty) {
        case (false, true): return "No note titles or text contain “\(search)”."
        case (true, false): return "You don't have any \(sources) notes."
        default: return "No \(sources) notes contain “\(search)”."
        }
    }

    private func clearFilters() {
        query.searchText = ""
        query.sources = []
    }

    // MARK: - List

    private var notesList: some View {
        let visible = visibleNotes
        return List {
            if let message = notesViewModel.storageWarning ?? notesViewModel.persistenceErrorMessage {
                Label(message, systemImage: "exclamationmark.triangle")
                    .font(.footnote)
                    .foregroundStyle(Color.studyLensWarning)
            }

            Section {
                ForEach(visible) { note in
                    row(for: note)
                }
            } header: {
                listHeader(shown: visible.count)
            }
        }
        .overlay {
            if visible.isEmpty {
                noMatchesState
            }
        }
    }

    /// The note count, plus a quick way out of an active filter.
    private func listHeader(shown: Int) -> some View {
        HStack {
            Text(query.countDescription(shown: shown, total: notesViewModel.notes.count))
                .contentTransition(.numericText())
            Spacer()
            if query.isFiltering {
                Button("Clear Filters") { clearFilters() }
                    .font(.footnote)
                    .buttonStyle(.borderless)
                    .textCase(nil)
            }
        }
    }

    @ViewBuilder
    private func row(for note: StudyNote) -> some View {
        if isSelecting {
            selectableRow(for: note)
        } else {
            NavigationLink(value: note.id) {
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
                    filterMenu
                }
                ToolbarItem(placement: .primaryAction) {
                    manageMenu
                }
            }
        }
    }

    /// Sort order and source filters in one menu. The icon fills in while a filter is active,
    /// and the accessibility value says so, so the state isn't shown by the icon alone.
    private var filterMenu: some View {
        Menu {
            Picker("Sort By", selection: $query.sortOrder) {
                ForEach(NoteSortOrder.allCases) { order in
                    Label(order.title, systemImage: order.systemImage).tag(order)
                }
            }
            .pickerStyle(.inline)

            Section("Show Sources") {
                Toggle(isOn: Binding(
                    get: { query.sources.isEmpty },
                    set: { if $0 { query.sources = [] } }
                )) {
                    Label("All Sources", systemImage: "tray.full")
                }
                ForEach(NoteSource.allCases) { source in
                    Toggle(isOn: Binding(
                        get: { query.sources.contains(source) },
                        set: { isOn in
                            if isOn { query.sources.insert(source) } else { query.sources.remove(source) }
                        }
                    )) {
                        Label("\(source.displayName) (\(count(of: source)))", systemImage: source.systemImage)
                    }
                }
            }
        } label: {
            Label("Filter and Sort", systemImage: query.sources.isEmpty
                  ? "line.3.horizontal.decrease.circle"
                  : "line.3.horizontal.decrease.circle.fill")
        }
        .accessibilityValue(query.sources.isEmpty
                            ? "\(query.sortOrder.title), all sources"
                            : "\(query.sortOrder.title), showing \(query.sources.map(\.displayName).sorted().formatted(.list(type: .and)))")
    }

    private func count(of source: NoteSource) -> Int {
        notesViewModel.notes.count { $0.source == source }
    }

    private var manageMenu: some View {
        let visible = visibleNotes
        return Menu {
            Button("Select Notes…", systemImage: "checkmark.circle") {
                isSelecting = true
            }
            // While searching or filtering, offer the shown notes as their own set.
            if query.isFiltering && !visible.isEmpty {
                Button("Study Shown Notes (\(visible.count))", systemImage: "graduationcap") {
                    study(Set(visible.map(\.id)))
                }
                .disabled(studyViewModel.isGenerating)
                Button("Export Shown Notes (\(visible.count))…", systemImage: "square.and.arrow.up") {
                    exportRequest = NoteExportRequest(notes: visible)
                }
            }
            Button("Export All Notes…", systemImage: "square.and.arrow.up") {
                exportRequest = NoteExportRequest(notes: notesViewModel.sortedNotes)
            }
            Divider()
            // Always every saved note, even ones hidden by a filter; the dialog states the full count.
            Button("Clear All Notes…", systemImage: "trash", role: .destructive) {
                pendingDeletion = PendingNoteDeletion(notes: notesViewModel.sortedNotes, isClearAll: true)
            }
        } label: {
            Label("Manage Notes", systemImage: "ellipsis.circle")
        }
    }

    @ViewBuilder
    private var selectionActions: some View {
        let visibleIDs = Set(visibleNotes.map(\.id))
        let allSelected = !visibleIDs.isEmpty && visibleIDs.isSubset(of: selection)
        // Acts on the notes currently shown, so a filter narrows what Select All picks.
        Button(allSelected ? "Deselect All" : "Select All") {
            selection = allSelected ? [] : visibleIDs
        }

        Spacer()

        // Selected Notes study source: hand the selection to the Study tab (nothing is generated
        // until the user taps Generate there).
        Button("Study", systemImage: "graduationcap") {
            study(selection)
        }
        .accessibilityLabel("Study These Notes")
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

    /// Hands `ids` to the Study tab as the Selected Notes source. Nothing is generated until the
    /// user taps Generate there, so no Foundation Models request is made from the Notes tab.
    private func study(_ ids: Set<UUID>) {
        studyViewModel.scope = .selectedNotes(ids)
        endSelecting()
        navigation.showStudyRoot()
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
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(note.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(caption)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 4)
        // One VoiceOver stop per note: "Photosynthesis, Scanned, Oct 12 at 3:04 PM".
        .accessibilityElement(children: .combine)
    }

    /// The date plus the note's source in words (the icon alone doesn't name it), with the
    /// file name for imported notes.
    private var caption: String {
        let date = note.createdAt.formatted(.dateTime.month().day().hour().minute())
        if let info = note.importInfo { return "\(date) · Imported · \(info.filename)" }
        if note.source == .wikipedia { return "\(date) · From Wikipedia" }
        return "\(date) · \(note.source.displayName)"
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
