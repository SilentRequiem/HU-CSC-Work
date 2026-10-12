import Foundation

/// Turns spreadsheet-like rows (from CSV files and Excel worksheets) into readable text that
/// keeps enough structure for Foundation Models to understand it.
///
/// When the first row looks like column headings, each later row becomes a labeled record:
///     Row 2: Term: Mitosis; Definition: Cell division producing two identical cells
/// Otherwise rows are written as pipe-separated values:
///     Mitosis | Cell division producing two identical cells
nonisolated enum TabularTextFormatter {
    static let defaultMaxRows = 1_000

    /// - Returns: The formatted text and the number of data rows that were written.
    static func format(rows rawRows: [[String]], maxRows: Int = defaultMaxRows) -> (text: String, rowCount: Int) {
        let rows = rawRows
            .map { $0.map(clean) }
            .map(trimTrailingEmptyCells)
            .filter { row in row.contains { !$0.isEmpty } }
        guard let first = rows.first else { return ("", 0) }

        var lines: [String] = []
        var dataRows = rows
        let headers: [String]?
        if looksLikeHeader(first), rows.count > 1 {
            headers = first
            dataRows = Array(rows.dropFirst())
            lines.append("Columns: " + first.filter { !$0.isEmpty }.joined(separator: " | "))
        } else {
            headers = nil
        }

        for (index, row) in dataRows.prefix(maxRows).enumerated() {
            if let headers {
                // Pair each value with its column heading, skipping blank cells.
                let fields = row.enumerated().compactMap { column, value -> String? in
                    guard !value.isEmpty else { return nil }
                    let heading = column < headers.count && !headers[column].isEmpty ? headers[column] : "Column \(column + 1)"
                    return "\(heading): \(value)"
                }
                lines.append("Row \(index + 1): " + fields.joined(separator: "; "))
            } else {
                lines.append(row.joined(separator: " | "))
            }
        }

        if dataRows.count > maxRows {
            lines.append("[\(dataRows.count - maxRows) more rows not imported]")
        }
        return (lines.joined(separator: "\n"), min(dataRows.count, maxRows))
    }

    /// A header row has at least two cells and no purely numeric cells.
    private static func looksLikeHeader(_ row: [String]) -> Bool {
        let filled = row.filter { !$0.isEmpty }
        return filled.count >= 2 && !filled.contains { Double($0.replacingOccurrences(of: ",", with: "")) != nil }
    }

    private static func clean(_ value: String) -> String {
        value
            .replacingOccurrences(of: "\r\n", with: " ")
            .replacingOccurrences(of: "\n", with: " ")
            .trimmingCharacters(in: .whitespaces)
    }

    private static func trimTrailingEmptyCells(_ row: [String]) -> [String] {
        var row = row
        while row.last?.isEmpty == true { row.removeLast() }
        return row
    }
}

/// RFC 4180-style CSV parsing: quoted fields, escaped quotes (`""`), and line breaks inside quotes.
nonisolated enum CSVParser {
    static func parse(_ text: String) -> [[String]] {
        let delimiter = detectDelimiter(in: text)
        var rows: [[String]] = []
        var row: [String] = []
        var field = ""
        var inQuotes = false
        var iterator = text.makeIterator()
        var pending: Character? = nil

        func nextCharacter() -> Character? {
            if let character = pending { pending = nil; return character }
            return iterator.next()
        }

        while let character = nextCharacter() {
            if inQuotes {
                if character == "\"" {
                    // A doubled quote is a literal quote; a single one closes the field.
                    if let following = nextCharacter() {
                        if following == "\"" { field.append("\"") } else { inQuotes = false; pending = following }
                    } else {
                        inQuotes = false
                    }
                } else {
                    field.append(character)
                }
            } else if character == "\"" && field.isEmpty {
                inQuotes = true
            } else if character == delimiter {
                row.append(field)
                field = ""
            } else if character == "\n" || character == "\r\n" || character == "\r" {
                row.append(field)
                rows.append(row)
                row = []
                field = ""
            } else {
                field.append(character)
            }
        }
        if !field.isEmpty || !row.isEmpty {
            row.append(field)
            rows.append(row)
        }
        return rows
    }

    /// Some regions export "CSV" with semicolons; pick whichever separator the first line uses most.
    private static func detectDelimiter(in text: String) -> Character {
        let firstLine = text.prefix { $0 != "\n" && $0 != "\r\n" && $0 != "\r" }
        let candidates: [Character] = [",", ";", "\t"]
        return candidates.max { a, b in firstLine.count(where: { $0 == a }) < firstLine.count(where: { $0 == b }) } ?? ","
    }
}
