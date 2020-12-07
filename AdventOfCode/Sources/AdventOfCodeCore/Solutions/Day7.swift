import Foundation

struct Day7: Solution {

    private func parseInput(_ string: String) -> [Bag: [Bag: Int]] {
        string.trimmed().components(separatedBy: .newlines)
            .map { $0.components(separatedBy: " bags contain ") }
            .reduce(into: [Bag: [Bag: Int]]()) {
                let bag = Bag(color: $1[0])
                let contains = $1[1].components(separatedBy: ", ")
                    .reduce(into: [Bag: Int]()) { (dict, string) in
                        if string == "no other bags." {
                            return
                        } else {
                            let parts = string.components(separatedBy: .whitespaces)
                            guard let quantity = Int(parts[0]) else { return}
                            let color = parts.dropFirst().dropLast().joined(separator: " ")
                            dict[Bag(color: color)] = quantity
                        }
                }
                if !contains.isEmpty {
                    $0[bag] = contains
                }
            }
    }

    func solvePart1(_ string: String) -> String {
        let input = parseInput(string)
        let answer = search(input, for: Bag(color: "shiny gold"))
        return "\(answer)"
    }

    func solvePart2(_ string: String) -> String {
        let input = parseInput(string)
        let answer = accumulate(input, for: Bag(color: "shiny gold")) - 1
        return "\(answer)"
    }
}

// MARK: - Private Methods
extension Day7 {
    private func search(_ map: [Bag: [Bag: Int]], for target: Bag) -> Int {
        var queue: [Bag] = [target], checked: Set<Bag> = []

        while let next = queue.popLast() {
            map.forEach {
                if $0.1[next] != nil {
                    let match = $0.0
                    if !checked.contains(match) {
                        queue.insert(match, at: 0)
                        checked.insert(match)
                    }
                }
            }
        }

        return checked.count
    }

    private func accumulate(_ map: [Bag: [Bag: Int]], for target: Bag) -> Int {
        guard let contains = map[target] else { return 1 }
        return contains.map { key, value -> Int in
            value * accumulate(map, for: key)
        }.reduce(1, +)
    }
}

// MARK: - Custom Types
extension Day7 {
    struct Bag: Hashable {
        let color: String
    }
}
