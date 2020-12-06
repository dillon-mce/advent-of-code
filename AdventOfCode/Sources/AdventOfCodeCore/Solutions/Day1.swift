struct Day1: Solution {

    private func parseInput(_ string: String) -> [Int] {
        string.components(separatedBy: .newlines)
            .compactMap(Int.init)
    }

    private func findXThatSum(_ total: Int, current: [Int]) -> [Int]? {
        var set: Set<Int> = []
        for number in current {
            let diff = total - number
            if set.contains(diff) {
                return [number, diff]
            }
            set.insert(number)
        }
        return nil
    }

    func solvePart1(_ string: String) -> String {
        let input = parseInput(string)

        if let answer = findXThatSum(2020, current: input) {
            return "\(answer.reduce(1, *))"
        }
        return "No answer found"
    }

    func solvePart2(_ string: String) -> String {
        let input = parseInput(string)
        let dict = input.reduce(into: [Int:Int]()) {
            $0[$1] = 2020 - $1
        }

        for (key, value) in dict {
            if let answer = findXThatSum(value, current: input) {
                return "\(([key] + answer).reduce(1, *))"
            }
        }
        return "No answer found"
    }
}
