import Foundation

struct Day11: Solution {

    private func parseInput(_ string: String) -> Map {
        Map(map: string.trimmed()
                .components(separatedBy: .newlines)
                .map { $0.map(String.init).compactMap(Map.Point.init) })
    }

    func solvePart1(_ string: String) -> String {
        var input = parseInput(string)
        while true {
            let new = input.updated()
            if new == input { break }
            input = new
        }
        return "\(input.total(.occupied))"
    }

    func solvePart2(_ string: String) -> String {
        var input = parseInput(string)
        while true {
            let new = input.newUpdated()
            if new == input { break }
            input = new
        }
        return "\(input.total(.occupied))"
    }
}

// MARK: - Private Methods
extension Day11 {
}

// MARK: - Custom Types
extension Day11 {
    struct Map: Equatable, CustomStringConvertible {
        enum Point: String, Equatable, CustomStringConvertible {
            case floor = "."
            case unoccupied = "L"
            case occupied = "#"

            func update(adjacent: Int) -> Self {
                switch (self, adjacent) {
                case (.unoccupied, 0): return .occupied
                case (.occupied, 4...): return .unoccupied
                default: return self
                }
            }

            func looserUpdate(adjacent: Int) -> Self {
                switch (self, adjacent) {
                case (.unoccupied, 0): return .occupied
                case (.occupied, 5...): return .unoccupied
                default: return self
                }
            }

            var description: String { return rawValue }
        }

        let map: [[Point]]

        var description: String {
            map.map { $0.map { "\($0)" }.joined() }.joined(separator: "\n")
        }

        func updated() -> Self {
            var new = map
            for y in (0..<map.count) {
                for x in (0..<map[y].count) {
                    new[y][x] = map[y][x].update(adjacent: adjacent(x: x, y: y))
                }
            }
            return Map(map: new)
        }

        func newUpdated() -> Self {
            var new = map
            for y in (0..<map.count) {
                for x in (0..<map[y].count) {
                    new[y][x] = map[y][x].looserUpdate(adjacent: firstAdjacents(x: x, y: y))
                }
            }
            return Map(map: new)
        }

        struct Coordinate: Hashable, CustomStringConvertible {
            let y: Int
            let x: Int

            var description: String { "(\(y), \(x))"}
        }

        private func adjacent(x: Int, y: Int) -> Int {
            let minY = max(y-1, 0)
            let minX = max(x-1, 0)
            let maxY = min(y+1, map.count-1)
            let maxX = min(x+1, map[y].count-1)

            let up = Coordinate(y: minY, x: x)
            let left = Coordinate(y: y, x: minX)
            let upLeft = Coordinate(y: minY, x: minX)
            let upRight = Coordinate(y: minY, x: maxX)
            let right = Coordinate(y: y, x: maxX)
            let downRight = Coordinate(y: maxY, x: maxX)
            let down = Coordinate(y: maxY, x: x)
            let downLeft = Coordinate(y: maxY, x: minX)

            return Set([upLeft, up, upRight, right, downRight, down, downLeft, left])
                .subtracting([Coordinate(y: y, x: x)])
                .compactMap { map[$0.y][$0.x] == .occupied ? 1 : nil }
                .reduce(0, +)
        }

        private func firstAdjacents(x: Int, y: Int) -> Int {
            [first(x: x, y: y, dX: 1, dY: 1),
             first(x: x, y: y, dX: -1, dY: -1),
             first(x: x, y: y, dX: -1, dY: 1),
             first(x: x, y: y, dX: 1, dY: -1),
             first(x: x, y: y, dX: -1),
             first(x: x, y: y, dX: 1),
             first(x: x, y: y, dY: -1),
             first(x: x, y: y, dY: 1)]
                .compactMap { $0 }
                .compactMap { map[$0.y][$0.x] == .occupied ? 1 : nil }
                .reduce(0, +)
        }

        private func first(x: Int, y: Int, dX: Int = 0, dY: Int = 0) -> Coordinate? {
            var cX = x + dX
            var cY = y + dY
            let xLimit: (Int) -> Bool = dX <= 0 ? { $0 >= 0 } : { $0 < map[y].count }
            let yLimit: (Int) -> Bool = dY <= 0 ? { $0 >= 0 } : { $0 < map.count }

            while xLimit(cX) && yLimit(cY) {
                if map[cY][cX] != .floor {
                    return Coordinate(y: cY, x: cX)
                }
                cX += dX
                cY += dY
            }
            return nil
        }

        func total(_ type: Point) -> Int {
            map.flatMap { $0 }
                .compactMap { $0 == type ? 1 : nil }
                .reduce(0, +)
        }
    }
}
