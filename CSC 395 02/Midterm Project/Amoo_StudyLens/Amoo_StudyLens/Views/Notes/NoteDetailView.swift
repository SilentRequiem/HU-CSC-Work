import SwiftUI

/// Shows the full contents of a captured note, with Study This Note, Export, and Delete actions.
struct NoteDetailView: View {
    let note: StudyNote

    @Environment(NotesViewModel.self) private var notesViewModel
    @Environment(StudyViewModel.self) private var studyViewModel
    @Environment(AppNavigationModel.self) private var navigation
    @Environment(\.dismiss) private var dismiss
    @State private var pendingDeletion: PendingNoteDeletion?
    @State private var isExporting = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Label(note.source.displayName, systemImage: note.source.systemImage)
                    Spacer()
                    Text(note.createdAt, format: .dateTime.month().day().year())
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

                Button {
                    studyThisNote()
                } label: {
                    Label("Study This Note", systemImage: "graduationcap")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.purple)
                .disabled(studyViewModel.isGenerating)

                Text(note.body)
                    .font(.body)
                    .textSelection(.enabled)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle(note.title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
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
            dismiss()
        }
        .sheet(isPresented: $isExporting) {
            NotesExportSheet(notes: [note])
        }
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
