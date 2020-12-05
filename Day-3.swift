#!/usr/bin/swift
import Cocoa

// MARK: Input Handling
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 3"
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

private func parseInput(_ string: String) -> [[Character]] {
    string.components(separatedBy: .newlines)
        .map(Array.init)
}

private func countTrees(in map: [[Character]], dX: Int, dY: Int) -> Int {
    var x = 0, y = 0, result = 0, length = map.first?.count ?? 1
    while y < map.count {
        result += map[y][x] == "#" ? 1 : 0

        x += dX
        x %= length
        y += dY
    }
    return result
}

// MARK: Tests
let test1 = """
..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#
"""
let test2 = ""

// MARK: Part 1
func solvePart1(_ string: String) -> String {
    let lines = parseInput(string)
    let result = countTrees(in: lines, dX: 3, dY: 1)
    return "\(result)"
}

//print(solvePart1(test1))
assert(solvePart1(test1) == "7")

// MARK: Part 2
func solvePart2(_ string: String) -> String {
    let map = parseInput(string)
    let slopes = [
        (1, 1),
        (3, 1),
        (5, 1),
        (7, 1),
        (1, 2)
    ]
    let result = slopes.map { countTrees(in: map, dX: $0.0, dY: $0.1) }
        .reduce(1, *)
    return "\(result)"
}

print(solvePart2(test1))
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
