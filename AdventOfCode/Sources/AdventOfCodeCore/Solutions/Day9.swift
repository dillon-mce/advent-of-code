import Foundation

struct Day9: Solution {
    let length: Int

    private func parseInput(_ string: String) -> [Int] {
        string.trimmed()
            .components(separatedBy: .newlines)
            .compactMap(Int.init)
    }

    func solvePart1(_ string: String) -> String {
        let input = parseInput(string)
        let answer = findFirstNoMatch(in: input)
        return "\(answer?.1 ?? -1)"
    }

    func solvePart2(_ string: String) -> String {
        let input = parseInput(string)
        guard let invalid = findFirstNoMatch(in: input),
              let answer = findContiguousThatSum(to: invalid.1, in: input[0..<invalid.0]),
              let smallest = answer.min(),
              let largest = answer.max() else {
            return "No answer found"
        }

        return "\(smallest + largest)"
    }
}

// MARK: - Private Methods
extension Day9 {
    private func findFirstNoMatch(in sequence: [Int]) -> (Int, Int)? {
        var start = 0, end = length
        return sequence[end...].enumerated().first {
            if findXThatSum($0.1, current: sequence[start..<end]) != nil {
                start += 1
                end += 1
                return false
            } else {
                return true
            }
        }
    }

    private func findXThatSum(_ total: Int, current: ArraySlice<Int>) -> [Int]? {
//        print("Looking for \(total)\nin \(current)")
        var set: Set<Int> = []
        for number in current {
            let diff = total - number
            if set.contains(diff), diff != number {
                return [number, diff]
            }
            set.insert(number)
        }
        return nil
    }

    private func findContiguousThatSum(to total: Int, in slice: ArraySlice<Int>) -> ArraySlice<Int>? {
        for i in slice.startIndex..<slice.index(before: slice.endIndex) {
            for j in slice.index(after: i)..<slice.endIndex {
                if slice[i...j].reduce(0, +) == total { return slice[i...j] }
            }
        }
        return nil
    }
}

// MARK: - Custom Types
extension Day9 {

}
