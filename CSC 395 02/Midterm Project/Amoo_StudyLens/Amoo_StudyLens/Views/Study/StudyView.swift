import SwiftUI

/// The Study workflow: choose a study source, generate a guide, and open Quiz Me / Flashcards.
///
/// Navigation: the stack's path is `AppNavigationModel.studyPath`, so every push and pop goes
/// through one owner. Generating a guide only changes `StudyViewModel` data; it can never change
/// the path, and nothing here can present Speak Note (that lives only on the Capture tab).
/// All model work lives in `StudyViewModel` / `StudyAnalysisService`; this view only presents state.
struct StudyView: View {
    @Environment(NotesViewModel.self) private var notesViewModel
    @Environment(StudyViewModel.self) private var studyViewModel
    @Environment(AppNavigationModel.self) private var navigation

    var body: some View {
        @Bindable var navigation = navigation

        NavigationStack(path: $navigation.studyPath) {
            content
                .navigationTitle("Study")
                .navigationDestination(for: StudyDestination.self) { destination in
                    switch destination {
                    case .quizMe: QuizMeScreen()
                    case .flashcards: FlashcardsView()
                    case .chooseNotes: StudySourcePickerView()
                    case .concept(let concept): ConceptDetailView(concept: concept)
                    }
                }
        }
        .task {
            // Availability can change while the app is open (e.g. the model finishes downloading).
            studyViewModel.refreshAvailability()
        }
    }

    @ViewBuilder
    private var content: some View {
        if notesViewModel.notes.isEmpty && studyViewModel.guide == nil {
            ContentUnavailableView(
                "No Study Material Yet",
                systemImage: "note.text.badge.plus",
                description: Text("Add notes from the Capture tab, then come back here to generate a study guide.")
            )
        } else {
            // One stable layout. Model availability only affects the Generate button inside
            // `StudySourceCard`; an existing guide is never hidden because the model is busy.
            ScrollView {
                VStack(spacing: 16) {
                    StudySourceCard()

                    if let errorMessage = studyViewModel.errorMessage {
                        Label(errorMessage, systemImage: "exclamationmark.triangle")
                            .font(.subheadline)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    if let guide = studyViewModel.guide {
                        StudySourceBanner(guide: guide)
                        StudyGuideResultView(guide: guide)
                            // Reset per-question reveal state whenever a new guide arrives.
                            .id(guide.id)
                    } else if studyViewModel.isGenerating {
                        ProgressView("Generating your study guide on device…")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 24)
                    }
                }
                .padding()
            }
        }
    }
}

// MARK: - Result

/// Presents a generated guide: summary, key concepts, then practice questions.
private struct StudyGuideResultView: View {
    let guide: GeneratedStudyGuide
    @Environment(AppNavigationModel.self) private var navigation

    private var analysis: StudyAnalysis { guide.analysis }

    var body: some View {
        VStack(spacing: 16) {
            StudySectionCard(title: "Summary", systemImage: "text.alignleft", tint: .blue) {
                Text(analysis.summary)
                    .fixedSize(horizontal: false, vertical: true)

                if guide.wasTruncated {
                    Text("Your notes were long, so only the first part was analyzed.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

            StudySectionCard(title: "Key Concepts", systemImage: "lightbulb", tint: .orange) {
                // Generated arrays are fixed for the life of this view, so offsets are stable IDs.
                ForEach(Array(analysis.keyConcepts.enumerated()), id: \.offset) { _, concept in
                    // Each concept opens Concept Detail (with the optional Wikipedia Learn More).
                    // Nothing is fetched until the user asks on that screen.
                    Button {
                        navigation.openStudy(.concept(StudyConcept(
                            name: concept.name,
                            explanation: concept.explanation,
                            origin: .keyConcepts
                        )))
                    } label: {
                        HStack(alignment: .center, spacing: 8) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(concept.name)
                                    .font(.subheadline.bold())
                                    .foregroundStyle(.primary)
                                Text(concept.explanation)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                        .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .accessibilityHint("Shows details and an optional Learn More from Wikipedia.")
                }

                Text("Tap a concept for details and an optional Learn More from Wikipedia.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            StudySectionCard(title: "Practice Questions", systemImage: "questionmark.bubble", tint: .green) {
                ForEach(Array(analysis.practiceQuestions.enumerated()), id: \.offset) { index, item in
                    PracticeQuestionRow(number: index + 1, item: item)
                }

                Button {
                    navigation.openStudy(.quizMe)
                } label: {
                    Label("Quiz Me on These Questions", systemImage: "questionmark.bubble.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)

                Text("Answer out loud or by typing. Questions come only from \(guide.source.summary).")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            FlashcardsEntryCard(analysis: analysis)

            StudySectionCard(title: "Brain Map", systemImage: "brain.head.profile", tint: .pink) {
                Text("\(analysis.brainMap.concepts.count) concepts and \(analysis.brainMap.relationships.count) connections from the same study set.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Button("Open Brain Map", systemImage: "brain.head.profile") {
                    // Switching tabs keeps this guide; the Brain Map tab reads the same StudyViewModel.
                    navigation.selectedTab = .brainMap
                }
                .buttonStyle(.bordered)
                .tint(.pink)
            }
        }
    }
}

/// Opens Flashcards, which reuses the guide's Practice Questions and Key Concepts as cards.
/// Only shown once a guide exists, so Flashcards can never open to "No Study Guide Yet" from here.
private struct FlashcardsEntryCard: View {
    let analysis: StudyAnalysis
    @Environment(AppNavigationModel.self) private var navigation

    private var description: String {
        let questions = analysis.practiceQuestions.count
        let concepts = analysis.keyConcepts.count
        return "Flip through \(questions) question \(questions == 1 ? "card" : "cards") and \(concepts) key-concept \(concepts == 1 ? "card" : "cards"), then mark each one Know It or Review Again."
    }

    var body: some View {
        StudySectionCard(title: "Flashcards", systemImage: "rectangle.on.rectangle.angled", tint: .flashcardsAccent) {
            Text(description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Button {
                navigation.openStudy(.flashcards)
            } label: {
                Label("Study Flashcards", systemImage: "rectangle.on.rectangle.angled.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.flashcardsAccent)
        }
    }
}

/// A practice question whose answer stays hidden until the user reveals it.
private struct PracticeQuestionRow: View {
    let number: Int
    let item: PracticeQuestion

    @State private var isRevealed = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(number). \(item.question)")
                .font(.subheadline.weight(.medium))
                .fixedSize(horizontal: false, vertical: true)

            if isRevealed {
                Text(item.answer)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.green.opacity(0.1), in: .rect(cornerRadius: 10))
            }

            Button(isRevealed ? "Hide Answer" : "Reveal Answer", systemImage: isRevealed ? "eye.slash" : "eye") {
                withAnimation { isRevealed.toggle() }
            }
            .font(.footnote)
            .buttonStyle(.borderless)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// A titled card that groups one section of the study guide. Also used by `ConceptDetailView`
/// so concept details look like the rest of the Study tab.
struct StudySectionCard<Content: View>: View {
    let title: String
    let systemImage: String
    let tint: Color
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: systemImage)
                .font(.headline)
                .foregroundStyle(tint)
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.background.secondary, in: .rect(cornerRadius: 16))
    }
}

#Preview {
    StudyView()
        .environment(NotesViewModel())
        .environment(StudyViewModel())
        .environment(AppNavigationModel())
}
