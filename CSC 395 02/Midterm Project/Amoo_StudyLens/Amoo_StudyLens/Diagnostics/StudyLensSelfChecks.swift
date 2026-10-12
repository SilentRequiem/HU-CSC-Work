#if DEBUG
import CoreGraphics
import Foundation

// MARK: - Self-checks (Prompt 10)
//
// StudyLens has no unit-test target, so these logic checks live in a DEBUG-only file and are run
// on demand (for example from Xcode's code-snippet runner) with:
//
//     let report = await StudyLensSelfChecks.runAll()
//     print(report.summary)
//
// Safety rules every check follows:
//   • Notes are only ever written to in-memory stores (`SwiftDataNoteStore(isStoredInMemoryOnly:)`
//     or `InMemoryNoteStore`), never the user's saved-note database.
//   • Wikipedia is never contacted; a mock `URLProtocol` answers every request and counts them.
//   • Import files are written to a private temporary folder that is deleted afterwards.
//   • Foundation Models is never called (only paths that stop before a model request are used).
// Nothing in the app calls this file, and it isn't compiled into Release builds.

@MainActor
enum StudyLensSelfChecks {
    struct Report {
        var lines: [String] = []
        var passed = 0
        var failed = 0

        var summary: String {
            (lines + ["", "\(passed) passed, \(failed) failed"]).joined(separator: "\n")
        }

        mutating func section(_ title: String) {
            lines.append("")
            lines.append("== \(title) ==")
        }

        mutating func check(_ name: String, _ condition: Bool) {
            if condition { passed += 1 } else { failed += 1 }
            lines.append("\(condition ? "PASS" : "FAIL")  \(name)")
        }
    }

    static func runAll() async -> Report {
        var report = Report()
        checkNoteQuery(&report)
        checkNavigation(&report)
        checkPersistence(&report)
        checkOutdatedDetection(&report)
        checkStudySource(&report)
        checkQuizGrading(&report)
        checkFlashcards(&report)
        await checkWikipedia(&report)
        await checkImport(&report)
        checkExport(&report)
        checkBrainMap(&report)
        return report
    }

    // MARK: Fixtures

    private static let baseDate = Date(timeIntervalSinceReferenceDate: 800_000_000)

    private static func note(_ title: String, _ body: String, _ source: NoteSource, minutes: Double) -> StudyNote {
        StudyNote(title: title, body: body, source: source, createdAt: baseDate.addingTimeInterval(minutes * 60))
    }

    private static func sampleGuide(concepts: Int, questions: Int) -> GeneratedStudyGuide {
        let analysis = StudyAnalysis(
            summary: "Cells turn glucose into energy.",
            keyConcepts: (0..<concepts).map { KeyConcept(name: "Concept \($0 + 1)", explanation: "Explanation \($0 + 1)") },
            practiceQuestions: (0..<questions).map { PracticeQuestion(question: "Question \($0 + 1)?", answer: "Answer \($0 + 1)") },
            brainMap: BrainMap(centralTopic: "Cells", concepts: [], relationships: [])
        )
        return GeneratedStudyGuide(analysis: analysis, source: StudySource(kind: .allNotes, notes: []), includedNoteCount: 0, wasTruncated: false)
    }

    // MARK: Notes search / filter / sort

    private static func checkNoteQuery(_ report: inout Report) {
        report.section("Note query filtering and sorting")
        let notes = [
            note("Photosynthesis", "Plants make glucose from light.", .scan, minutes: 0),
            note("Cell Parts", "The mitochondria makes ATP.", .handwriting, minutes: 1),
            note("Café Lecture", "Résumé of enzymes.", .voice, minutes: 2)
        ]
        var query = NoteListQuery()
        report.check("Newest first by default", query.apply(to: notes).map(\.title) == ["Café Lecture", "Cell Parts", "Photosynthesis"])
        query.sortOrder = .oldest
        report.check("Oldest first", query.apply(to: notes).first?.title == "Photosynthesis")
        query.sortOrder = .title
        report.check("Title order", query.apply(to: notes).map(\.title) == ["Café Lecture", "Cell Parts", "Photosynthesis"])
        query.searchText = "atp"
        report.check("Body search, case-insensitive", query.apply(to: notes).map(\.title) == ["Cell Parts"])
        query.searchText = "cafe resume"
        report.check("Multi-word, accent-insensitive search", query.apply(to: notes).map(\.title) == ["Café Lecture"])
        query.searchText = ""
        query.sources = [.scan]
        report.check("Source filter", query.apply(to: notes).map(\.title) == ["Photosynthesis"])
        query.searchText = "nothing matches this"
        report.check("No matches gives an empty list", query.apply(to: notes).isEmpty)
    }

    // MARK: Navigation

    private static func checkNavigation(_ report: inout Report) {
        report.section("Navigation duplicate prevention")
        let navigation = AppNavigationModel()
        navigation.show(.study)
        navigation.openStudy(.quizMe)
        navigation.openStudy(.quizMe)
        report.check("Double tap on Quiz Me pushes one screen", navigation.studyPath == [.quizMe])
        navigation.popStudy()
        navigation.openStudy(.flashcards)
        let concept = StudyConcept(name: "Glucose", explanation: "A sugar.", origin: .flashcards)
        navigation.openStudy(.concept(concept))
        navigation.openStudy(.flashcards)
        report.check("Reopening a screen lower in the stack pops back to it", navigation.studyPath == [.flashcards])
        report.check("Quiz Me -> Back returns to the Study root", { navigation.studyPath.removeAll(); navigation.openStudy(.quizMe); navigation.popStudy(); return navigation.studyPath.isEmpty }())

        let noteID = UUID()
        navigation.openNote(noteID)
        navigation.openNote(noteID)
        report.check("Double tap on a note opens one Note Detail", navigation.notesPath == [noteID])
        navigation.openStudy(.flashcards)
        navigation.show(.notes)
        navigation.show(.capture)
        report.check("Switching tabs keeps other tabs' stacks", navigation.notesPath == [noteID] && navigation.studyPath == [.flashcards])
        navigation.forgetDeletedNotes(keeping: [])
        report.check("A deleted note's detail screen is closed", navigation.notesPath.isEmpty)

        navigation.openStudy(.concept(concept))
        navigation.openBrainMapConcept(StudyConcept(name: "Cells", explanation: nil, origin: .brainMap))
        navigation.openBrainMapConcept(StudyConcept(name: "Cells", explanation: nil, origin: .brainMap))
        report.check("Brain Map concept double tap pushes one screen", navigation.brainMapPath.count == 1)
        navigation.closeConceptDetails()
        report.check("New guide closes stale Concept Detail screens, keeps Flashcards", navigation.studyPath == [.flashcards] && navigation.brainMapPath.isEmpty)
        report.check("Generating never opens a Capture sheet", navigation.activeCapture == nil)
        navigation.beginCapture(.importFile)
        report.check("Capture from a menu switches tab but keeps stacks", navigation.selectedTab == .capture && navigation.studyPath == [.flashcards])
    }

    // MARK: Persistence (in-memory SwiftData only)

    private static func checkPersistence(_ report: inout Report) {
        report.section("SwiftData persistence (in-memory store)")
        let store: SwiftDataNoteStore
        do {
            store = try SwiftDataNoteStore(isStoredInMemoryOnly: true)
        } catch {
            report.check("Open in-memory SwiftData store (\(error.localizedDescription))", false)
            return
        }
        let viewModel = NotesViewModel(store: store)
        report.check("In-memory store starts empty (real notes untouched)", viewModel.notes.isEmpty)

        let importInfo = ImportedFileInfo(filename: "Lecture 4.pdf", kind: .pdf, unitCount: 12)
        let external = ExternalSourceInfo(articleTitle: "Mitochondrion", url: URL(string: "https://en.wikipedia.org/wiki/Mitochondrion"))
        var notes = NoteSource.allCases.enumerated().map { index, source in
            note("\(source.displayName) note", "Body \(index)", source, minutes: Double(index))
        }
        notes[4].importInfo = importInfo      // .imported
        notes[5].externalSource = external    // .wikipedia
        notes.forEach(viewModel.add)

        let reloaded = (try? store.loadNotes()) ?? []
        report.check("All six sources saved and reloaded", Set(reloaded.map(\.source)) == Set(NoteSource.allCases) && reloaded.count == 6)
        report.check("Import metadata survives a reload", reloaded.first { $0.source == .imported }?.importInfo == importInfo)
        report.check("Wikipedia attribution survives a reload", reloaded.first { $0.source == .wikipedia }?.externalSource == external)

        var edited = notes[5]
        edited.title = "Mitochondrion (edited)"
        edited.body = "Edited body"
        viewModel.update(edited)
        var editedImport = notes[4]
        editedImport.body = "Corrected OCR text"
        viewModel.update(editedImport)
        let afterEdit = (try? store.loadNotes()) ?? []
        let savedWiki = afterEdit.first { $0.id == edited.id }
        report.check("Edit keeps ID, source, and creation date", savedWiki?.title == "Mitochondrion (edited)" && savedWiki?.source == .wikipedia && savedWiki?.createdAt == notes[5].createdAt)
        report.check("Edit keeps Wikipedia attribution", savedWiki?.externalSource == external)
        report.check("Edit keeps imported-file metadata", afterEdit.first { $0.id == editedImport.id }?.importInfo == importInfo)

        viewModel.delete(notes[0])
        report.check("Delete removes exactly one note", ((try? store.loadNotes()) ?? []).count == 5)
        viewModel.deleteAll()
        report.check("Clear All empties the store", (try? store.loadNotes())?.isEmpty == true && viewModel.notes.isEmpty)
        report.check("No persistence error reported", viewModel.persistenceErrorMessage == nil)
    }

    // MARK: Outdated study guide

    private static func checkOutdatedDetection(_ report: inout Report) {
        report.section("Outdated-study-guide detection")
        let a = note("A", "Alpha", .typed, minutes: 0)
        let b = note("B", "Beta", .scan, minutes: 1)
        let c = note("C", "Gamma", .voice, minutes: 2)
        let selected = StudySource(kind: .selectedNotes, notes: [a, b])
        report.check("Unchanged notes: current", selected.outdatedReason(comparedWith: [a, b]) == nil)
        var editedA = a
        editedA.body = "Alpha, edited"
        report.check("Edited source note: outdated", selected.outdatedReason(comparedWith: [editedA, b])?.contains("changed") == true)
        report.check("Deleted source note: outdated", selected.outdatedReason(comparedWith: [a])?.contains("deleted") == true)
        report.check("New note doesn't affect a Selected Notes guide", selected.outdatedReason(comparedWith: [a, b, c]) == nil)
        let all = StudySource(kind: .allNotes, notes: [a, b])
        report.check("New note makes an All Notes guide outdated", all.outdatedReason(comparedWith: [a, b, c])?.contains("added") == true)
    }

    // MARK: Study source resolution

    private static func checkStudySource(_ report: inout Report) {
        report.section("Study source resolution")
        let a = note("Alpha title", "Alpha text", .typed, minutes: 0)
        let b = note("Beta title", "Beta text", .scan, minutes: 1)
        let c = note("Gamma title", "Gamma text", .voice, minutes: 2)
        let notes = [c, a, b]
        report.check("All Notes resolves every note, oldest first", StudyScope.allNotes.resolve(in: notes).map(\.id) == [a.id, b.id, c.id])
        report.check("Selected Notes resolves only ticked notes", StudyScope.selectedNotes([a.id, c.id]).resolve(in: notes).map(\.id) == [a.id, c.id])
        report.check("One Note resolves one note", StudyScope.singleNote(b.id).resolve(in: notes).map(\.id) == [b.id])
        report.check("Deleted single note falls back to All Notes", StudyScope.singleNote(UUID()).pruned(keeping: Set(notes.map(\.id))) == .allNotes)
        report.check("Selected Notes forgets deleted notes", StudyScope.selectedNotes([a.id, UUID()]).pruned(keeping: Set(notes.map(\.id))) == .selectedNotes([a.id]))

        let material = StudyAnalysisService().makeStudyMaterial(from: StudyScope.selectedNotes([a.id]).resolve(in: notes))
        report.check("Only selected material is sent to the model", material.text.contains("Alpha text") && !material.text.contains("Beta") && !material.text.contains("Gamma"))
        report.check("Source summary text", StudySource(kind: .singleNote, notes: [b]).summary == "Single Note · Beta title"
            && StudySource(kind: .selectedNotes, notes: [a, b]).summary == "Selected Notes · 2 notes")

        let study = StudyViewModel()
        study.selectScopeKind(.singleNote, notes: notes)
        report.check("One Note defaults to the newest note", study.scope == .singleNote(c.id))
        study.selectScopeKind(.selectedNotes, notes: notes)
        study.toggleSelection(of: a.id)
        study.toggleSelection(of: b.id)
        study.reconcile(with: [a, c])
        report.check("Deleting a selected note removes it from the selection", study.scope == .selectedNotes([a.id]))
        study.toggleSelection(of: a.id)
        report.check("Empty selection is allowed (generate explains what to do)", study.scope == .selectedNotes([]))
        study.reconcile(with: [])
        report.check("Clear All leaves no guide", study.guide == nil)
    }

    // MARK: Quiz Me grading

    private static func checkQuizGrading(_ report: inout Report) {
        report.section("Quiz Me local fallback grading")
        let expected = "Mitochondria produce ATP through cellular respiration"
        func verdict(_ answer: String, _ expected: String) -> AnswerVerdict {
            AnswerEvaluationService.localEvaluation(answer: answer, expectedAnswer: expected).verdict
        }
        report.check("Full answer: Correct", verdict("The mitochondria produce ATP through cellular respiration.", expected) == .correct)
        report.check("Half answer: Partially Correct", verdict("mitochondria produce ATP", expected) == .partiallyCorrect)
        report.check("Unrelated answer: Try Again", verdict("plants are green", expected) == .tryAgain)
        report.check("Short expected answer 'No' graded Correct", verdict("no", "No") == .correct)
        report.check("Short expected answer 'No' rejects 'Yes'", verdict("yes", "No") == .tryAgain)
        let hint = AnswerEvaluationService.localEvaluation(answer: "diagnosis", expectedAnswer: "Diagnosis analysis processes").explanation
        report.check("Hint shows whole words (no 'analysi')", hint.contains("analysis") && hint.contains("processes") && !hint.contains("analysi,"))

        report.section("Quiz Me state")
        let quiz = QuizMeViewModel(recognizer: SpeechRecognitionService(), synthesizer: SpeechSynthesisService())
        quiz.readsQuestionsAutomatically = false
        let questions = sampleGuide(concepts: 0, questions: 3).analysis.practiceQuestions
        let firstGuide = UUID()
        quiz.showGuide(id: firstGuide)
        quiz.select(index: 2, in: questions)
        quiz.showGuide(id: firstGuide)
        report.check("Same guide keeps the current question", quiz.currentIndex == 2)
        quiz.showGuide(id: UUID())
        report.check("New guide restarts at question 1", quiz.currentIndex == 0)
        quiz.next(in: questions)
        quiz.next(in: questions)
        quiz.next(in: questions)
        report.check("Next stops at the last question", quiz.currentIndex == 2)
        quiz.setInputMethod(.typed)
        quiz.answerText = "Answer 3"
        quiz.checkAnswer(in: questions)
        let startedEvaluating = quiz.isEvaluating
        quiz.stopAll()
        report.check("Leaving mid-grade clears the Checking state", startedEvaluating && !quiz.isEvaluating && quiz.canCheckAnswer)
    }

    // MARK: Flashcards

    private static func checkFlashcards(_ report: inout Report) {
        report.section("Flashcards progress math")
        let cards = FlashcardsViewModel(synthesizer: SpeechSynthesisService())
        cards.load(sampleGuide(concepts: 2, questions: 3))
        report.check("All Cards = questions + concepts", cards.deck.count == 5 && cards.cardCount(for: .questions) == 3 && cards.cardCount(for: .keyConcepts) == 2)
        cards.rate(.known)
        report.check("Rating requires flipping first", cards.knownCount == 0 && cards.currentIndex == 0)
        for index in 0..<5 {
            cards.flip()
            cards.rate(index < 3 ? .known : .review)
        }
        let summary = cards.summary
        report.check("Pass completes after the last card", cards.isComplete)
        report.check("Summary: 3 known, 2 review, 60%", summary.known == 3 && summary.review == 2 && abs(summary.fractionKnown - 0.6) < 0.001 && summary.skipped == 0)
        cards.studyReviewCardsAgain()
        report.check("Review round has only Review Again cards", cards.deck.count == 2 && cards.pass == 2 && !cards.isComplete)
        cards.restartAllCards()
        report.check("Restart Deck returns to every card", cards.deck.count == 5 && cards.pass == 1 && cards.currentIndex == 0)
        cards.setFilter(.keyConcepts)
        report.check("Key Concepts filter", cards.deck.count == 2)

        let questionsOnly = FlashcardsViewModel(synthesizer: SpeechSynthesisService())
        questionsOnly.load(sampleGuide(concepts: 0, questions: 1))
        report.check("One-card deck can't shuffle", questionsOnly.deck.count == 1 && !questionsOnly.canShuffle)
        questionsOnly.setFilter(.keyConcepts)
        report.check("Empty filter: no cards, no crash", questionsOnly.deck.isEmpty && questionsOnly.progress == 0 && questionsOnly.currentCard == nil)
        questionsOnly.next()
        report.check("Next on an empty deck does nothing", !questionsOnly.isComplete)
        report.check("Empty summary has no division by zero", FlashcardSessionSummary(cardsInPass: 0, known: 0, review: 0).fractionKnown == 0)
        questionsOnly.load(nil)
        report.check("Cleared guide empties the deck", questionsOnly.deck.isEmpty && !questionsOnly.hasGuide)
    }

    // MARK: Wikipedia (mocked network)

    private static func checkWikipedia(_ report: inout Report) async {
        report.section("Wikipedia (mock network, no live requests)")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [SelfCheckURLProtocol.self]
        let service = WikipediaService(session: URLSession(configuration: configuration))
        SelfCheckURLProtocol.reset()

        let article = #"{"query":{"pages":[{"pageid":1,"index":1,"title":"Mitochondrion","extract":"The mitochondrion is an organelle.","fullurl":"https://en.wikipedia.org/wiki/Mitochondrion"}]}}"#
        SelfCheckURLProtocol.respond(status: 200, body: article)
        let first = try? await service.lookUp(concept: "Mitochondria")
        let second = try? await service.lookUp(concept: "  MITOCHONDRIA ")
        let cached = await service.cachedResult(for: "mitochondria")
        if case .article(let best, _) = first?.outcome {
            report.check("Valid result parsed", best.title == "Mitochondrion" && best.summary != nil)
        } else {
            report.check("Valid result parsed", false)
        }
        report.check("Cached lookup makes no second request", SelfCheckURLProtocol.requestCount == 1 && second == first && cached == first)
        report.check("User-Agent includes contact info", SelfCheckURLProtocol.lastUserAgent?.contains("github.com") == true)

        let ambiguous = #"{"query":{"pages":[{"pageid":2,"index":1,"title":"Mercury","extract":"Mercury may refer to:","pageprops":{"disambiguation":""}},{"pageid":3,"index":2,"title":"Mercury (planet)","extract":"Mercury is a planet."}]}}"#
        SelfCheckURLProtocol.respond(status: 200, body: ambiguous)
        if case .ambiguous(let options) = (try? await service.lookUp(concept: "Mercury"))?.outcome {
            report.check("Several meanings offers real articles only", options.map(\.title) == ["Mercury (planet)"])
        } else {
            report.check("Several meanings offers real articles only", false)
        }
        let onlyDisambiguation = #"{"query":{"pages":[{"pageid":4,"index":1,"title":"Saturn (disambiguation)","extract":"Saturn may refer to:","pageprops":{"disambiguation":""}}]}}"#
        SelfCheckURLProtocol.respond(status: 200, body: onlyDisambiguation)
        report.check("Only a disambiguation page: No Results", (try? await service.lookUp(concept: "Saturn"))?.outcome == .noResults)
        SelfCheckURLProtocol.respond(status: 200, body: #"{"batchcomplete":true}"#)
        report.check("Nothing found: No Results", (try? await service.lookUp(concept: "Qwxzv"))?.outcome == .noResults)

        func error(for concept: String) async -> Error? {
            do { _ = try await service.lookUp(concept: concept); return nil } catch { return error }
        }
        SelfCheckURLProtocol.respond(status: 503, body: "")
        let countBefore = SelfCheckURLProtocol.requestCount
        report.check("HTTP error reported", (await error(for: "Enzyme")) as? WikipediaError == .httpStatus(503))
        _ = await error(for: "Enzyme")
        report.check("Errors aren't cached (Try Again retries)", SelfCheckURLProtocol.requestCount == countBefore + 2)
        SelfCheckURLProtocol.respond(status: 200, body: "<html>Server error</html>")
        report.check("Malformed response reported", (await error(for: "Ribosome")) as? WikipediaError == .unreadableResponse)
        SelfCheckURLProtocol.fail(with: URLError(.timedOut))
        report.check("Timeout reported", (await error(for: "Osmosis")) as? WikipediaError == .timedOut)
        SelfCheckURLProtocol.fail(with: URLError(.notConnectedToInternet))
        report.check("Offline reported", (await error(for: "Osmosis")) as? WikipediaError == .offline)

        SelfCheckURLProtocol.respond(status: 200, body: article)
        let task = Task { try await service.lookUp(concept: "Diffusion") }
        task.cancel()
        let cancelled = await task.result
        let cancelledCached = await service.cachedResult(for: "Diffusion")
        if case .failure(let failure) = cancelled {
            report.check("Cancellation is not an error message and isn't cached", failure is CancellationError && cancelledCached == nil)
        } else {
            report.check("Cancellation is not an error message and isn't cached", false)
        }

        // Add to Notes: explicit, attributed, and never duplicated (also after a "relaunch").
        let notes = NotesViewModel(store: InMemoryNoteStore())
        let concept = StudyConcept(name: "Mitochondria", explanation: "Makes ATP.", origin: .keyConcepts)
        let saved = WikipediaArticle(id: 1, title: "Mitochondrion", shortDescription: nil, summary: "The mitochondrion is an organelle.", url: URL(string: "https://en.wikipedia.org/wiki/Mitochondrion"))
        report.check("Looking up a concept never adds a note", notes.notes.isEmpty)
        let enrichment = ConceptEnrichmentViewModel(concept: concept, service: service)
        enrichment.saveAsNote(saved, to: notes)
        enrichment.saveAsNote(saved, to: notes)
        ConceptEnrichmentViewModel(concept: concept, service: service).saveAsNote(saved, to: notes)
        let wikiNote = notes.notes.first
        report.check("Add to Notes saves once (duplicate protection)", notes.notes.count == 1)
        report.check("Saved note is attributed", wikiNote?.source == .wikipedia && wikiNote?.externalSource?.url == saved.url && wikiNote?.body.contains("Creative Commons") == true)
    }

    // MARK: Import (temporary files only)

    private static func checkImport(_ report: inout Report) async {
        report.section("Import failure handling")
        let folder = FileManager.default.temporaryDirectory.appending(path: "StudyLensSelfChecks-\(UUID().uuidString)")
        defer { try? FileManager.default.removeItem(at: folder) }
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)

        func write(_ name: String, _ data: Data) -> URL {
            let url = folder.appending(path: name)
            try? data.write(to: url)
            return url
        }
        func importResult(_ url: URL) async -> Result<ImportedDocument, Error> {
            do { return .success(try await DocumentImportService().importDocument(at: url) { _ in }) } catch { return .failure(error) }
        }
        func errorText(_ result: Result<ImportedDocument, Error>) -> String {
            if case .failure(let error) = result { return error.localizedDescription }
            return ""
        }

        report.check("Detects every supported type", ["a.txt", "a.md", "a.csv", "a.pdf", "a.png", "a.jpeg", "a.HEIC", "a.docx", "a.pptx", "a.xlsx"]
            .allSatisfy { ImportFileKind.detect(url: URL(filePath: $0)) != nil })
        report.check("Rejects unsupported types", ImportFileKind.detect(url: URL(filePath: "a.rtf")) == nil && ImportFileKind.detect(url: URL(filePath: "a.zip")) == nil)

        let rtf = await importResult(write("notes.rtf", Data("{\\rtf1 hi}".utf8)))
        report.check("Unsupported file gives a named error", errorText(rtf).contains("notes.rtf"))
        let empty = await importResult(write("empty.txt", Data()))
        report.check("Empty text file fails with a message", errorText(empty).contains("empty.txt"))
        let latin = await importResult(write("latin.txt", Data([0x43, 0x61, 0x66, 0xE9])))  // "Café" in Windows-1252
        report.check("Non-UTF-8 text is decoded", (try? latin.get().text) == "Café")
        let csv = await importResult(write("grades.csv", Data("Name,Score\n\"Lee, A\",90\n".utf8)))
        report.check("CSV keeps quoted commas", (try? csv.get().text)?.contains("Lee, A") == true)
        let garbage = await importResult(write("broken.docx", Data("not a zip".utf8)))
        report.check("Corrupt DOCX fails with its file name", errorText(garbage).contains("broken.docx"))

        let badXML = makeZip(["word/document.xml": "<w:document><w:body>"])
        report.check("Malformed Office XML names the real file", errorText(await importResult(write("bad.docx", badXML))).contains("bad.docx"))

        let textBox = """
            <w:document xmlns:w="w" xmlns:mc="mc"><w:body><w:p><w:r><w:t>Intro</w:t></w:r>\
            <w:r><mc:AlternateContent><mc:Choice><w:txbxContent><w:p><w:r><w:t>BoxText</w:t></w:r></w:p></w:txbxContent></mc:Choice>\
            <mc:Fallback><w:txbxContent><w:p><w:r><w:t>BoxText</w:t></w:r></w:p></w:txbxContent></mc:Fallback></mc:AlternateContent></w:r></w:p></w:body></w:document>
            """
        let docx = await importResult(write("textbox.docx", makeZip(["word/document.xml": textBox])))
        let docxText = (try? docx.get().text) ?? ""
        report.check("DOCX text box imported once", docxText.components(separatedBy: "BoxText").count == 2)

        let workbook = makeZip([
            "xl/workbook.xml": #"<workbook xmlns:r="r"><sheets><sheet name="Grades" r:id="rId1"/></sheets></workbook>"#,
            "xl/_rels/workbook.xml.rels": #"<Relationships><Relationship Id="rId1" Target="worksheets/sheet1.xml"/></Relationships>"#,
            "xl/worksheets/sheet1.xml": #"<worksheet><sheetData><row><c r="A1" t="inlineStr"><is><t>Biology</t></is></c><c r="AAAAAAAAAAAAAAAAAAAA1"><v>7</v></c></row></sheetData></worksheet>"#
        ])
        let xlsx = await importResult(write("huge-column.xlsx", workbook))
        report.check("XLSX with an absurd column reference doesn't crash", (try? xlsx.get().text)?.contains("Biology") == true)
    }

    /// A minimal ZIP writer (stored entries, no compression) for building Office files in memory.
    private static func makeZip(_ files: [String: String]) -> Data {
        func le16(_ value: Int) -> [UInt8] { [UInt8(value & 0xFF), UInt8((value >> 8) & 0xFF)] }
        func le32(_ value: Int) -> [UInt8] { le16(value & 0xFFFF) + le16((value >> 16) & 0xFFFF) }
        var body: [UInt8] = []
        var directory: [UInt8] = []
        for (name, text) in files.sorted(by: { $0.key < $1.key }) {
            let nameBytes = Array(name.utf8)
            let content = Array(text.utf8)
            let offset = body.count
            body += le32(0x04034b50) + le16(20) + le16(0) + le16(0) + le16(0) + le16(0) + le32(0)
                + le32(content.count) + le32(content.count) + le16(nameBytes.count) + le16(0) + nameBytes + content
            directory += le32(0x02014b50) + le16(20) + le16(20) + le16(0) + le16(0) + le16(0) + le16(0) + le32(0)
                + le32(content.count) + le32(content.count) + le16(nameBytes.count) + le16(0) + le16(0)
                + le16(0) + le16(0) + le32(0) + le32(offset) + nameBytes
        }
        let end = le32(0x06054b50) + le16(0) + le16(0) + le16(files.count) + le16(files.count)
            + le32(directory.count) + le32(body.count) + le16(0)
        return Data(body + directory + end)
    }

    // MARK: Export

    private static func checkExport(_ report: inout Report) {
        report.section("Export text")
        var wiki = note("Mitochondrion", "Edited body without the attribution block.", .wikipedia, minutes: 0)
        wiki.externalSource = ExternalSourceInfo(articleTitle: "Mitochondrion", url: URL(string: "https://en.wikipedia.org/wiki/Mitochondrion"))
        var imported = note("Lecture 4", "Slides text", .imported, minutes: 1)
        imported.importInfo = ImportedFileInfo(filename: "Lecture 4.pptx", kind: .powerPoint, unitCount: 8)

        let markdown = NoteExporter.document(for: [wiki], format: .markdown, exportedAt: baseDate)
        report.check("Markdown: title, source, date", markdown.hasPrefix("# Mitochondrion") && markdown.contains("**Source:** Wikipedia") && markdown.contains("**Created:**"))
        report.check("Markdown keeps the Wikipedia link even after the body was edited", markdown.contains("https://en.wikipedia.org/wiki/Mitochondrion"))
        let text = NoteExporter.document(for: [imported], format: .plainText, exportedAt: baseDate)
        report.check("Plain text keeps the original file name", text.contains("Imported from: Lecture 4.pptx") && text.contains("Created:"))
        let several = NoteExporter.document(for: [wiki, imported], format: .markdown, exportedAt: baseDate)
        report.check("Multi-note export numbers each note", several.contains("## 1. Mitochondrion") && several.contains("## 2. Lecture 4") && several.contains("2 notes"))
        let fileName = ExportFileWriter.sanitizedFileName("Unit 3: Cells/Energy")
        report.check("Export file names are sanitized", !fileName.contains("/") && !fileName.contains(":") && !fileName.isEmpty)
    }

    // MARK: Brain Map

    private static func checkBrainMap(_ report: inout Report) {
        report.section("Brain Map graph, layout, and export")
        let map = BrainMap(
            centralTopic: "Cell Energy",
            concepts: ["Cellular respiration", "Glucose", "Cellular respiration"],
            relationships: [
                ConceptRelationship(source: "Glucose", target: "Cellular respiration", relationship: "is broken down in"),
                ConceptRelationship(source: "Ion", target: "Glucose", relationship: "moves with"),
                ConceptRelationship(source: "Glucose", target: "Glucose", relationship: "self loop"),
                ConceptRelationship(source: "Glucose", target: "Cellular respiration", relationship: "duplicate")
            ]
        )
        let graph = BrainMapGraph(brainMap: map, keyConcepts: [KeyConcept(name: "Glucose", explanation: "A sugar.")])
        let titles = Set(graph.nodes.map(\.title))
        report.check("Every concept appears once", titles == ["Cell Energy", "Cellular respiration", "Glucose", "Ion"])
        report.check("'Ion' isn't merged into 'respiration'", graph.edges.contains { $0.label == "moves with" && $0.sourceID != $0.targetID })
        report.check("Self-loops and duplicate edges dropped", graph.edges.count == 2)

        let layout = BrainMapLayout(graph: graph, availableSize: .zero)
        let bounds = CGRect(origin: .zero, size: layout.canvasSize)
        report.check("Every node has a finite position inside the canvas", graph.nodes.allSatisfy { node in
            layout.positions[node.id].map { $0.x.isFinite && $0.y.isFinite && bounds.contains($0) } ?? false
        })
        report.check("Edge labels stay inside the exported canvas", layout.edgeLines.values.allSatisfy { bounds.insetBy(dx: 5, dy: 9).contains($0.labelPoint) })
        let emptyLayout = BrainMapLayout(graph: BrainMapGraph(brainMap: BrainMap(centralTopic: "Solo", concepts: [], relationships: []), keyConcepts: []), availableSize: .zero)
        report.check("Single-node map lays out safely", emptyLayout.canvasSize.width > 0 && emptyLayout.positions.count == 1)
        let outline = BrainMapExporter.outline(for: graph, markdown: true, exportedAt: baseDate)
        report.check("Markdown outline lists every concept", ["Cell Energy", "Cellular respiration", "Glucose", "Ion"].allSatisfy(outline.contains))
    }
}

/// Answers every request made through the self-check `URLSession` without touching the network,
/// and counts requests so cache behavior can be verified.
nonisolated final class SelfCheckURLProtocol: URLProtocol, @unchecked Sendable {
    private enum Reply {
        case response(status: Int, body: Data)
        case failure(URLError)
    }

    nonisolated(unsafe) private static var reply = Reply.failure(URLError(.unknown))
    nonisolated(unsafe) private(set) static var requestCount = 0
    nonisolated(unsafe) private(set) static var lastUserAgent: String?

    static func reset() {
        requestCount = 0
        lastUserAgent = nil
    }

    static func respond(status: Int, body: String) {
        reply = .response(status: status, body: Data(body.utf8))
    }

    static func fail(with error: URLError) {
        reply = .failure(error)
    }

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        Self.requestCount += 1
        Self.lastUserAgent = request.value(forHTTPHeaderField: "User-Agent")
        switch Self.reply {
        case .response(let status, let body):
            guard let url = request.url,
                  let response = HTTPURLResponse(url: url, statusCode: status, httpVersion: "HTTP/1.1", headerFields: nil) else {
                client?.urlProtocol(self, didFailWithError: URLError(.badURL))
                return
            }
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: body)
            client?.urlProtocolDidFinishLoading(self)
        case .failure(let error):
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
#endif
