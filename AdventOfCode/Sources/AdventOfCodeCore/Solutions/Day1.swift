struct Day1: Solution {

    func solvePart1(_ string: String) -> String {
        let numbers = parseInput(string)
        let increases = findIncreases(in: numbers)
        return "\(increases.count)"
    }

    func solvePart2(_ string: String) -> String {
        let numbers = parseInput(string)
        let windows = (0..<numbers.count - 2).map { index in
            return (0...2).reduce(0) { $0 + numbers[index + $1] }
        }
        let increases = findIncreases(in: windows)
        return "\(increases.count)"
    }
    
    private func parseInput(_ string: String) -> [Int] {
        string.components(separatedBy: .newlines).compactMap(Int.init)
    }
    
    private func findIncreases(in array: [Int]) -> Counter {
        array.reduce(into: Counter()) {
            if let previous = $0.previous,
               $1 > previous {
                $0.count += 1
            }
            $0.previous = $1
        }
    }
}

extension Day1 {
    struct Counter {
        var count = 0
        var previous: Int?
    }
}
