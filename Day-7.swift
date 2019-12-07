#!/usr/bin/swift
import Cocoa

// MARK: Input Handling
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 7"
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

// MARK: Computer
class Computer {
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
            memory[a] = stdin.removeFirst()
        } else {
            print("Trying to access stdin when it is empty")
        }
    }

    private func load(_ a: Int) {
        stdout = [a]
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

    // MARK: Internal Variables
    var storage: [Int] = []
    var stdin: [Int] = []
    private(set) var stdout: [Int] = []
    private var memory: [Int] = []
    private var pointer = 0

    // MARK: - Lifecycle
    func parseProgram(_ string: String) {
        let program = string.components(separatedBy: ",").compactMap { Int($0) }
        let map = program.enumerated().map { "\($0.0): \($0.1)"}
        vprint(map.joined(separator: "\n"))
        storage = program
    }

    func boot() {
        memory = storage
    }

    @discardableResult func run() -> Int {
        vprint("Pointer on enter: \(pointer)")
        vprint("Stdin on enter: \(stdin)")
        while true {
            var instruction = memory[pointer]
            vprint("Pointer \(pointer)")
            vprint("Instruction \(instruction)")
            let opCode = instruction % 100
            instruction /= 100
            vprint("Opcode \(opCode)")
            vprint("ParamCode \(instruction)")
            guard let op = operations[opCode] else {
                return 99            }
            switch op {
            case .binary(let handler):
                let x = memory[pointer+1]
                let y = memory[pointer+2]

                let a = instruction % 10 == 0 ? memory[x] : x
                instruction /= 10
                let b = instruction % 10 == 0 ? memory[y] : y
                let c = memory[pointer+3]

                handler(a, b, c)
            case .jump(let handler):
                let x = memory[pointer+1]
                let y = memory[pointer+2]
                let a = instruction % 10 == 0 ? memory[x] : x
                instruction /= 10
                let b = instruction % 10 == 0 ? memory[y] : y
                handler(a, b)
            case .save(let handler):
                if stdin.count > 0 {
                let a = memory[pointer+1]
                handler(a)
                } else {
                    vprint("Pointer on exit: \(pointer)")
                    vprint("Stdout on exit: \(stdout)\n")
                    return 1
                }
            case .load(let handler):
                let x = memory[pointer+1]
                let a = instruction % 10 == 0 ? memory[x] : x

                handler(a)
            case .halt:
                vprint("Hit a halt instruction")
                vprint("Stdout on exit: \(stdout)\n")
                return 0
            }
            pointer += op.increment()
        }
    }
}

// MARK: Tests
let test1 = "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0"
let test2 = "3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0"
let test3 = "3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5"
let test4 = "3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10"

// MARK: Part 1
func solvePart1(_ string: String) -> Int {
    let combos = makeCombinations([0,1,2,3,4])
    var result = Int.min
    combos.forEach {
        var output = 0
        for instruction in $0 {
            let computer = Computer()
            computer.parseProgram(string)
            computer.boot()
            computer.stdin = [instruction, output]
            computer.run()
            output = computer.stdout.last ?? -1
        }
        result = output > result ? output : result
    }

    return result
}

func makeCombinations(_ array: [Int]) -> [[Int]] {
    guard array.count > 1 else { return [array] }
    var result: [[Int]] = []
    for (index, item) in array.enumerated() {
        var newArray = array
        newArray.remove(at: index)
        let subResult = makeCombinations(newArray)
        let itemResult = subResult.map { [item] + $0 }
        vprint("Sub result: \(subResult)")
        result.append(contentsOf: itemResult)
    }
    return result
}

//print(solvePart1(test1))
assert(solvePart1(test1) == 43210)
assert(solvePart1(test2) == 65210)

// MARK: Part 2
func solvePart2(_ string: String) -> Int {
    let combos = makeCombinations([9,8,7,6,5])
    var result = Int.min
    combos.forEach { combo in
        var output = [0]
        let computers = (0..<5).map { i -> Computer in
            let computer = Computer()
            computer.parseProgram(string)
            computer.stdin.append(combo[i])
            computer.boot()
            return computer
        }
        var exitCode = Array(repeating: 1, count: 5) {
            didSet { vprint("Exit code changed to: \(exitCode)\n") }
        }
        while exitCode != [0,0,0,0,0] {
            for index in 0..<computers.count {
                computers[index].stdin += output
                exitCode[index] = computers[index].run()
                vprint("Stdin: \(computers[index].stdin)")
                vprint("Stdout: \(computers[index].stdout)")
                output = computers[index].stdout
            }
            if let last = output.last, last > result {
                result = last
            }
        }
    }

    return result
}

//print(solvePart2(test3))
assert(solvePart2(test3) == 139629729)
assert(solvePart2(test4) == 18216)

// MARK: Execution
func findAnswers(_ string: String) {
    var string = string
    if string.isEmpty { string = test1 }

    var startTime = CFAbsoluteTimeGetCurrent()
    let answer1 = solvePart1(string)
    print("Part 1 Answer: \(answer1)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")

    if string == test1 { string = test4 }

    startTime = CFAbsoluteTimeGetCurrent()
    let answer2 = solvePart2(string)
    print("Part 2 Answer: \(answer2)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
}

findAnswers(input)
