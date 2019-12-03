#!/usr/bin/swift
import Cocoa

// MARK: Input Handling
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 3"
day += input == "" ? " – TEST" : ""
let underscores = Array(repeating: "—", count: day.count).joined()

print("\n\(underscores)\n\(day)\n\(underscores)")

// MARK: Custom Types
struct Point: Hashable, CustomStringConvertible {
    let x: Int
    let y: Int

    func distance(from point: Point) -> Int {
        return abs(x - point.x) + abs(y - point.y)
    }

    var description: String {
        return "(\(x), \(y))"
    }

    static let zero = Point(x: 0, y: 0)
}

let testPoint1 = Point(x: 1, y: 1)
let testPoint2 = Point(x: 4, y: 4)
assert(testPoint1.distance(from: testPoint2) == 6)
assert(testPoint2.distance(from: testPoint1) == 6)

// MARK: Helpers
func calculatePointSet(for array: [String]) -> (Set<Point>, [Point: Int]) {
    var set: Set<Point> = []
    var dict: [Point: Int] = [:]
    var current = Point.zero
    var count = 0
    array.forEach { inst in
        let elements = inst.map { String($0) }
        let direction = elements[0]
        let num = Int(elements.dropFirst().joined()) ?? 0

        switch direction {
        case "U":
            for _ in 0..<num {
                let point = Point(x: current.x, y: current.y + 1)
                set.insert(point)
                current = point
                count += 1
                if dict[point] == nil {
                    dict[point] = count
                }
            }
        case "R":
            for _ in 0..<num {
                let point = Point(x: current.x + 1, y: current.y)
                set.insert(point)
                current = point
                count += 1
                if dict[point] == nil {
                    dict[point] = count
                }
            }
        case "D":
            for _ in 0..<num {
                let point = Point(x: current.x, y: current.y - 1)
                set.insert(point)
                current = point
                count += 1
                if dict[point] == nil {
                    dict[point] = count
                }
            }
        case "L":
            for _ in 0..<num {
                let point = Point(x: current.x - 1, y: current.y)
                set.insert(point)
                current = point
                count += 1
                if dict[point] == nil {
                    dict[point] = count
                }
            }
        default:
            break
        }
    }
    return (set, dict)
}

// MARK: Tests
let test1 = """
R8,U5,L5,D3
U7,R6,D4,L4
"""
let test2 = """
R75,D30,R83,U83,L12,D49,R71,U7,L72
U62,R66,U55,R34,D71,R55,D58,R83
"""

let test3 = """
R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
U98,R91,D20,R16,D67,R40,U7,R15,U6,R7
"""

// MARK: Part 1
func solvePart1(_ string: String) -> Int {
    let lines = string.components(separatedBy: .newlines).map { $0.components(separatedBy: ",") }

    let sets = lines.map { line -> Set<Point> in
        let (set, _) = calculatePointSet(for: line)
        return set
    }

    let intersections = sets.reduce(sets[0]) { $0.intersection($1) }

    let distances = intersections.map { $0.distance(from: .zero) }

    return distances.min() ?? -1
}

//print(solvePart1(test1))
assert(solvePart1(test1) == 6)
assert(solvePart1(test2) == 159)
assert(solvePart1(test3) == 135)

// MARK: Part 2
func solvePart2(_ string: String) -> Int {
    let lines = string.components(separatedBy: .newlines).map { $0.components(separatedBy: ",") }

    let tuples = lines.map { calculatePointSet(for: $0) }
    let points = tuples.map { $0.0 }
    let steps = tuples.map { $0.1 }

    let intersections = points.reduce(points[0]) { $0.intersection($1) }

    let distances: [Int] = intersections.map { point in
        return steps.reduce(0) { $0 + ($1[point] ?? 0) }
    }

    return distances.min() ?? -1
}

assert(solvePart2(test1) == 30)
assert(solvePart2(test2) == 610)
assert(solvePart2(test3) == 410)

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
