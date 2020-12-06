struct Day3: Solution {

    private func parseInput(_ string: String) -> [[Character]] {
        string.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
            .map(Array.init)
    }

    private func countTrees(in map: [[Character]], dX: Int, dY: Int) -> Int {
        var x = 0, y = 0, result = 0, length = map.first?.count ?? 1
        while y < map.count {
            result += map[y][x] == "#" ? 1 : 0

            x += dX
            x %= length
            y += dY
        }
        return result
    }

    func solvePart1(_ string: String) -> String {
        let input = parseInput(string)
        let result = countTrees(in: input, dX: 3, dY: 1)
        return "\(result)"
    }

    func solvePart2(_ string: String) -> String {
        let input = parseInput(string)
        let slopes = [
            (1, 1),
            (3, 1),
            (5, 1),
            (7, 1),
            (1, 2)
        ]
        let result = slopes.map { countTrees(in: input, dX: $0.0, dY: $0.1) }
            .reduce(1, *)
        return "\(result)"
    }
}

