#!/usr/bin/swift
import Cocoa

// MARK: Input Handling
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 1"
day += input == "" ? " – TEST" : ""
let underscores = Array(repeating: "—", count: day.count).joined()

print("\n\(underscores)\n\(day)\n\(underscores)")

// MARK: Reusable Types
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

// MARK: Tests
let test1 = """
1721
979
366
299
675
1456
"""
let test2 = ""

// MARK: Part 1
func solvePart1(_ string: String) -> String {
    let numbers = parseInput(string)
    if let answer = findXThatSum(2020, current: numbers) {
        return "\(answer.reduce(1, *))"
    }
    return "Answer part 1 here"
}

private func parseInput(_ string: String) -> [Int] {
    string.components(separatedBy: .newlines)
        .compactMap(Int.init)
}



//print(solvePart1(test1))
assert(solvePart1(test1) == "514579")

// MARK: Part 2
func solvePart2(_ string: String) -> String {
    let numbers = parseInput(string)
    let dict = numbers.reduce(into: [Int:Int]()) {
        $0[$1] = 2020 - $1
    }

    for (key, value) in dict {
        if let answer = findXThatSum(value, current: numbers) {
            return "\(([key] + answer).reduce(1, *))"
        }
    }

    return "Answer part 2 here"
}

//print(solvePart2(test1))
assert(solvePart2(test1) == "241861950")

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
