import Foundation

struct Day5: Solution {

    private func parseInput(_ string: String) -> [Seat] {
        string.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines).map(Seat.init)
    }

    func solvePart1(_ string: String) -> String {
        let input = parseInput(string)
        let answer = input.map(\.id).max() ?? 0
        return "\(answer)"
    }

    func solvePart2(_ string: String) -> String {
        let input = parseInput(string)
        let set = Set(input.map(\.id))
        let answer = (0..<864).first {
            !set.contains($0) &&
            set.contains($0 + 1) &&
            set.contains($0 - 1)
        } ?? 0
        return "\(answer)"
    }
}

// MARK: - Private Methods
fileprivate extension Sequence where Element: Equatable {
    func reduceBinary(_ significant: Element, range: (Int, Int)) -> Int {
        self.reduce(range) {
            $1 == significant ?
            ($0.0, $0.1 - (($0.1-$0.0)/2 + 1)) :
            ($0.0 + (($0.1-$0.0)/2 + 1), $0.1)
        }.0
    }
}

// MARK: - Custom Types
extension Day5 {
    struct Seat {
        let row: Int
        let column: Int
        var id: Int { row * 8 + column }

        init(_ string: String) {
            let array = Array(string)
            let rowRep = array[0..<7]
            let columnRep = array[7...]

            row = rowRep.reduceBinary("F", range: (0, 127))
            column = columnRep.reduceBinary("L", range: (0, 7))
        }
    }
}
