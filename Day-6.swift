#!/usr/bin/swift
import Cocoa

// MARK: Input Handling
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 6"
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

struct Queue<T> {
    var array: [T?] = []
    var head = 0

    var isEmpty: Bool {
        return count == 0
    }

    var count: Int {
        return array.count - head
    }

    mutating func enqueue(_ element: T) {
        array.append(element)
    }

    mutating func dequeue() -> T? {
        guard head < array.count, let element = array[head] else { return nil }

        array[head] = nil
        head += 1

        resetHead()

        return element
    }

    private mutating func resetHead() {
        let percentage = Double(head)/Double(array.count)
        if array.count > 50 && percentage > 0.25 {
            array.removeFirst(head)
            head = 0
        }
    }

    var front: T? {
        if isEmpty {
            return nil
        } else {
            return array[head]
        }
    }
}

// MARK: Tests
let test1 = """
COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L
"""
let test2 = """
COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L
K)YOU
I)SAN
"""

// MARK: Part 1
func solvePart1(_ string: String) -> Int {
    let dict = parseInput(string)
    let indirects = calculateOrbits(dict)
    let sum = indirects.values.reduce(0, +)

    return sum
}

func parseInput(_ string: String) -> [String: [String]] {
    let lines = string.components(separatedBy: .newlines).map { $0.components(separatedBy: ")")}
    var dict: [String: [String]] = [:]
    lines.forEach {
        let key = $0[0]
        let value = $0[1]
        dict[key, default: []].append(value)
        dict[value, default: []].append(key)
    }
    return dict
}

func calculateOrbits(_ dict: [String: [String]]) -> [String: Int] {
    var queue = Queue<String>()
    let center = "COM"
    queue.enqueue(center)
    var result: [String: Int] = [center: 0]

    while queue.count > 0 {

        guard let current = queue.dequeue(),
            let array = dict[current] else { continue }
        for orbiting in array {
            if result[orbiting] == nil {
                result[orbiting] = result[current, default: 0] + 1
                queue.enqueue(orbiting)
            }
        }
    }

    return result
}

//print(solvePart1(test1))
assert(solvePart1(test1) == 42)

// MARK: Part 2
func solvePart2(_ string: String) -> Int {
    let dict = parseInput(string)
    let jumps = calculateJumps(dict, from: "YOU", to: "SAN")
    return jumps
}

func calculateJumps(_ dict: [String: [String]], from start: String, to end: String) -> Int {
    var stack: [String] = []
    var visited: Set<String> = []
    var parents: [String: String] = [:]
    var path: [String] = []
    stack.append(start)

    while stack.count > 0 {
        let current = stack.popLast()!
        vprint("Checking current: \(current)")
        if current == end {
            path.append(current)
            var parent = parents[current]
            while let uParent = parent {
                path.append(uParent)
                parent = parents[uParent]
            }
            vprint("Path: \(path)")
            return path.count - 3
        }
        visited.insert(current)
        guard let array = dict[current] else {
            print("Current (\(current)) wasn't found in the dictionary")
            continue
        }
        vprint("Array: \(array)")
        for orbiting in array {
            if !visited.contains(orbiting) {
                parents[orbiting] = current
                stack.append(orbiting)
            }
        }
    }
    return -1
}

//print(solvePart2(test2))
assert(solvePart2(test2) == 4)

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