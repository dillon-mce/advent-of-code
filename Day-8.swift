#!/usr/bin/swift
import Cocoa

// MARK: Input Handling
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 8"
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

// MARK: Tests
let test1 = "123456789012"
let test2 = ""

// MARK: Part 1
func solvePart1(_ string: String) -> Int {
    let width = 25
    let height = 6
    let layers = parseInput(string, height, width)
    let layer = layers.reduce(layers[0]) { (first, second) -> [Int] in
        let firstCount = first.filter{ $0 == 0 }.count
        let secondCount = second.filter{ $0 == 0 }.count
        return firstCount < secondCount ? first : second
    }

    let ones = layer.filter { $0 == 1 }
    let twos = layer.filter { $0 == 2 }

    return ones.count * twos.count
}

func parseInput(_ string: String, _ height: Int, _ width: Int) -> [[Int]] {
    let layerSize = width * height
    let array = string.compactMap { Int(String($0)) }
    let layers = (0..<array.count/layerSize).map { i -> [Int] in
        let start = i*layerSize
        return Array(array[start..<start+layerSize])
    }
    return layers
}

// MARK: Part 2
func solvePart2(_ string: String) -> String {
    let width = 25
    let height = 6
    let layers = parseInput(string, height, width)
    var result = Array(repeating: -1, count: width*height)
    layers.reversed().forEach {
        for (index, value) in $0.enumerated() {
            if value == 2 { continue }
            result[index] = value
        }
    }
    let formattedResult = (0..<result.count/width).map { i -> [Int] in
        let start = i*width
        return Array(result[start..<start+width])
    }
    return "\n" + formattedResult.map { $0.map { String($0) }.map { $0 == "0" ? " " : $0 }.joined() }.joined(separator: "\n")
}

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
