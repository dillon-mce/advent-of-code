#!/usr/bin/swift
import Cocoa

// MARK: Input Handling
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 4"
day += input == "" ? " – TEST" : ""
let underscores = Array(repeating: "—", count: day.count).joined()

print("\n\(underscores)\n\(day)\n\(underscores)")

// MARK: Helpers
func hasDouble(_ int: Int) -> Bool {
    let digits = String(int).map { String($0) }

    for i in 0..<digits.count-1 {
        if digits[i] == digits[i+1] { return true }
    }
    return false
}

func hasOnlyDouble(_ int: Int) -> Bool {
    let digits = String(int).map { String($0) }
    for i in 1..<digits.count-2 {
        if digits[i] == digits[i+1]
            && digits[i-1] != digits[i]
            && digits[i+2] != digits[i] { return true }
    }
    if digits[0] == digits[1] && digits[1] != digits[2] { return true }
    if digits[4] == digits[5] && digits[4] != digits[3] { return true }
    return false
}

func isIncreasing(_ int: Int) -> Bool {
    let digits = String(int).compactMap { Int(String($0)) }

    for i in 0..<digits.count-1 {
        if digits[i] > digits[i+1] { return false }
    }
    return true
}

// MARK: Tests
let test1 = "265275 781584"

// MARK: Part 1
func solvePart1(_ string: String) -> Int {
    let array = string.components(separatedBy: " ").compactMap { Int($0) }
    return (array[0]...array[1]).reduce(0) {
        $0 + (hasDouble($1) && isIncreasing($1) ? 1 : 0)
    }
}

// MARK: Part 2
func solvePart2(_ string: String) -> Int {
    let array = string.components(separatedBy: " ").compactMap { Int($0) }
    return (array[0]...array[1]).reduce(0) {
        $0 + (hasOnlyDouble($1) && isIncreasing($1) ? 1 : 0)
    }
}

// MARK: Execution
func findAnswers(_ string: String) {
    var string = string
    if string.isEmpty { string = test1 }

    var startTime = CFAbsoluteTimeGetCurrent()
    let answer1 = solvePart1(string)
    print("Part 1 Answer: \(answer1)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")

    startTime = CFAbsoluteTimeGetCurrent()
    let answer2 = solvePart2(string)
    print("Part 2 Answer: \(answer2)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
}

findAnswers(input)
