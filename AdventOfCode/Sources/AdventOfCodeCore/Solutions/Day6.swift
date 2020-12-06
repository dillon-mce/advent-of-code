import Foundation

struct Day6: Solution {

    private func parseInput(_ string: String) -> [(String, Int)] {
        string.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "\n\n")
            .map {
                let lines = $0.components(separatedBy: .whitespacesAndNewlines)
                let count = lines.count
                return (lines.joined(), count)
            }
    }

    func solvePart1(_ string: String) -> String {
        let input = parseInput(string)
        let answer = input.map { Set(Array($0.0)).count }
            .reduce(0, +)
        return "\(answer)"
    }

    func solvePart2(_ string: String) -> String {
        let input = parseInput(string)
        let answer = input.map { (line, count) -> Int in
            line.counts().filter {
                $0.1 == count
            }.count
        }.reduce(0, +)
        return "\(answer)"
    }
}

// MARK: - Private Methods
extension Day6 {

}

// MARK: - Custom Types
extension Day6 {

}
