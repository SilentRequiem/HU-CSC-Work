import CoreGraphics
import Foundation

/// Fixed node sizes shared by the layout and the node views, so collision checks match what's drawn.
enum BrainMapMetrics {
    static let centralSize = CGSize(width: 140, height: 84)
    static let conceptSize = CGSize(width: 116, height: 60)
    /// Minimum empty space kept between any two nodes.
    static let nodeGap: CGFloat = 14
    /// Space around the outermost nodes so labels and shadows aren't clipped.
    static let canvasPadding: CGFloat = 32
    /// Curved relationship lines stay at least this far from the center of the central node.
    /// Large enough that a label at the curve's midpoint doesn't sit under the central node.
    static let centerClearance: CGFloat = 125

    static func size(for kind: BrainMapNode.Kind) -> CGSize {
        kind == .central ? centralSize : conceptSize
    }
}

/// Screen geometry for one line: a quadratic curve trimmed to the node edges, plus an arrowhead.
struct BrainMapLineGeometry {
    let start: CGPoint
    let control: CGPoint
    let end: CGPoint
    /// Where the relationship label sits; adjusted by the layout so it doesn't cover nodes.
    var labelPoint: CGPoint
    let arrowTip: CGPoint
    let arrowLeft: CGPoint
    let arrowRight: CGPoint
}

/// Deterministic radial layout: the central topic in the middle and concepts on an ellipse around it.
///
/// The same graph and screen shape always produce the same positions, so nodes never jump between
/// redraws. This is pure geometry with no SwiftUI or Foundation Models dependency.
struct BrainMapLayout {
    let canvasSize: CGSize
    /// Node centers in canvas coordinates, keyed by node ID.
    let positions: [String: CGPoint]
    /// Generated relationship lines, keyed by edge ID.
    let edgeLines: [Int: BrainMapLineGeometry]
    /// Faint structural lines from the central topic to concepts that no generated relationship
    /// already joins to it, keyed by concept ID. These keep every concept visibly attached to the topic.
    let spokeLines: [String: BrainMapLineGeometry]

    init(graph: BrainMapGraph, availableSize: CGSize) {
        let order = Self.ringOrder(for: graph)
        let offsets = Self.ringOffsets(for: order, isPortrait: availableSize.height > availableSize.width, availableWidth: availableSize.width)

        // Size the canvas to fit every node, but never smaller than the visible area so small maps stay centered.
        var halfWidth = BrainMapMetrics.centralSize.width / 2
        var halfHeight = BrainMapMetrics.centralSize.height / 2
        for offset in offsets.values {
            halfWidth = max(halfWidth, abs(offset.x) + BrainMapMetrics.conceptSize.width / 2)
            halfHeight = max(halfHeight, abs(offset.y) + BrainMapMetrics.conceptSize.height / 2)
        }
        let padding = BrainMapMetrics.canvasPadding
        let canvasSize = CGSize(
            width: max(availableSize.width, (halfWidth + padding) * 2),
            height: max(availableSize.height, (halfHeight + padding) * 2)
        )
        let center = CGPoint(x: canvasSize.width / 2, y: canvasSize.height / 2)

        var positions = [BrainMapGraph.centralID: center]
        for (id, offset) in offsets {
            positions[id] = center + offset
        }

        func frame(of id: String) -> CGRect {
            let kind: BrainMapNode.Kind = id == BrainMapGraph.centralID ? .central : .concept
            return CGRect(center: positions[id] ?? center, size: BrainMapMetrics.size(for: kind))
        }

        // Labels must stay clear of every node and of labels placed before them.
        var occupied = graph.nodes.map { frame(of: $0.id) }
        var edgeLines: [Int: BrainMapLineGeometry] = [:]
        for edge in graph.edges {
            guard let from = positions[edge.sourceID], let to = positions[edge.targetID] else { continue }
            // Lines touching the central node go straight to it; others bend around it.
            let touchesCenter = edge.sourceID == BrainMapGraph.centralID || edge.targetID == BrainMapGraph.centralID
            var geometry = Self.line(
                from: from, fromFrame: frame(of: edge.sourceID),
                to: to, toFrame: frame(of: edge.targetID),
                bendingAround: touchesCenter ? nil : center
            )
            if !edge.label.isEmpty {
                let labelSize = Self.estimatedLabelSize(for: edge.label)
                geometry.labelPoint = Self.labelPoint(for: geometry, labelSize: labelSize, center: center, avoiding: occupied)
                occupied.append(CGRect(center: geometry.labelPoint, size: labelSize))
            }
            edgeLines[edge.id] = geometry
        }

        let joinedToCenter = graph.neighborIDs(of: BrainMapGraph.centralID)
        var spokeLines: [String: BrainMapLineGeometry] = [:]
        for concept in graph.concepts where !joinedToCenter.contains(concept.id) {
            guard let to = positions[concept.id] else { continue }
            spokeLines[concept.id] = Self.line(
                from: center, fromFrame: frame(of: BrainMapGraph.centralID),
                to: to, toFrame: frame(of: concept.id),
                bendingAround: nil
            )
        }

        self.canvasSize = canvasSize
        self.positions = positions
        self.edgeLines = edgeLines
        self.spokeLines = spokeLines
    }

    // MARK: - Ring order

    /// Orders concepts around the ring so related concepts sit next to each other, which keeps
    /// lines short and reduces crossings. Starts from the most-connected concept and walks to
    /// neighbors; ties fall back to the model's original order, so the result is deterministic.
    private static func ringOrder(for graph: BrainMapGraph) -> [String] {
        let ids = graph.concepts.map(\.id)
        let originalIndex = Dictionary(uniqueKeysWithValues: ids.enumerated().map { ($1, $0) })

        var neighbors: [String: Set<String>] = [:]
        for edge in graph.edges where originalIndex[edge.sourceID] != nil && originalIndex[edge.targetID] != nil {
            neighbors[edge.sourceID, default: []].insert(edge.targetID)
            neighbors[edge.targetID, default: []].insert(edge.sourceID)
        }

        func best(of candidates: some Collection<String>) -> String? {
            candidates.min { a, b in
                let degreeA = neighbors[a]?.count ?? 0
                let degreeB = neighbors[b]?.count ?? 0
                if degreeA != degreeB { return degreeA > degreeB }
                return originalIndex[a, default: 0] < originalIndex[b, default: 0]
            }
        }

        var order: [String] = []
        // Concepts with no links to other concepts are slotted in afterwards.
        var remaining = Set(ids.filter { neighbors[$0] != nil })
        while !remaining.isEmpty {
            let placed = Set(order)
            let next: String?
            if let last = order.last, let neighbor = best(of: (neighbors[last] ?? []).intersection(remaining)) {
                next = neighbor
            } else if let linked = best(of: remaining.filter { !(neighbors[$0] ?? []).isDisjoint(with: placed) }) {
                next = linked
            } else {
                next = best(of: remaining)
            }
            guard let next else { break }
            order.append(next)
            remaining.remove(next)
        }

        // Put each unlinked concept between two ring neighbors that aren't connected to each
        // other (the ring wraps around), so it never splits a pair that has a line between them.
        for id in ids where neighbors[id] == nil {
            let gap = order.indices.first { index in
                let next = order[(index + 1) % order.count]
                return !(neighbors[order[index]]?.contains(next) ?? false)
            }
            if let gap {
                order.insert(id, at: gap + 1)
            } else {
                order.append(id)
            }
        }
        return order
    }

    // MARK: - Ring placement

    /// Places concepts at equal angles on an ellipse (offsets from the center), growing the
    /// ellipse until no two nodes overlap.
    private static func ringOffsets(for order: [String], isPortrait: Bool, availableWidth: CGFloat) -> [String: CGPoint] {
        guard !order.isEmpty else { return [:] }

        let concept = BrainMapMetrics.conceptSize
        var radiusX: CGFloat
        var radiusY: CGFloat
        if isPortrait {
            // iPhone: fit the ring to the screen width and stretch it vertically.
            radiusX = max(110, availableWidth / 2 - concept.width / 2 - BrainMapMetrics.canvasPadding)
            radiusY = radiusX * 1.7
        } else {
            // Mac windows and landscape: a wide ellipse that doesn't depend on window width,
            // so opening the inspector only re-centers the map instead of moving nodes around.
            radiusX = 290
            radiusY = 170
        }

        let count = order.count
        var offsets: [String: CGPoint] = [:]
        for _ in 0..<60 {
            offsets = [:]
            for (index, id) in order.enumerated() {
                // Start at 12 o'clock and go clockwise.
                let angle = -CGFloat.pi / 2 + 2 * .pi * CGFloat(index) / CGFloat(count)
                offsets[id] = CGPoint(x: radiusX * cos(angle), y: radiusY * sin(angle))
            }
            if !hasOverlap(offsets.values.map { CGRect(center: $0, size: concept) }) {
                break
            }
            radiusX *= 1.06
            radiusY *= 1.06
        }
        return offsets
    }

    /// True when any two nodes (including the central node at the origin) are closer than `nodeGap`.
    private static func hasOverlap(_ conceptFrames: [CGRect]) -> Bool {
        let gap = BrainMapMetrics.nodeGap / 2
        let frames = ([CGRect(center: .zero, size: BrainMapMetrics.centralSize)] + conceptFrames)
            .map { $0.insetBy(dx: -gap, dy: -gap) }
        for i in frames.indices {
            for j in frames.indices where j > i && frames[i].intersects(frames[j]) {
                return true
            }
        }
        return false
    }

    // MARK: - Lines

    /// Builds a line between two node centers, trimmed so it starts and ends at the node edges.
    /// When `bendingAround` is set and the straight line would pass through the central node,
    /// the line becomes a curve that bows outward around it.
    private static func line(
        from start: CGPoint, fromFrame: CGRect,
        to end: CGPoint, toFrame: CGRect,
        bendingAround center: CGPoint?
    ) -> BrainMapLineGeometry {
        let mid = (start + end) * 0.5
        var control = mid

        if let center {
            let clearance = BrainMapMetrics.centerClearance
            if distance(from: center, toSegmentFrom: start, to: end) < clearance {
                var direction = mid - center
                if direction.length < 1 {
                    // The nodes are directly opposite each other; bend perpendicular to the line.
                    direction = CGPoint(x: -(end.y - start.y), y: end.x - start.x)
                }
                // A quadratic curve's midpoint lies halfway to its control point, so double the push.
                let apex = center + direction.normalized * clearance
                control = mid + (apex - mid) * 2
            }
        }

        func point(at t: CGFloat) -> CGPoint {
            quadraticPoint(start, control, end, t)
        }

        // Walk inward from each end until the curve leaves the node's frame.
        let fromBounds = fromFrame.insetBy(dx: -3, dy: -3)
        let toBounds = toFrame.insetBy(dx: -3, dy: -3)
        let steps = stride(from: CGFloat(0), through: 1, by: 0.01)
        var tStart = steps.first { !fromBounds.contains(point(at: $0)) } ?? 0
        var tEnd = steps.reversed().first { !toBounds.contains(point(at: $0)) } ?? 1
        if tStart >= tEnd {
            tStart = 0
            tEnd = 1
        }

        // Control point of the sub-curve between tStart and tEnd (de Casteljau blossom).
        let trimmedControl = start * ((1 - tStart) * (1 - tEnd))
            + control * ((1 - tStart) * tEnd + tStart * (1 - tEnd))
            + end * (tStart * tEnd)

        let tip = point(at: tEnd)
        let direction = (tip - point(at: max(tStart, tEnd - 0.04))).normalized
        let perpendicular = CGPoint(x: -direction.y, y: direction.x)
        let arrowLength: CGFloat = 10
        let arrowHalfWidth: CGFloat = 5

        return BrainMapLineGeometry(
            start: point(at: tStart),
            control: trimmedControl,
            end: tip,
            labelPoint: point(at: (tStart + tEnd) / 2),
            arrowTip: tip,
            arrowLeft: tip - direction * arrowLength + perpendicular * arrowHalfWidth,
            arrowRight: tip - direction * arrowLength - perpendicular * arrowHalfWidth
        )
    }

    // MARK: - Labels

    /// Rough size of a `BrainMapEdgeLabel` (caption2 text, max width 96, up to two lines, plus padding).
    private static func estimatedLabelSize(for text: String) -> CGSize {
        let singleLineWidth = CGFloat(text.count) * 5.5
        return CGSize(width: min(singleLineWidth, 96) + 12, height: singleLineWidth > 96 ? 34 : 20)
    }

    /// Picks the first spot that doesn't cover a node or an earlier label: the middle of the visible
    /// line, then further along it, then beside it (outward from the map center first).
    private static func labelPoint(
        for geometry: BrainMapLineGeometry,
        labelSize: CGSize,
        center: CGPoint,
        avoiding occupied: [CGRect]
    ) -> CGPoint {
        func point(at t: CGFloat) -> CGPoint {
            quadraticPoint(geometry.start, geometry.control, geometry.end, t)
        }

        let mid = point(at: 0.5)
        let direction = (geometry.end - geometry.start).normalized
        var perpendicular = CGPoint(x: -direction.y, y: direction.x)
        if (mid - center).x * perpendicular.x + (mid - center).y * perpendicular.y < 0 {
            perpendicular = perpendicular * -1
        }

        var candidates = [mid, point(at: 0.3), point(at: 0.7)]
        // Short lines between close nodes need offsets large enough to clear the nodes themselves.
        let halfLabel = labelSize.height / 2
        let distances = [
            halfLabel + 8,
            halfLabel + 30,
            BrainMapMetrics.conceptSize.height / 2 + halfLabel + 8,
            BrainMapMetrics.centralSize.height / 2 + halfLabel + 8
        ]
        for distance in distances {
            candidates.append(mid + perpendicular * distance)
            candidates.append(mid - perpendicular * distance)
        }

        let gap: CGFloat = 4
        func overlapArea(at candidate: CGPoint) -> CGFloat {
            let frame = CGRect(center: candidate, size: labelSize).insetBy(dx: -gap, dy: -gap)
            return occupied.reduce(0) { total, other in
                let intersection = frame.intersection(other)
                return intersection.isNull ? total : total + intersection.width * intersection.height
            }
        }

        // First candidate with no overlap wins; when every spot is crowded, take the least-covered one.
        if let clear = candidates.first(where: { overlapArea(at: $0) == 0 }) {
            return clear
        }
        return candidates.min { overlapArea(at: $0) < overlapArea(at: $1) } ?? mid
    }

    private static func quadraticPoint(_ p0: CGPoint, _ p1: CGPoint, _ p2: CGPoint, _ t: CGFloat) -> CGPoint {
        let u = 1 - t
        return p0 * (u * u) + p1 * (2 * u * t) + p2 * (t * t)
    }

    private static func distance(from point: CGPoint, toSegmentFrom a: CGPoint, to b: CGPoint) -> CGFloat {
        let ab = b - a
        let lengthSquared = ab.x * ab.x + ab.y * ab.y
        guard lengthSquared > 0 else { return (point - a).length }
        let t = min(1, max(0, ((point.x - a.x) * ab.x + (point.y - a.y) * ab.y) / lengthSquared))
        return (point - (a + ab * t)).length
    }
}

// MARK: - Geometry helpers

private extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint { CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y) }
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint { CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y) }
    static func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint { CGPoint(x: lhs.x * rhs, y: lhs.y * rhs) }

    var length: CGFloat { (x * x + y * y).squareRoot() }

    var normalized: CGPoint {
        let length = length
        return length > 0 ? CGPoint(x: x / length, y: y / length) : .zero
    }
}

private extension CGRect {
    init(center: CGPoint, size: CGSize) {
        self.init(x: center.x - size.width / 2, y: center.y - size.height / 2, width: size.width, height: size.height)
    }
}
