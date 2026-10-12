import Foundation

/// Extracts study text from Office Open XML documents: Word (DOCX), PowerPoint (PPTX), and
/// Excel (XLSX).
///
/// Pipeline for all three:  file bytes → `ZipArchiveReader` (Compression framework inflate)
///                          → XML parts → `XMLNode` tree (Foundation `XMLParser`) → readable text.
///
/// Apple's only built-in DOCX reader (`NSAttributedString` with `.officeOpenXML`) exists on macOS
/// but not iOS, and there's no built-in PPTX or XLSX reader on either platform, so StudyLens reads
/// the documented XML directly. That keeps behaviour identical on iPhone, iPad, and Mac.
nonisolated enum OfficeDocumentExtractor {

    // MARK: - Word (DOCX)

    /// Reads `word/document.xml` body content in order: headings become Markdown-style `#` lines,
    /// list items get bullets, and table rows are written as `cell | cell | cell`.
    static func extractWord(from data: Data) throws -> (text: String, paragraphCount: Int) {
        let archive = try ZipArchiveReader(data: data)
        let root = try XMLNode.parse(try archive.data(for: "word/document.xml"))
        guard let body = root.first("body") else { return ("", 0) }

        var lines: [String] = []
        appendWordBlocks(body.children, to: &lines)
        let paragraphs = lines.filter { !$0.isEmpty }
        return (paragraphs.joined(separator: "\n"), paragraphs.count)
    }

    private static func appendWordBlocks(_ nodes: [XMLNode], to lines: inout [String]) {
        for node in nodes {
            switch node.name {
            case "p":
                lines.append(wordParagraph(node))
            case "tbl":
                // One line per table row; nested paragraphs in a cell are joined with spaces.
                for row in node.children("tr") {
                    let cells = row.children("tc").map { cell in
                        cell.all("p").map(wordRunText).joined(separator: " ").trimmingCharacters(in: .whitespaces)
                    }
                    if cells.contains(where: { !$0.isEmpty }) {
                        lines.append(cells.joined(separator: " | "))
                    }
                }
            case "sdt":
                // Content controls (e.g. a cover page or table of contents) wrap normal blocks.
                if let content = node.child("sdtContent") { appendWordBlocks(content.children, to: &lines) }
            default:
                continue
            }
        }
    }

    private static func wordParagraph(_ paragraph: XMLNode) -> String {
        let text = wordRunText(paragraph).trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return "" }
        let properties = paragraph.child("pPr")

        // Headings: built-in style IDs are "Heading1"…"Heading9" and "Title"/"Subtitle".
        // (Localized Word versions may use other IDs, so outline level is checked too.)
        let style = properties?.child("pStyle")?.attributes["w:val"]?.lowercased() ?? ""
        if style == "title" { return "# \(text)" }
        if style == "subtitle" { return "## \(text)" }
        if style.contains("heading"), let level = Int(style.filter(\.isNumber)), (1...6).contains(level) {
            return String(repeating: "#", count: level) + " " + text
        }
        if let outline = properties?.child("outlineLvl")?.attributes["w:val"].flatMap(Int.init), outline < 6 {
            return String(repeating: "#", count: outline + 1) + " " + text
        }
        if properties?.child("numPr") != nil || style.contains("list") {
            return "• \(text)"
        }
        return text
    }

    /// Concatenates the visible text of a paragraph in order. Deleted revisions (`w:del`) and
    /// field instructions are skipped because they never appear on the page.
    private static func wordRunText(_ node: XMLNode) -> String {
        var result = ""
        for child in node.children {
            switch child.name {
            case "t": result += child.text
            case "tab": result += "\t"
            case "br", "cr": result += "\n"
            case "del", "pPr", "rPr", "instrText", "delText": continue
            default: result += wordRunText(child)
            }
        }
        return result
    }

    // MARK: - PowerPoint (PPTX)

    /// Reads slides in presentation order (from `ppt/presentation.xml`, not file names, since
    /// slides can be reordered), keeping a clear boundary and title for each slide plus any
    /// speaker notes.
    static func extractPowerPoint(from data: Data, progress: (Int, Int) -> Void) throws -> (text: String, slideCount: Int) {
        let archive = try ZipArchiveReader(data: data)
        let presentation = try XMLNode.parse(try archive.data(for: "ppt/presentation.xml"))
        let relationships = try OOXMLRelationship.read("ppt/_rels/presentation.xml.rels", in: archive, baseDirectory: "ppt")

        let slidePaths = presentation.all("sldId").compactMap { slide in
            slide.relationshipAttribute().flatMap { relationships[$0]?.path }
        }

        var sections: [String] = []
        for (index, path) in slidePaths.enumerated() {
            progress(index + 1, slidePaths.count)
            guard archive.contains(path) else { continue }
            let slide = try XMLNode.parse(try archive.data(for: path))
            let shapes = slideShapes(in: slide)

            let title = shapes.first { $0.isTitle }?.paragraphs.joined(separator: " ")
            var lines = ["--- Slide \(index + 1)\(title.map { ": \($0)" } ?? "") ---"]
            for shape in shapes where !shape.isTitle {
                lines.append(contentsOf: shape.paragraphs.map { "• \($0)" })
            }
            if shapes.isEmpty {
                lines.append("(No text on this slide — it may contain only images.)")
            }

            // Speaker notes live in a separate part linked from the slide's own relationships.
            let directory = (path as NSString).deletingLastPathComponent
            let slideRelationships = try OOXMLRelationship.read(
                "\(directory)/_rels/\((path as NSString).lastPathComponent).rels",
                in: archive, baseDirectory: directory
            )
            if let notesPath = slideRelationships.values.first(where: { $0.type.hasSuffix("/notesSlide") })?.path,
               archive.contains(notesPath) {
                let notes = try XMLNode.parse(try archive.data(for: notesPath))
                let noteText = slideShapes(in: notes)
                    .filter { $0.placeholderType == "body" }
                    .flatMap(\.paragraphs)
                    .joined(separator: " ")
                if !noteText.isEmpty { lines.append("Speaker notes: \(noteText)") }
            }
            sections.append(lines.joined(separator: "\n"))
        }
        return (sections.joined(separator: "\n\n"), slidePaths.count)
    }

    private struct SlideShape {
        var placeholderType: String?
        var paragraphs: [String]
        var isTitle: Bool { placeholderType == "title" || placeholderType == "ctrTitle" }
    }

    /// Walks a slide's shape tree in drawing order, including grouped shapes and tables.
    private static func slideShapes(in slide: XMLNode) -> [SlideShape] {
        guard let tree = slide.first("spTree") else { return [] }
        var shapes: [SlideShape] = []

        func visit(_ node: XMLNode) {
            for child in node.children {
                switch child.name {
                case "sp":
                    let type = child.first("ph").map { $0.attributes["type"] ?? "body" }
                    // Slide numbers, dates, and footers aren't study content.
                    if let type, ["sldNum", "dt", "ftr", "sldImg", "hdr"].contains(type) { continue }
                    let paragraphs = child.first("txBody").map(drawingParagraphs) ?? []
                    if !paragraphs.isEmpty { shapes.append(SlideShape(placeholderType: type, paragraphs: paragraphs)) }
                case "graphicFrame":
                    if let table = child.first("tbl") {
                        let rows = table.children("tr").map { row in
                            row.children("tc").map { drawingParagraphs($0).joined(separator: " ") }.joined(separator: " | ")
                        }
                        shapes.append(SlideShape(placeholderType: nil, paragraphs: rows.filter { !$0.isEmpty }))
                    }
                case "grpSp":
                    visit(child)
                default:
                    continue
                }
            }
        }
        visit(tree)
        return shapes
    }

    /// DrawingML paragraphs (`a:p`) → text runs (`a:t`) with line breaks (`a:br`).
    private static func drawingParagraphs(_ container: XMLNode) -> [String] {
        container.all("p").compactMap { paragraph in
            var text = ""
            for child in paragraph.children {
                switch child.name {
                case "r", "fld": text += child.child("t")?.text ?? ""
                case "br": text += " "
                default: continue
                }
            }
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty ? nil : trimmed
        }
    }

    // MARK: - Excel (XLSX)

    /// Reads every visible worksheet in workbook order. Each sheet starts with its name, then its
    /// rows are formatted by `TabularTextFormatter` (header-labeled records when possible).
    static func extractExcel(from data: Data, progress: (Int, Int) -> Void) throws -> (text: String, sheetCount: Int, notices: [String]) {
        let archive = try ZipArchiveReader(data: data)
        let workbook = try XMLNode.parse(try archive.data(for: "xl/workbook.xml"))
        let relationships = try OOXMLRelationship.read("xl/_rels/workbook.xml.rels", in: archive, baseDirectory: "xl")
        let sharedStrings = try readSharedStrings(from: archive)
        // Dates and percentages are plain numbers in the XML; their meaning lives in the styles.
        let styles = try CellStyles(archive: archive,
                                    uses1904Dates: workbook.first("workbookPr")?.attributes["date1904"].map { $0 == "1" || $0 == "true" } ?? false)

        let sheets = workbook.all("sheet")
        var sections: [String] = []
        var notices: [String] = []
        var hiddenCount = 0

        for (index, sheet) in sheets.enumerated() {
            progress(index + 1, sheets.count)
            let name = sheet.attributes["name"] ?? "Sheet \(index + 1)"
            if let state = sheet.attributes["state"], state != "visible" {
                hiddenCount += 1
                continue
            }
            guard let path = sheet.relationshipAttribute().flatMap({ relationships[$0]?.path }),
                  archive.contains(path) else { continue }

            let rows = try readWorksheetRows(try XMLNode.parse(try archive.data(for: path)), sharedStrings: sharedStrings, styles: styles)
            let formatted = TabularTextFormatter.format(rows: rows)
            if formatted.text.isEmpty {
                sections.append("=== Sheet: \(name) ===\n(empty)")
            } else {
                sections.append("=== Sheet: \(name) (\(formatted.rowCount) rows) ===\n\(formatted.text)")
            }
        }
        if hiddenCount > 0 {
            notices.append("\(hiddenCount) hidden \(hiddenCount == 1 ? "sheet was" : "sheets were") skipped.")
        }
        return (sections.joined(separator: "\n\n"), sheets.count - hiddenCount, notices)
    }

    /// Text cells usually store an index into `xl/sharedStrings.xml` rather than the text itself.
    private static func readSharedStrings(from archive: ZipArchiveReader) throws -> [String] {
        guard archive.contains("xl/sharedStrings.xml") else { return [] }
        let root = try XMLNode.parse(try archive.data(for: "xl/sharedStrings.xml"))
        return root.children("si").map(richText)
    }

    /// The text of a string item, skipping phonetic guides (`rPh`) used in East Asian workbooks.
    private static func richText(_ item: XMLNode) -> String {
        if let plain = item.child("t") { return plain.text }
        return item.children("r").compactMap { $0.child("t")?.text }.joined()
    }

    private static let maxColumns = 100

    /// Converts `<row><c r="B2" t="s"><v>3</v></c></row>` cells into a dense grid of strings.
    private static func readWorksheetRows(_ sheet: XMLNode, sharedStrings: [String], styles: CellStyles) throws -> [[String]] {
        guard let sheetData = sheet.first("sheetData") else { return [] }
        var rows: [[String]] = []
        for row in sheetData.children("row") {
            var cells: [String] = []
            for cell in row.children("c") {
                let column = cell.attributes["r"].map(columnIndex) ?? cells.count
                // Far-right helper cells (e.g. column XFD) would create huge, mostly empty rows.
                guard column < maxColumns else { continue }
                let value = cellValue(cell, sharedStrings: sharedStrings, styles: styles)
                if column >= cells.count {
                    // Empty cells are omitted from the XML, so pad up to this column.
                    cells.append(contentsOf: Array(repeating: "", count: column - cells.count + 1))
                }
                cells[column] = value
            }
            rows.append(cells)
            if rows.count > TabularTextFormatter.defaultMaxRows + 1 { break }
        }
        return rows
    }

    private static func cellValue(_ cell: XMLNode, sharedStrings: [String], styles: CellStyles) -> String {
        let raw = cell.child("v")?.text ?? ""
        switch cell.attributes["t"] {
        case "s":
            return Int(raw).flatMap { sharedStrings.indices.contains($0) ? sharedStrings[$0] : nil } ?? ""
        case "inlineStr":
            return cell.child("is").map(richText) ?? ""
        case "b":
            return raw == "1" ? "TRUE" : "FALSE"
        case "e":
            return "" // Formula errors such as #DIV/0! carry no study content.
        case "str":
            return raw // Cached result of a text formula.
        default:
            let styleIndex = cell.attributes["s"].flatMap(Int.init) ?? 0
            return styles.format(raw, styleIndex: styleIndex) ?? formatNumber(raw)
        }
    }

    /// Excel stores numbers in full binary precision ("0.30000000000000004"); tidy them for reading.
    private static func formatNumber(_ raw: String) -> String {
        guard let number = Double(raw) else { return raw }
        if number == number.rounded(), abs(number) < 1e15 { return String(Int64(number)) }
        return number.formatted(.number.precision(.significantDigits(1...10)).grouping(.never))
    }

    /// The number formats that change how a numeric cell should read: dates (stored as serial day
    /// numbers, e.g. 45389 = 2024-04-07) and percentages (0.03625 = 3.625%). Read from
    /// `xl/styles.xml`: each cell's `s` attribute indexes `cellXfs`, whose `numFmtId` is either a
    /// built-in format or a custom one declared in `numFmts`.
    private struct CellStyles {
        private var dateStyles: Set<Int> = []
        private var percentStyles: Set<Int> = []
        private let uses1904Dates: Bool

        init(archive: ZipArchiveReader, uses1904Dates: Bool) throws {
            self.uses1904Dates = uses1904Dates
            guard archive.contains("xl/styles.xml") else { return }
            let root = try XMLNode.parse(try archive.data(for: "xl/styles.xml"))

            var customFormats: [Int: String] = [:]
            for format in root.child("numFmts")?.children("numFmt") ?? [] {
                if let id = format.attributes["numFmtId"].flatMap(Int.init), let code = format.attributes["formatCode"] {
                    customFormats[id] = code
                }
            }
            // Built-in date/time format IDs from the ECMA-376 spec.
            let builtInDates = Set(14...22).union(27...36).union(45...47).union(50...58)
            let builtInPercents: Set<Int> = [9, 10]

            for (index, xf) in (root.child("cellXfs")?.children("xf") ?? []).enumerated() {
                guard let id = xf.attributes["numFmtId"].flatMap(Int.init) else { continue }
                if let code = customFormats[id] {
                    // Ignore quoted literals and [color]/[locale] sections before looking at tokens.
                    let tokens = code.replacingOccurrences(of: "\"[^\"]*\"|\\[[^\\]]*\\]", with: "", options: .regularExpression).lowercased()
                    if tokens.contains("%") { percentStyles.insert(index) }
                    else if tokens.contains("y") || tokens.contains("d") { dateStyles.insert(index) }
                } else if builtInDates.contains(id) {
                    dateStyles.insert(index)
                } else if builtInPercents.contains(id) {
                    percentStyles.insert(index)
                }
            }
        }

        /// A readable value for date/percent cells, or nil to use the plain number.
        func format(_ raw: String, styleIndex: Int) -> String? {
            guard let number = Double(raw) else { return nil }
            if dateStyles.contains(styleIndex) {
                // Serial days since 1899-12-30 (or 1904-01-01 for Mac-era workbooks).
                let unixDays = number - (uses1904Dates ? 24_107 : 25_569)
                let date = Date(timeIntervalSince1970: unixDays * 86_400)
                var style = Date.ISO8601FormatStyle(timeZone: .gmt).year().month().day()
                if number != number.rounded() { style = style.time(includingFractionalSeconds: false) }
                return date.formatted(style)
            }
            if percentStyles.contains(styleIndex) {
                return (number * 100).formatted(.number.precision(.significantDigits(1...6)).grouping(.never)) + "%"
            }
            return nil
        }
    }

    /// "A" → 0, "Z" → 25, "AA" → 26, from a reference like "AA12".
    private static func columnIndex(_ reference: String) -> Int {
        var index = 0
        for scalar in reference.unicodeScalars {
            guard (65...90).contains(scalar.value) || (97...122).contains(scalar.value) else { break }
            index = index * 26 + Int((scalar.value & 0xDF) - 64)
        }
        return max(index - 1, 0)
    }
}
