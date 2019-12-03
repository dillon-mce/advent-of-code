#!/usr/bin/swift
import Cocoa

// MARK: Input Handling
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 2"
day += input == "" ? " – TEST" : ""
let underscores = Array(repeating: "—", count: day.count).joined()

print("\n\(underscores)\n\(day)\n\(underscores)")

// MARK: Custom Types
class Computer {
    enum Operation {
        case binary((Int, Int, Int) -> Void)
        case unary((Int, Int) -> Void)
        case exit

        func increment() -> Int {
            switch self {
            case .binary:
                return 4
            case .unary:
                return 3
            default:
                return 1
            }
        }
    }

    private func add(_ a: Int, _ b: Int, c: Int) {
        memory[c] = memory[a] + memory[b]
    }
    private func mul(_ a: Int, _ b: Int, c: Int) {
        memory[c] = memory[a] * memory[b]
    }

    lazy var operations: [Int: Operation] = [
        1: .binary(add),
        2: .binary(mul),
        99: .exit
    ]

    var storage: [Int] = []
    private var memory: [Int] = []

    func run() -> [Int] {
        memory = storage
        var pointer = 0
        while true {
            let opCode = memory[pointer]
            guard let op = operations[opCode] else {
                return memory
            }
            switch op {
            case .binary(let handler):
                let a = memory[pointer+1]
                let b = memory[pointer+2]
                let c = memory[pointer+3]
                handler(a, b, c)
                pointer += op.increment()
            case .unary:
                break
            case .exit:
                return memory
            }
        }
    }
}

// MARK: Tests
let test1 = "1,9,10,3,2,3,11,0,99,30,40,50"
let test2 = "1,1,1,4,99,5,6,0,99"

// MARK: Part 1
func solvePart1(_ string: String) -> Int {
    let computer = Computer()
    computer.storage = string.components(separatedBy: ",").compactMap { Int($0) }
    let result = computer.run()
    return result[0]
}

//print(solvePart1(test1))
assert(solvePart1(test1) == 3500)
assert(solvePart1(test2) == 30)

// MARK: Part 2
func solvePart2(_ string: String) -> Int {
    let target = 19690720
    let computer = Computer()
    computer.storage = string.components(separatedBy: ",").compactMap { Int($0) }
    for noun in 0...99 {
        for verb in 0...99 {
            computer.storage[1] = noun
            computer.storage[2] = verb
            let result = computer.run()
            if result[0] == target {
                return 100 * noun + verb
            }
        }
    }
    return -1
}

//assert(solvePart2(test2) == "")

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
