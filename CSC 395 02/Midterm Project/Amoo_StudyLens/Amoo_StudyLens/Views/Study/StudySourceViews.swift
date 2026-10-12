import SwiftUI

// MARK: - Study source picker card

/// The top of the Study screen: choose All Notes / Selected Notes / Single Note, see exactly which
/// notes will be used, and generate. Writes only `StudyViewModel.scope`; the guide currently shown
/// keeps describing its own source until a new one is generated.
struct StudySourceCard: View {
    @Environment(NotesViewModel.self) private var notesViewModel
    @Environment(StudyViewModel.self) private var studyViewModel
    @Environment(AppNavigationModel.self) private var navigation

    private var notes: [StudyNote] { notesViewModel.notes }
    private var scopedNotes: [StudyNote] { studyViewModel.scope.resolve(in: notes) }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Study Source", systemImage: "books.vertical")
                .font(.headline)
                .foregroundStyle(.purple)

            Picker("Study Source", selection: Binding(
                get: { studyViewModel.scope.kind },
                set: { studyViewModel.selectScopeKind($0, notes: notes) }
            )) {
                ForEach(StudyScopeKind.allCases) { kind in
                    Text(kind.title).tag(kind)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .disabled(studyViewModel.isGenerating)

            scopeDetail

            Divider()

            generateSection
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.background.secondary, in: .rect(cornerRadius: 16))
    }

    // MARK: Scope detail

    @ViewBuilder
    private var scopeDetail: some View {
        switch studyViewModel.scope {
        case .allNotes:
            Text("Combine all \(notes.count) saved \(notes.count == 1 ? "note" : "notes") into one study set.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        case .selectedNotes:
            HStack {
                Text(scopedNotes.isEmpty ? "No notes selected yet." : "\(scopedNotes.count) of \(notes.count) notes selected.")
                    .font(.subheadline)
                    .foregroundStyle(scopedNotes.isEmpty ? AnyShapeStyle(Color.studyLensWarning) : AnyShapeStyle(.secondary))
                Spacer()
                Button("Choose Notes…", systemImage: "checklist") {
                    navigation.openStudy(.chooseNotes)
                }
                .buttonStyle(.bordered)
                .disabled(studyViewModel.isGenerating)
            }
        case .singleNote(let id):
            Picker("Note", selection: Binding(
                get: { id },
                set: { studyViewModel.scope = .singleNote($0) }
            )) {
                ForEach(notesViewModel.sortedNotes) { note in
                    Label(note.title, systemImage: note.source.systemImage).tag(note.id)
                }
            }
            .pickerStyle(.menu)
            .disabled(studyViewModel.isGenerating)
        }

        if !scopedNotes.isEmpty, studyViewModel.scope.kind != .singleNote {
            Label(StudySource.describeTitles(scopedNotes.map(\.title)), systemImage: "doc.on.doc")
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: Generate

    @ViewBuilder
    private var generateSection: some View {
        if case let .unavailable(title, message) = studyViewModel.availability {
            // Only *generating* needs the model. An existing guide stays visible below.
            VStack(alignment: .leading, spacing: 8) {
                Label(title, systemImage: "apple.intelligence")
                    .font(.subheadline.bold())
                Text("StudyLens uses Apple's on-device Foundation Models to create study guides. \(message)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                Button("Check Again") { studyViewModel.refreshAvailability() }
                    .buttonStyle(.bordered)
            }
        } else {
            if let guide = studyViewModel.guide, !studyViewModel.guideMatchesScope(in: notes), !studyViewModel.isGenerating {
                Label("Generating replaces the current guide from \(guide.source.summary).", systemImage: "arrow.triangle.swap")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Button {
                Task { await studyViewModel.generate(using: notes) }
            } label: {
                HStack {
                    if studyViewModel.isGenerating {
                        ProgressView()
                            .controlSize(.small)
                        Text("Generating…")
                    } else {
                        Label(generateTitle, systemImage: "sparkles")
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple)
            // Prevents duplicate generation requests while the model is working.
            .disabled(studyViewModel.isGenerating || scopedNotes.isEmpty)
        }
    }

    private var generateTitle: String {
        if studyViewModel.guide == nil { return "Generate Study Guide" }
        return studyViewModel.guideMatchesScope(in: notes) ? "Regenerate Study Guide" : "Generate from \(studyViewModel.scope.kind.title)"
    }
}

// MARK: - Choose notes (Selected Notes scope)

/// Pushed on the Study stack: a checklist of saved notes for the Selected Notes study source.
struct StudySourcePickerView: View {
    @Environment(NotesViewModel.self) private var notesViewModel
    @Environment(StudyViewModel.self) private var studyViewModel
    @Environment(AppNavigationModel.self) private var navigation

    private var selectedIDs: Set<UUID> {
        if case .selectedNotes(let ids) = studyViewModel.scope { return ids }
        return []
    }

    var body: some View {
        List {
            Section {
                ForEach(notesViewModel.sortedNotes) { note in
                    let isSelected = selectedIDs.contains(note.id)
                    Button {
                        studyViewModel.toggleSelection(of: note.id)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                .font(.title3)
                                .foregroundStyle(isSelected ? AnyShapeStyle(.purple) : AnyShapeStyle(.secondary))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(note.title)
                                    .font(.headline)
                                    .lineLimit(1)
                                Text(noteCaption(note))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                            Spacer(minLength: 0)
                        }
                        .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
                }
            } footer: {
                Text("Only the selected notes are sent to the on-device model. Quiz Me, Flashcards, and Brain Map all use the same selection.")
            }
        }
        .navigationTitle(selectedIDs.isEmpty ? "Choose Notes" : "\(selectedIDs.count) Selected")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                let allSelected = selectedIDs.count == notesViewModel.notes.count && !notesViewModel.notes.isEmpty
                Button(allSelected ? "Deselect All" : "Select All") {
                    studyViewModel.scope = .selectedNotes(allSelected ? [] : Set(notesViewModel.notes.map(\.id)))
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") { navigation.popStudy() }
            }
        }
        .onAppear {
            // Opening the checklist always means "Selected Notes".
            if studyViewModel.scope.kind != .selectedNotes {
                studyViewModel.selectScopeKind(.selectedNotes, notes: notesViewModel.notes)
            }
        }
    }

    private func noteCaption(_ note: StudyNote) -> String {
        let date = note.createdAt.formatted(.dateTime.month().day())
        if let info = note.importInfo { return "\(date) · \(info.summary)" }
        return "\(date) · \(note.source.displayName)"
    }
}

// MARK: - "Generated from" banner

/// Shows what the current study material came from, e.g. "All Notes · 8 notes", and whether it's
/// out of date. Used by Study, Quiz Me, Flashcards, and Brain Map so they all describe the same
/// source in the same words.
struct StudySourceBanner: View {
    @Environment(NotesViewModel.self) private var notesViewModel
    @Environment(StudyViewModel.self) private var studyViewModel

    let guide: GeneratedStudyGuide
    /// Compact banners (Quiz Me, Flashcards, Brain Map) skip the note titles and the button.
    var isCompact = false

    var body: some View {
        let outdatedReason = guide.source.outdatedReason(comparedWith: notesViewModel.notes)

        VStack(alignment: .leading, spacing: 6) {
            Label {
                Text("From \(guide.source.summary)")
                    .font(isCompact ? .caption.weight(.semibold) : .subheadline.weight(.semibold))
            } icon: {
                Image(systemName: guide.source.kind.systemImage)
            }
            .foregroundStyle(.purple)

            if !isCompact, guide.source.kind != .singleNote {
                Text(guide.source.titlesDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let outdatedReason {
                Label("\(outdatedReason) This material is outdated\(isCompact ? "; regenerate it in the Study tab." : ".")",
                      systemImage: "arrow.triangle.2.circlepath")
                    .font(.caption)
                    .foregroundStyle(Color.studyLensWarning)
                    .fixedSize(horizontal: false, vertical: true)

                if !isCompact {
                    Button("Regenerate from Updated Notes", systemImage: "sparkles") {
                        Task { await studyViewModel.regenerateCurrentGuide(using: notesViewModel.notes) }
                    }
                    .font(.footnote)
                    .buttonStyle(.bordered)
                    .tint(.orange)
                    .disabled(studyViewModel.isGenerating || studyViewModel.availability != .available)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(isCompact ? 10 : 14)
        .background(Color.purple.opacity(0.08), in: .rect(cornerRadius: 12))
        .accessibilityElement(children: .contain)
    }
}
