import Foundation

struct Day8: Solution {

    private func parseInput(_ string: String) -> [Instruction] {
        string.trimmed().components(separatedBy: .newlines)
            .map {
                let parts = $0.components(separatedBy: .whitespaces)
                guard let code = parts.first,
                      let kind = Instruction.Kind(rawValue: code),
                      let value = parts.last?.trimmingCharacters(in: "+").asInt else { fatalError("Couldn't find the parts in \(parts)")}
                return Instruction(kind: kind, value: value)
            }
    }

    func solvePart1(_ string: String) -> String {
        let input = parseInput(string), console = GameConsole()
        let answer = console.run(input).0

        return "\(answer)"
    }

    func solvePart2(_ string: String) -> String {
        let input = parseInput(string)
        let answer = findWorking(input)
        return "\(answer)"
    }
}

// MARK: - Private Methods
extension Day8 {
    private func findWorking(_ instructions: [Instruction]) -> Int {
        let console = GameConsole()

        for (index, instruction) in instructions.enumerated() {
            if instruction.kind == .accumulate { continue }
//            print("\nFlipping instruction \(index)\n")
            var current = instructions
            current[index] = instruction.flipped()
            let answer = console.run(current)
            if answer.1 { return answer.0 }
        }
        return -1
    }
}

// MARK: - Custom Types
extension Day8 {
    struct Instruction: Hashable {
        enum Kind: String, Hashable {
            case noop = "nop"
            case accumulate = "acc"
            case jump = "jmp"
        }

        let kind: Kind
        let value: Int
        let id = UUID()

        func execute(_ pointer: inout Int, _ accumulator: inout Int) {
//            print("Executing \(kind.rawValue) \(value), pointer: \(pointer), accumulator: \(accumulator)")
            switch kind {
            case .noop:
                pointer += 1
            case .accumulate:
                accumulator += value
                pointer += 1
            case .jump:
                pointer += value
            }
        }

        func flipped() -> Instruction {
            switch kind {
            case .accumulate: return self
            case .jump: return Instruction(kind: .noop, value: value)
            case .noop: return Instruction(kind: .jump, value: value)
            }
        }
    }

    class GameConsole {
        private var accumulator = 0
        private var pointer = 0

        func run(_ instructions: [Instruction]) -> (Int, Bool) {
            reset()
            var executed: Set<Instruction> = []
            while pointer < instructions.count {
                let instruction = instructions[pointer]
                if executed.contains(instruction) { return (accumulator, false) }
                instruction.execute(&pointer, &accumulator)
                executed.insert(instruction)
            }
            return (accumulator, true)
        }

        private func reset() {
            accumulator = 0
            pointer = 0
        }
    }
}
