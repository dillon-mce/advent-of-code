#!/usr/bin/swift
import Cocoa

// MARK: Input Handling
let input = UserDefaults.standard.string(forKey: "input") ?? ""
var day = "DAY 6"
day += input == "" ? " – TEST" : ""
let underscores = Array(repeating: "—", count: day.count).joined()

print("\n\(underscores)\n\(day)\n\(underscores)")

// MARK: Reusable Types
let verbose = UserDefaults.standard.bool(forKey: "verbose")
let functions = false
let lines = false

func vprint(_ string: String, separator: String = " ", terminator: String = "\n", function: String = #function, line: Int = #line) {
    if verbose {
        let function = functions ? function : ""
        let line = lines ? String(line) : ""
        print(function, line, string, separator: separator, terminator: terminator)
    }
}

private func parseInput(_ string: String) -> [(String, Int)] {
    string.components(separatedBy: "\n\n")
        .map {
            let lines = $0.components(separatedBy: .whitespacesAndNewlines)
            let count = lines.count
            return (lines.joined(), count)
        }
}


extension Sequence where Element: Hashable {
    func counts() -> [Element: Int] {
        self.reduce(into: [Element: Int]()) {
            $0[$1, default: 0] += 1
        }
    }
}

// MARK: Tests
let test1 = """
abc

a
b
c

ab
ac

a
a
a
a

b
"""
let test2 = ""

// MARK: Part 1
func solvePart1(_ string: String) -> String {
    let groups = parseInput(string)
    let answer = groups.map { Set(Array($0.0)).count }
        .reduce(0, +)
    return "\(answer)"
}

//print(solvePart1(test1))
assert(solvePart1(test1) == "11")

// MARK: Part 2
func solvePart2(_ string: String) -> String {
    let groups = parseInput(string)
    let answer = groups.map { (line, count) -> Int in
        line.counts().filter {
            $0.1 == count
        }.count
    }.reduce(0, +)
    return "\(answer)"
}

//print(solvePart2(test1))
assert(solvePart2(test1) == "6")

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
