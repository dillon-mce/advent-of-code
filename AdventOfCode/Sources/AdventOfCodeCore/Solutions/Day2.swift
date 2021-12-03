struct Day2: Solution {

    func solvePart1(_ string: String) -> String {
        let instructions = parseInput(string)
        var submarine = BadSubmarine()
        instructions.forEach { submarine.process(instruction: $0) }
        return "\(submarine.depth * submarine.position)"
    }

    func solvePart2(_ string: String) -> String {
        let instructions = parseInput(string)
        var submarine = GoodSubmarine()
        instructions.forEach { submarine.process(instruction: $0) }
        return "\(submarine.depth * submarine.position)"
    }
    
    private func parseInput(_ string: String) -> [Instruction] {
        string.components(separatedBy: .newlines).compactMap(Instruction.init)
    }
    
    struct Instruction: CustomStringConvertible {
        enum Direction: String {
            case up, down, forward
        }
        let direction: Direction
        let amount: Int
        
        init?(string: String) {
            let parts = string.components(separatedBy: .whitespaces)
            guard parts.count == 2,
                  let direction = Direction(rawValue: parts[0]),
                  let amount = Int(parts[1]) else { return nil }
            self.direction = direction
            self.amount = amount
        }
        
        var description: String { "\(direction.rawValue.capitalized) \(amount)"}
    }
    
    struct BadSubmarine {
        var depth: Int = 0
        var position: Int = 0
        
        mutating func process(instruction: Instruction) {
            switch instruction.direction {
            case .down:
                depth += instruction.amount
            case .up:
                depth -= instruction.amount
            case .forward:
                position += instruction.amount
            }
        }
    }
    
    struct GoodSubmarine {
        var depth = 0
        var position = 0
        var aim = 0
        
        mutating func process(instruction: Instruction) {
            switch instruction.direction {
            case .down:
                aim += instruction.amount
            case .up:
                aim -= instruction.amount
            case .forward:
                position += instruction.amount
                depth += instruction.amount * aim
            }
        }
    }
}
