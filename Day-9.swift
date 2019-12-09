#!/usr/bin/swift
import Cocoa

// MARK: Input Handling
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 9"
day += input == "" ? " – TEST" : ""
let underscores = Array(repeating: "—", count: day.count).joined()

print("\n\(underscores)\n\(day)\n\(underscores)")

// MARK: Custom Types
let verbose = false
let functions = false
let lines = true

func vprint(_ string: String, separator: String = " ", terminator: String = "\n", function: String = #function, line: Int = #line) {
    if verbose {
        let function = functions ? function : ""
        let line = lines ? String(line) : ""
        print(function, line, string, separator: separator, terminator: terminator)
    }
}

// MARK: Computer
class Computer {

    init(memory: Int = 4096) {
        self.memory = Array(repeating: 0, count: memory)
    }

    // MARK: Operations
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
                return 0
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

    // MARK: Jump
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

    // MARK: Single
    private func save(_ a: Int) {
        if stdin.count > 0 {
            vprint("memory[\(a)] = stdin (\(stdin[0]))")
            memory[a] = stdin.removeFirst()
        } else {
            print("Trying to access stdin when it is empty")
        }
    }

    private func load(_ a: Int) {
        vprint("Stdout: \(a)")
        stdout.append(a)
    }

    private func movr(_ a: Int) {
        relative += a
        vprint("Relative = \(relative)")
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
        9: .load(movr),
        99: .halt
    ]

    // MARK: Internal Variables
    var storage: [Int] = []
    var stdin: [Int] = []
    private(set) var stdout: [Int] = []
    private var memory: [Int]
    private var pointer = 0
    private var relative = 0

    // MARK: - Lifecycle
    func parseProgram(_ string: String) {
        let program = string.components(separatedBy: ",").compactMap { Int($0) }
        let map = program.enumerated().map { "\($0.0): \($0.1)"}
        vprint(map.joined(separator: "\n"))
        storage = program
    }

    func boot() {
        storage.enumerated().forEach {
            memory[$0.0] = $0.1
        }
    }

    @discardableResult func run() -> Int {
        vprint("Pointer on enter: \(pointer)")
        vprint("Stdin on enter: \(stdin)")
        while true {
            var instruction = memory[pointer]
//            vprint("Pointer \(pointer)")
            vprint("Instruction \(instruction)")
            let opCode = instruction % 100
            instruction /= 100
//            vprint("Opcode \(opCode)")
//            vprint("ParamCode \(instruction)")
            guard let op = operations[opCode] else {
                return 99            }
            switch op {
            case .binary(let handler):
                let x = memory[pointer+1]
                let y = memory[pointer+2]
                let z = memory[pointer+3]

                let a = getValue(from: x, with: instruction)
                instruction /= 10
                let b = getValue(from: y, with: instruction)
                instruction /= 10
                let c = instruction % 10 == 2 ? relative+z : z

                handler(a, b, c)
            case .jump(let handler):
                let x = memory[pointer+1]
                let y = memory[pointer+2]
                let a = getValue(from: x, with: instruction)
                instruction /= 10
                let b = getValue(from: y, with: instruction)
                handler(a, b)
            case .save(let handler):
                if stdin.count > 0 {
                let x = memory[pointer+1]
                let a = instruction % 10 == 2 ? relative+x : x
                handler(a)
                } else {
                    vprint("Pointer on exit: \(pointer)")
                    vprint("Stdout on exit: \(stdout)\n")
                    return 1
                }
            case .load(let handler):
                let x = memory[pointer+1]
                let a = getValue(from: x, with: instruction)

                handler(a)
            case .halt:
                vprint("Hit a halt instruction")
                vprint("Stdout on exit: \(stdout)\n")
                return 0
            }
            pointer += op.increment()
        }
    }

    private func getValue(from x: Int, with instruction: Int) -> Int {
        let code = instruction % 10
        switch code {
        case 2:
            return memory[relative+x]
        case 1:
            return x
        default:
            return memory[x]
        }
    }
}


// MARK: Tests
let test1 = "104,1125899906842624,99"
let test2 = "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"
let test3 = "1102,34915192,34915192,7,4,7,99,0"

// MARK: Part 1
func solvePart1(_ string: String) -> String {
    let comp = Computer()
    comp.parseProgram(string)
    comp.boot()
    comp.stdin = [1]
    comp.run()

    return comp.stdout.map { String($0) }.joined(separator: ",")
}

assert(solvePart1(test1) == "1125899906842624")
assert(solvePart1(test2) == test2)
assert(solvePart1(test3) == "1219070632396864")

// MARK: Part 2
func solvePart2(_ string: String) -> String {
    let comp = Computer()
    comp.parseProgram(string)
    comp.boot()
    comp.stdin = [2]
    comp.run()

    return comp.stdout.map { String($0) }.joined(separator: ",")
}

//print(solvePart2(test2))
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
