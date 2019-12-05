#!/usr/bin/swift
import Cocoa

// MARK: Input Handling
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 5"
day += input == "" ? " – TEST" : ""
let underscores = Array(repeating: "—", count: day.count).joined()

print("\n\(underscores)\n\(day)\n\(underscores)")

// MARK: Custom Types
let verbose = false
let functions = false
let lines = false

func vprint(_ string: String, separator: String = " ", terminator: String = "\n", function: String = #function, line: Int = #line) {
    if verbose {
        let function = functions ? function : ""
        let line = lines ? String(line) : ""
        print(function, line, string, separator: separator, terminator: terminator)
    }
}

class Computer {
    enum Operation {
        case binary((Int, Int, Int) -> Void)
        case jump((Int, Int) -> Void)
        case save((Int) -> Void)
        case load((Int) -> Void)
        case halt

        func increment() -> Int {
            switch self {
            case .binary:
                return 4
            case .jump:
                return 3
            case .save, .load:
                return 2
            default:
                return 1
            }
        }
    }

    // MARK: Binary
    private func add(_ a: Int, _ b: Int, c: Int) {
        vprint("memory[\(c)] = \(a) + \(b)")
        memory[c] = a + b
    }
    private func mul(_ a: Int, _ b: Int, c: Int) {
        vprint("memory[\(c)] = \(a) * \(b)")
        memory[c] = a * b
    }

    private func lth(_ a: Int, _ b: Int, c: Int) {
        vprint("memory[\(c)] = \(a) < \(b): \(a < b ? 1 : 0)")
        memory[c] = a < b ? 1 : 0
    }

    private func eq(_ a: Int, _ b: Int, c: Int) {
        vprint("memory[\(c)] = \(a) == \(b): \(a == b ? 1 : 0)")
        memory[c] = a == b ? 1 : 0
    }

    // MARK: - Jump
    private func jit(_ a: Int, _ b: Int) {
        vprint("JIT(\(a), \(b))")
        if a != 0 {
            pointer = b
            vprint("\(a) != 0, pointer = \(pointer)")
        } else {
            pointer += 3
            vprint("\(a) == 0, pointer = \(pointer)")
        }
    }

    private func jif(_ a: Int, _ b: Int) {
        vprint("JIF(\(a), \(b))")
        if a == 0 {
            pointer = b
            vprint("\(a) == 0, pointer = \(pointer)")
        } else {
            pointer += 3
            vprint("\(a) != 0, pointer = \(pointer)")
        }
    }

    // MARK: - Single
    private func save(_ a: Int) {
        memory[a] = stdin
    }

    private func load(_ a: Int) {
        stdout = a
    }

    lazy var operations: [Int: Operation] = [
        1: .binary(add),
        2: .binary(mul),
        3: .save(save),
        4: .load(load),
        5: .jump(jit),
        6: .jump(jif),
        7: .binary(lth),
        8: .binary(eq),
        99: .halt
    ]

    var storage: [Int] = []
    var stdin: Int = -1
    private(set) var stdout: Int = -1 {
        didSet { if verbose { print(stdout) } }
    }
    private var memory: [Int] = []
    private var pointer = 0

    @discardableResult func run() -> [Int] {
        memory = storage
        while true {
            var instruction = memory[pointer]
            vprint("Pointer \(pointer)")
            vprint("Instruction \(instruction)")
            let opCode = instruction % 100
            instruction /= 100
            vprint("Opcode \(opCode)")
            vprint("ParamCode \(instruction)")
            guard let op = operations[opCode] else {
                return memory
            }
            switch op {
            case .binary(let handler):
                let x = memory[pointer+1]
                let y = memory[pointer+2]

                let a = instruction % 10 == 0 ? memory[x] : x
                instruction /= 10
                let b = instruction % 10 == 0 ? memory[y] : y
                let c = memory[pointer+3]

                handler(a, b, c)
                pointer += op.increment()
            case .jump(let handler):
                let x = memory[pointer+1]
                let y = memory[pointer+2]
                let a = instruction % 10 == 0 ? memory[x] : x
                instruction /= 10
                let b = instruction % 10 == 0 ? memory[y] : y

                handler(a, b)
            case .save(let handler):
                let a = memory[pointer+1]
                handler(a)
                pointer += op.increment()
            case .load(let handler):
                let x = memory[pointer+1]
                let a = instruction % 10 == 0 ? memory[x] : x

                handler(a)
                pointer += op.increment()
            case .halt:
                return memory
            }
        }
    }
}

// MARK: Tests
let test1 = "1002,4,3,4,33"
let test2 = "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"

// MARK: Part 1
func solvePart1(_ string: String, input: Int = 1) -> String {
    let computer = Computer()
    computer.storage = string.components(separatedBy: ",").compactMap { Int($0) }
    computer.stdin = input
    computer.run()
    return "\(computer.stdout)"
}

// MARK: Part 2
func solvePart2(_ string: String, input: Int = 5) -> String {
    let computer = Computer()
    computer.storage = string.components(separatedBy: ",").compactMap { Int($0) }
    computer.stdin = input
    computer.run()
    return "\(computer.stdout)"
}

assert(solvePart2(test2, input: 5) == "999")
assert(solvePart2(test2, input: 8) == "1000")
assert(solvePart2(test2, input: 12) == "1001")

// MARK: Execution
func findAnswers(_ string: String) {
    var string = string
    if string.isEmpty { string = test1 }

    var startTime = CFAbsoluteTimeGetCurrent()
    let answer1 = solvePart1(string)
    print("Part 1 Answer: \(answer1)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")

    if string == test1 { string = test2 }

    startTime = CFAbsoluteTimeGetCurrent()
    let answer2 = solvePart2(string)
    print("Part 2 Answer: \(answer2)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
}

findAnswers(input)
