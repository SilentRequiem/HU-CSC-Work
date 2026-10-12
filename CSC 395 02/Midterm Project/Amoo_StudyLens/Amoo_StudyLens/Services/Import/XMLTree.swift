import Foundation

/// A tiny in-memory XML tree built with Foundation's `XMLParser`.
///
/// Office Open XML parts are small enough to hold in memory, and walking a tree is far easier to
/// read (and explain) than a streaming state machine per format. Element names are stored
/// *without* their namespace prefix (`w:p` → `p`, `a:t` → `t`) because each part uses one
/// vocabulary, while attribute keys keep their prefix (`r:id`) because Office reuses local names
/// across namespaces (`<p:sldId id="256" r:id="rId2"/>`).
nonisolated final class XMLNode {
    let name: String
    let attributes: [String: String]
    fileprivate(set) var children: [XMLNode] = []
    /// Character data that appears directly inside this element.
    fileprivate(set) var text = ""

    init(name: String, attributes: [String: String]) {
        self.name = name
        self.attributes = attributes
    }

    /// The first direct child with the given local name.
    func child(_ name: String) -> XMLNode? {
        children.first { $0.name == name }
    }

    func children(_ name: String) -> [XMLNode] {
        children.filter { $0.name == name }
    }

    /// The first descendant (depth-first, document order) with the given local name.
    func first(_ name: String) -> XMLNode? {
        for child in children {
            if child.name == name { return child }
            if let match = child.first(name) { return match }
        }
        return nil
    }

    /// Every descendant with the given local name, in document order.
    func all(_ name: String) -> [XMLNode] {
        var result: [XMLNode] = []
        for child in children {
            if child.name == name { result.append(child) }
            result.append(contentsOf: child.all(name))
        }
        return result
    }

    /// The value of a relationship-id attribute such as `r:id` or `r:embed`, whatever its prefix.
    func relationshipAttribute(_ localName: String = "id") -> String? {
        attributes.first { $0.key.hasSuffix(":\(localName)") }?.value
    }

    // MARK: Parsing

    static func parse(_ data: Data) throws -> XMLNode {
        let builder = Builder()
        let parser = XMLParser(data: data)
        parser.delegate = builder
        // Office documents never need external entities; refusing them avoids XXE-style surprises.
        parser.shouldResolveExternalEntities = false
        guard parser.parse(), let root = builder.root else {
            throw ImportError.unreadable(
                filename: "document",
                reason: parser.parserError?.localizedDescription ?? "Its XML content couldn't be parsed."
            )
        }
        return root
    }

    private final class Builder: NSObject, XMLParserDelegate {
        var root: XMLNode?
        private var stack: [XMLNode] = []

        func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?,
                    qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
            let localName = elementName.split(separator: ":").last.map(String.init) ?? elementName
            let node = XMLNode(name: localName, attributes: attributeDict)
            if let parent = stack.last {
                parent.children.append(node)
            } else {
                root = node
            }
            stack.append(node)
        }

        func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
            stack.removeLast()
        }

        func parser(_ parser: XMLParser, foundCharacters string: String) {
            stack.last?.text += string
        }
    }
}

/// One entry from an OOXML `.rels` part: an ID that other parts refer to, and the part it points at.
nonisolated struct OOXMLRelationship {
    let id: String
    let type: String
    /// Full path inside the ZIP archive, e.g. "ppt/slides/slide3.xml".
    let path: String

    /// Reads a relationships part and resolves each target relative to `baseDirectory`
    /// (the folder of the part that owns the relationships, e.g. "ppt/").
    static func read(_ relsPath: String, in archive: ZipArchiveReader, baseDirectory: String) throws -> [String: OOXMLRelationship] {
        guard archive.contains(relsPath) else { return [:] }
        let root = try XMLNode.parse(try archive.data(for: relsPath))
        var result: [String: OOXMLRelationship] = [:]
        for node in root.children("Relationship") {
            guard let id = node.attributes["Id"], let target = node.attributes["Target"] else { continue }
            // External targets (hyperlinks) aren't parts of the package.
            if node.attributes["TargetMode"] == "External" { continue }
            result[id] = OOXMLRelationship(id: id, type: node.attributes["Type"] ?? "", path: resolve(target, from: baseDirectory))
        }
        return result
    }

    /// Resolves "slides/slide1.xml", "../notesSlides/notesSlide1.xml", or "/xl/worksheets/sheet1.xml".
    static func resolve(_ target: String, from baseDirectory: String) -> String {
        if target.hasPrefix("/") { return String(target.dropFirst()) }
        var components = baseDirectory.split(separator: "/").map(String.init)
        for part in target.split(separator: "/").map(String.init) {
            switch part {
            case "..": if !components.isEmpty { components.removeLast() }
            case ".": continue
            default: components.append(part)
            }
        }
        return components.joined(separator: "/")
    }
}
