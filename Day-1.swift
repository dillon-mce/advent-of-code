#!/usr/bin/swift
import Cocoa
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 1"
day += input == "" ? " – TEST" : ""
let underscores = Array(repeating: "—", count: day.count).joined()

print("\n\(underscores)\n\(day)\n\(underscores)")

// Tests
let test1 = "12"
let test2 = "1969"
let test3 = "100756"

// Part 1
func solvePart1(_ string: String) -> Int {
    let array = string.components(separatedBy: .newlines).compactMap { Int($0) }

    return array.map{ $0 / 3 - 2 }.reduce(0, +)
}

assert(solvePart1(test1) == 2)
assert(solvePart1(test2) == 654)

// Part 2
func solvePart2(_ string: String) -> Int {
    let array = string.components(separatedBy: .newlines).compactMap { Int($0) }

    return array.map(recursiveFuel).reduce(0, +)
}

func recursiveFuel(_ num: Int) -> Int {
    guard num > 0 else {
        return 0
    }

    var fuel = num / 3 - 2
    fuel = fuel < 0 ? 0 : fuel
    return fuel + recursiveFuel(fuel)
}

assert(solvePart2(test1) == 2)
assert(solvePart2(test2) == 966)
assert(solvePart2(test3) == 50346)

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

