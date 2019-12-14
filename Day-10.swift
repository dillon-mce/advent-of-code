#!/usr/bin/swift
import Cocoa

// MARK: Input Handling
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 10"
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

    static func < (lhs: Point, rhs: Point) -> Bool {
        return lhs.x < rhs.x || lhs.y < rhs.y
    }
}

// MARK: Tests
let test1 = """
.#..#
.....
#####
....#
...##
"""
let test2 = ""

// MARK: Part 1
func solvePart1(_ string: String) -> String {
    let map = string.components(separatedBy: .newlines).map { $0.map { String($0) } }
//    var dict: [Point: Set<Point>] = [:]
    let points = findVisiblePoints(from: Point(x: 1, y: 0), on: map)
    print(points.count)
    for y in 0..<map.count {
        let line = map[y]
        for x in 0..<line.count {
            guard map[y][x] == "#" else { continue }
            print("Checking point (\(x), \(y))")
        }
    }
    return "Answer part 1 here"
}

func findVisiblePoints(from point: Point, on map: [[String]]) -> Set<Point> {
    var result: Set<Point> = []
    let maxHeight = map.count-1
    let maxWidth = map[0].count-1
    let endPoint = Point(x: maxWidth, y: maxHeight)
    let lines = getCombinationsOfLines(dX: -maxWidth...maxWidth, dY: -maxHeight...maxHeight)
    var points = lines.map { (point, $0) }
    while points.count > 0 {
        // update to the next set of points
        points = points.map { ($0.0.adding($0.1), $0.1) }
        // filter out the ones that are off the map
        points = points.filter { $0.0 >= .zero && $0.0 <= endPoint }
        // get a set of those that are astroids
        var set: Set<Point> = []
        points.forEach {
            let current = $0.0
            print("Checking \(current): \(map[current.y][current.x])")

            if map[current.y][current.x] == "#" {
                print("--> \(current)")
                set.insert(current)
            }
        }

        // filter out the ones we found
        points = points.filter { !set.contains($0.0) }
        print("Points: \(points)")
        // add them to the set
        result = result.union(set)
    }

    return result
}

func getCombinationsOfLines(dX: ClosedRange<Int>, dY: ClosedRange<Int>) -> Set<Point> {
    var result: Set<Point> = []
    for x in dX {
        for y in dY {
            let point = Point(x: x, y: y)
            result.insert(point.reducedToPrime())
        }
    }
    return result
}

//print(solvePart1(test1))
//assert(solvePart1(test1) == 12)

// MARK: Part 2
func solvePart2(_ string: String) -> String {

    return "Answer part 2 here"
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
