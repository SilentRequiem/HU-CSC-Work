import SwiftUI

/// Recite / Quiz Me: uses the practice questions from the shared study guide, which is built from
/// the notes in the user's study source (All Notes, Selected Notes, or a Single Note). StudyLens
/// reads a question aloud, the user answers out loud or by typing, and the answer is graded
/// against the guide's expected answer. Shown in the Speak Note sheet and from the Study tab.
/// It never requests a new guide on its own; it reuses `StudyViewModel.guide`.
struct QuizMeSection: View {
    @Bindable var viewModel: QuizMeViewModel
    /// Set when Quiz Me is pushed on the Study stack, so empty states can offer Back to Study.
    var onBackToStudy: (() -> Void)?
    @Environment(NotesViewModel.self) private var notesViewModel
    @Environment(StudyViewModel.self) private var studyViewModel
    @FocusState private var isTypingFocused: Bool

    private var questions: [PracticeQuestion] {
        studyViewModel.guide?.analysis.practiceQuestions ?? []
    }

    var body: some View {
        Group {
            if let item = viewModel.currentQuestion(in: questions) {
                quiz(for: item)
            } else {
                noGuideCard
            }
        }
        // A new study guide means new questions; start again from question 1.
        .onChange(of: studyViewModel.guide?.id, initial: true) {
            viewModel.showGuide(id: studyViewModel.guide?.id)
        }
        .task { studyViewModel.refreshAvailability() }
    }

    // MARK: - Quiz

    private func quiz(for item: PracticeQuestion) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            questionCard(for: item)
            answerCard
            if viewModel.isEvaluating || viewModel.result != nil {
                resultCard
            }
            expectedAnswerCard(for: item)
            navigationButtons
        }
    }

    private func questionCard(for item: PracticeQuestion) -> some View {
        SpeakCard(title: "Question \(viewModel.currentIndex + 1) of \(questions.count)", systemImage: "questionmark.bubble", tint: .green) {
            Menu {
                ForEach(questions.indices, id: \.self) { index in
                    Button("\(index + 1). \(questions[index].question)") {
                        viewModel.select(index: index, in: questions)
                    }
                }
            } label: {
                Label("Choose Question", systemImage: "list.number")
                    .font(.footnote)
            }
            .menuStyle(.button)
            .buttonStyle(.borderless)

            // Which notes these questions came from, and whether they're outdated.
            if let guide = studyViewModel.guide {
                StudySourceBanner(guide: guide, isCompact: true)
            }

            Text(item.question)
                .font(.title3.weight(.semibold))
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Button {
                    viewModel.readQuestion(in: questions)
                } label: {
                    Label(viewModel.isSpeakingQuestion ? "Reading…" : "Read Question Aloud",
                          systemImage: viewModel.isSpeakingQuestion ? "speaker.wave.3.fill" : "speaker.wave.2")
                }
                .buttonStyle(.bordered)
                .tint(.green)
                .symbolEffect(.variableColor.iterative, options: .repeating, isActive: viewModel.isSpeakingQuestion)

                Spacer(minLength: 0)

                Toggle("Auto-read", isOn: $viewModel.readsQuestionsAutomatically)
                    .toggleStyle(.switch)
                    .controlSize(.small)
                    .font(.footnote)
                    .fixedSize()
            }
        }
    }

    private var answerCard: some View {
        SpeakCard(title: "Your Answer", systemImage: viewModel.inputMethod == .spoken ? "mic" : "keyboard") {
            // Speaking isn't always practical (a library, a noisy room), so typing is always available.
            Picker("Answer by", selection: Binding(
                get: { viewModel.inputMethod },
                set: { viewModel.setInputMethod($0) }
            )) {
                ForEach(AnswerInputMethod.allCases) { method in
                    Label(method.title, systemImage: method.systemImage).tag(method)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()

            if viewModel.inputMethod == .spoken {
                RecordButton(
                    isRecording: viewModel.isRecording,
                    isStarting: viewModel.isStartingRecording,
                    startTitle: "Answer Out Loud",
                    stopTitle: "Stop Answering",
                    action: viewModel.toggleRecording
                )
                .padding(.vertical, 4)
            }

            if let errorMessage = viewModel.errorMessage {
                SpeechErrorView(message: errorMessage, error: viewModel.speechError) {
                    viewModel.setInputMethod(.typed)
                    isTypingFocused = true
                }
            }

            TextField(
                viewModel.inputMethod == .spoken ? "Your spoken answer appears here" : "Type your answer",
                text: $viewModel.answerText,
                axis: .vertical
            )
            .lineLimit(3...8)
            .textFieldStyle(.roundedBorder)
            .focused($isTypingFocused)
            .disabled(viewModel.isRecording)

            Button {
                isTypingFocused = false
                viewModel.checkAnswer(in: questions)
            } label: {
                Label("Check Answer", systemImage: "checkmark.seal")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            .controlSize(.large)
            .disabled(!viewModel.canCheckAnswer)

            Label(
                viewModel.usesOnDeviceModel
                    ? "Graded on device by Apple Intelligence, using only your study guide's answer."
                    : "Apple Intelligence isn't available, so answers are graded by matching key words.",
                systemImage: viewModel.usesOnDeviceModel ? "apple.intelligence" : "text.magnifyingglass"
            )
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var resultCard: some View {
        if viewModel.isEvaluating {
            SpeakCard(title: "Checking", systemImage: "sparkles", tint: .purple) {
                ProgressView("Comparing your answer with the study guide…")
                    .frame(maxWidth: .infinity)
            }
        } else if let result = viewModel.result {
            let tint = Self.tint(for: result.verdict)
            VStack(alignment: .leading, spacing: 10) {
                Label(result.verdict.displayName, systemImage: result.verdict.systemImage)
                    .font(.title2.bold())
                    .foregroundStyle(tint)
                Text(result.explanation)
                    .fixedSize(horizontal: false, vertical: true)
                Text(gradingCaption(for: result))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(tint.opacity(0.12), in: .rect(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16).strokeBorder(tint.opacity(0.4))
            }
            .accessibilityElement(children: .combine)
        }
    }

    private func expectedAnswerCard(for item: PracticeQuestion) -> some View {
        SpeakCard(title: "Expected Answer", systemImage: "eye", tint: .green) {
            if viewModel.isAnswerRevealed {
                Text(item.answer)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.green.opacity(0.1), in: .rect(cornerRadius: 10))
            }
            HStack {
                Button(viewModel.isAnswerRevealed ? "Hide Answer" : "Reveal Answer",
                       systemImage: viewModel.isAnswerRevealed ? "eye.slash" : "eye") {
                    withAnimation { viewModel.isAnswerRevealed.toggle() }
                }
                if viewModel.isAnswerRevealed {
                    Spacer()
                    Button("Read Answer", systemImage: "speaker.wave.2") {
                        viewModel.readExpectedAnswer(in: questions)
                    }
                }
            }
            .font(.footnote)
            .buttonStyle(.borderless)
        }
    }

    private var navigationButtons: some View {
        HStack(spacing: 12) {
            Button {
                viewModel.previous(in: questions)
            } label: {
                Label("Previous", systemImage: "chevron.left")
                    .frame(maxWidth: .infinity)
            }
            .disabled(viewModel.currentIndex == 0)

            Button {
                viewModel.next(in: questions)
            } label: {
                Label("Next Question", systemImage: "chevron.right")
                    .labelStyle(TrailingIconLabelStyle())
                    .frame(maxWidth: .infinity)
            }
            .disabled(viewModel.currentIndex >= questions.count - 1)
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
    }

    private func gradingCaption(for result: AnswerEvaluationResult) -> String {
        let grader = result.method == .onDeviceModel ? "Graded by the on-device model" : "Graded by key-word matching"
        switch viewModel.resultInputMethod {
        case .spoken: return "Spoken answer · \(grader)"
        case .typed: return "Typed answer · \(grader)"
        case nil: return grader
        }
    }

    private static func tint(for verdict: AnswerVerdict) -> Color {
        switch verdict {
        case .correct: .green
        case .partiallyCorrect: .orange
        case .tryAgain: .red
        }
    }

    // MARK: - No study guide yet

    @ViewBuilder
    private var noGuideCard: some View {
        if let guide = studyViewModel.guide, guide.analysis.practiceQuestions.isEmpty {
            // Rare, but possible if the model returned a guide without questions.
            ContentUnavailableView {
                Label("No Practice Questions", systemImage: "questionmark.bubble")
            } description: {
                Text("This study guide doesn't include any practice questions. Regenerate it on the Study tab to try again.")
            } actions: {
                backToStudyButton
            }
        } else if notesViewModel.notes.isEmpty {
            ContentUnavailableView {
                Label("No Practice Questions Yet", systemImage: "questionmark.bubble")
            } description: {
                Text("Save some notes first — scanned, handwritten, spoken, or imported. StudyLens turns them into a study guide with practice questions you can answer out loud or by typing.")
            } actions: {
                backToStudyButton
            }
        } else if case let .unavailable(title, message) = studyViewModel.availability {
            ContentUnavailableView {
                Label(title, systemImage: "apple.intelligence")
            } description: {
                Text("Quiz Me uses the practice questions from the AI study guide. \(message)")
            } actions: {
                Button("Check Again") { studyViewModel.refreshAvailability() }
                    .buttonStyle(.bordered)
            }
        } else {
            SpeakCard(title: "Generate Practice Questions", systemImage: "sparkles", tint: .purple) {
                Text("Quiz Me uses the practice questions from your study guide. Generate one from \(scopeDescription) to begin. Change the study source in the Study tab.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                if let errorMessage = studyViewModel.errorMessage {
                    SpeakMessageLabel(message: errorMessage, tint: .red)
                }

                Button {
                    // Reuses the Study tab's Foundation Models pipeline, shared guide, and study source.
                    Task { await studyViewModel.generate(using: notesViewModel.notes) }
                } label: {
                    HStack {
                        if studyViewModel.isGenerating {
                            ProgressView().controlSize(.small)
                            Text("Generating…")
                        } else {
                            Label("Generate Study Guide", systemImage: "sparkles")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.purple)
                .disabled(studyViewModel.isGenerating || studyViewModel.scope.resolve(in: notesViewModel.notes).isEmpty)
            }
        }
    }

    @ViewBuilder
    private var backToStudyButton: some View {
        if let onBackToStudy {
            Button("Back to Study", systemImage: "chevron.backward", action: onBackToStudy)
                .buttonStyle(.bordered)
        }
    }

    /// e.g. "All Notes (8 notes)" or "Selected Notes (3 notes)", for the generate prompt.
    private var scopeDescription: String {
        let count = studyViewModel.scope.resolve(in: notesViewModel.notes).count
        return "\(studyViewModel.scope.kind.title) (\(count) \(count == 1 ? "note" : "notes"))"
    }
}

/// Puts the icon after the title, for "Next" style buttons.
private struct TrailingIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 6) {
            configuration.title
            configuration.icon
        }
    }
}
