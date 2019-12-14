#!/usr/bin/swift
import Cocoa

// MARK: Input Handling
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 11"
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

//MARK: Point

struct Point: Hashable, CustomStringConvertible, Comparable {
    let x: Int
    let y: Int

    func distance(from point: Point) -> Int {
        return abs(x - point.x) + abs(y - point.y)
    }

    var description: String {
        return "(\(x), \(y))"
    }

    static let zero = Point(x: 0, y: 0)

    func adding(_ point: Point) -> Point {
        let x = self.x + point.x
        let y = self.y + point.y
        return Point(x: x, y: y)
    }

    func reducedToPrime() -> Point {
        var divisor = 2
        var newX = self.x
        var newY = self.y

        while divisor < newX && divisor < newY {
            if newX % divisor == 0 && newY % divisor == 0 {
                newX /= divisor
                newY /= divisor
            } else {
                divisor += 1
            }
        }
        return Point(x: newX, y: newY)
    }

    func move(_ direction: Direction) -> Point {
        switch direction {
        case .up:
            return self.adding(Point(x: 0, y: 1))
        case .down:
            return self.adding(Point(x: 0, y: -1))
        case .right:
            return self.adding(Point(x: 1, y: 0))
        case .left:
            return self.adding(Point(x: -1, y: 0))
        }
    }

    static func < (lhs: Point, rhs: Point) -> Bool {
        return lhs.x < rhs.x || lhs.y < rhs.y
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

    func getStdout() -> Int {
        if stdout.count > 0 {
            return stdout.removeFirst()
        } else {
            print("stdout doesn't have enough elements.")
            return -1
        }
    }

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

enum Direction {
    case up, down, right, left

    func turnRight() -> Direction {
        switch self {
        case .up:
            return .right
        case .down:
            return .left
        case .right:
            return .down
        case .left:
            return .up
        }
    }

    func turnLeft() -> Direction {
        switch self {
        case .up:
            return .left
        case .down:
            return .right
        case .right:
            return .up
        case .left:
            return .down
        }
    }
}


// MARK: Tests
let test1 = ""
let test2 = ""

// MARK: Part 1
func solvePart1(_ string: String) -> String {
    let panels = paint(program: string, start: 0)
//    print(panels)
    return "\(panels.count)"
}

func paint(program: String, start: Int) -> [Point: Int]{
    var panels: [Point: Int] = [:]
    var currentPoint: Point = .zero
    var currentDirection: Direction = .up
    let computer = Computer()
    computer.parseProgram(program)
    computer.boot()
    computer.stdin = [start]
    var errorCode = -1

    while errorCode != 0 {
        errorCode = computer.run()
        vprint("Stdout: \(computer.stdout)")
        vprint("Painting point \(currentPoint)")
        panels[currentPoint] = computer.getStdout()
        let direction = computer.getStdout()
        if direction == 0 {
            currentDirection = currentDirection.turnLeft()
        } else if direction == 1 {
            currentDirection = currentDirection.turnRight()
        } else {
            print("Got a unexpected direction: \(direction)")
        }
        currentPoint = currentPoint.move(currentDirection)
        computer.stdin.append(panels[currentPoint] ?? 0)
    }

    return panels
}

//print(solvePart1(test1))
//assert(solvePart1(test1) == 12)

// MARK: Part 2
func solvePart2(_ string: String) -> String {
    let panels = paint(program: string, start: 1)
    let minX = panels.keys.min { $0.x < $1.x }?.x ?? 0
    let minY = panels.keys.min { $0.y < $1.y }?.y ?? 0
    let maxX = panels.keys.max { $0.x < $1.x }?.x ?? 0
    let maxY = panels.keys.max { $0.y < $1.y }?.y ?? 0
    let dX = abs(minX)
    let dY = abs(minY)
    let width = maxX - maxY
    let height = maxY - minY

    var map = (0...height).map { _ in
        (0...width).map { _ in
            " "
        }
    }

    panels.forEach {
        map[$0.key.y+dY][$0.key.x+dX] = $0.value == 0 ? " " : "\($0.value)"
    }

    return map.map { $0.joined() }
        .joined(separator: "\n")
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
    print("Part 2 Answer:\n\(answer2)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
}

findAnswers(input)
