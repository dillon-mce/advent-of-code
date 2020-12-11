import Foundation

struct Day10: Solution {

    private func parseInput(_ string: String) -> [Int] {
        let result = string.trimmed()
                           .components(separatedBy: .newlines)
                           .compactMap(Int.init)
        let max = result.max() ?? -3
        return  [0] + result + [max+3]
    }

    func solvePart1(_ string: String) -> String {
        let input = parseInput(string).sorted()
        let answer = input.reduce(into: (0, 0, 0)) {
            let diff = $1 - $0.0
            if diff == 1 { $0.1 += 1 }
            if diff == 3 { $0.2 += 1 }
            $0.0 = $1
        }
        return "\(answer.1 * answer.2)"
    }

    func solvePart2(_ string: String) -> String {
        let input = parseInput(string)
        let set = Set(input)
        let test = input
            .reduce(into: [Int: [Int]]()) { (dict, n) in
            dict[n] = (1...3).map { n + $0 }.filter(set.contains)
        }

        var memo = [Int: Int]()
        return "\(count(from: 0, in: test, memo: &memo))"
    }
}

// MARK: - Private Methods
extension Day10 {
    private func count(from num: Int, in dict: [Int: [Int]], memo: inout [Int: Int]) -> Int {
        guard let subsequent = dict[num], !subsequent.isEmpty else { return 1 }
        return subsequent.reduce(0) {
            let memoed = memo[$1] ?? count(from: $1, in: dict, memo: &memo)
            memo[$1] = memoed
            return $0 + memoed
        }
    }
}

// MARK: - Custom Types
extension Day10 {

}
