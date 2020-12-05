#!/usr/bin/swift
import Cocoa

// MARK: Input Handling
let input = UserDefaults.standard.string(forKey: "input") ?? ""
var day = "DAY 5"
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

struct Seat {
    let row: Int
    let column: Int
    var id: Int { row * 8 + column }

    init(_ string: String) {
        let array = Array(string)
        let rowRep = array[0..<7]
        let columnRep = array[7...]

        row = rowRep.reduceBinary("F", range: (0, 127))
        column = columnRep.reduceBinary("L", range: (0, 7))
    }
}

extension Sequence where Element: Equatable {
    func reduceBinary(_ significant: Element, range: (Int, Int)) -> Int {
        self.reduce(range) {
            $1 == significant ?
            ($0.0, $0.1 - (($0.1-$0.0)/2 + 1)) :
            ($0.0 + (($0.1-$0.0)/2 + 1), $0.1)
        }.0
    }
}

private func parseInput(_ string: String) -> [Seat] {
    string.components(separatedBy: .newlines).map(Seat.init)
}

// MARK: Tests
let test1 = "FBFBBFFRLR"
let test2 = "BFFFBBFRRR"
let test3 = "FFFBBBFRRR"
let test4 = "BBFFBBFRLL"

// MARK: Part 1
func solvePart1(_ string: String) -> String {
    let seats = parseInput(string)
    vprint("\(seats)")
    let answer = seats.map(\.id).max() ?? 0
    return "\(answer)"
}

assert(Seat(test1).id == 357)
assert(Seat(test2).id == 567)
assert(Seat(test3).id == 119)
assert(Seat(test4).id == 820)
//print(solvePart1(test1))
//assert(solvePart1(test1) == 12)

// MARK: Part 2
func solvePart2(_ string: String) -> String {
    let seats = parseInput(string)
    let set = Set(seats.map(\.id))
    let answer = (0..<864).first {
        !set.contains($0) &&
        set.contains($0 + 1) &&
        set.contains($0 - 1)
    } ?? 0
    return "\(answer)"
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
