#!/usr/bin/swift
import Cocoa

// MARK: Input Handling
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 12"
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

extension Int {
    var isPrime: Bool {
        guard self > 0 else { return false }
        guard self > 3 else { return true }
        let limit = Int(sqrt(Double(self))) + 1
        for i in 2...limit {
            if self % i == 0 { return false }
        }
        return true
    }
}

var lastPrime = 1
func getNextPrime() -> Int {
    var current = lastPrime
    while true {
        current += 1
        if current.isPrime {
            lastPrime = current
            return current
        }
    }
}

func calculateLCM(_ set: Set<Int>) -> Int {
    var accumulator: [Int] = []
    var set = set

    while set != [1] {
        let prime = getNextPrime()
        var goAgain = true
        while goAgain {
            let newSet = Set(set.map { $0 % prime == 0 ? $0 / prime : $0 })
            goAgain = set != newSet
            if set != newSet {
                set = newSet
                accumulator.append(prime)
            }
        }
        vprint("Set: \(set), acc: \(accumulator)")
    }

    return accumulator.reduce(1, *)
}


extension CharacterSet {
    static func charactersIn(_ string: String) -> CharacterSet {
        var characterSet = CharacterSet()
        characterSet.insert(charactersIn: string)
        return characterSet
    }
}

struct Point: Hashable, CustomStringConvertible {
    let x: Int
    let y: Int
    let z: Int

    init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }

    init?(array: [Int]) {
        guard array.count > 2 else { return nil }
        self.init(x: array[0], y: array [1], z: array[2])
    }

    var description: String {
        return "(\(x), \(y), \(z))"
    }

    static let zero = Point(x: 0, y: 0, z: 0)

    func adding(_ point: Point) -> Point {
        let x = self.x + point.x
        let y = self.y + point.y
        let z = self.z + point.z
        return Point(x: x, y: y, z: z)
    }

    var absoluteValue: Int {
        return abs(x) + abs(y) + abs(z)
    }
}

extension PartialKeyPath where Root == Point {
    var string: String {
        switch self {
        case \Point.x: return "X"
        case \Point.y: return "Y"
        case \Point.z: return "Z"
        default: fatalError("Unexpected key path")
        }
    }
}

struct Moon: CustomStringConvertible, Hashable {
    var position: Point
    var velocity: Point

    init(position: Point, velocity: Point) {
        self.position = position
        self.velocity = velocity
    }

    init(string: String) {
        let elements = string.components(separatedBy: .charactersIn("<=, >")).compactMap { Int($0) }
        let position = Point(array: elements) ?? .zero
        self.init(position: position, velocity: .zero)
    }

    var description: String {
        return "<pos=\(position), vel=\(velocity))"
    }
}

// MARK: Tests
let test1 = """
<x=-1, y=0, z=2>
<x=2, y=-10, z=-7>
<x=4, y=-8, z=8>
<x=3, y=5, z=-1>
"""
let test2 = """
<x=-8, y=-10, z=0>
<x=5, y=5, z=10>
<x=2, y=-7, z=3>
<x=9, y=-8, z=-3>
"""

// MARK: Part 1
func solvePart1(_ string: String) -> Int {
    var moons = string.components(separatedBy: .newlines).map { Moon(string: $0) }
    printMoons(moons)
    (0..<1000).forEach { _ in
        moons = updateVelocities(moons)
        moons = updatePositions(moons)
    }
    printMoons(moons)

    return calculateTotalEnergy(moons)
}

func updateVelocities(_ moons: [Moon]) -> [Moon] {
    var result: [Moon] = []
    for moon in moons {
        let (x,y,z) = moons.reduce((0,0,0)) {
            let x: Int
            if moon.position.x < $1.position.x {
                x = 1
            } else if moon.position.x > $1.position.x {
                x = -1
            } else {
                x = 0
            }
            let y: Int
            if moon.position.y < $1.position.y {
                y = 1
            } else if moon.position.y > $1.position.y {
                y = -1
            } else {
                y = 0
            }
            let z: Int
            if moon.position.z < $1.position.z {
                z = 1
            } else if moon.position.z > $1.position.z {
                z = -1
            } else {
                z = 0
            }
            return ($0.0 + x, $0.1 + y, $0.2 + z)
        }
        let velocity = Point(x: x, y: y, z:z).adding(moon.velocity)
        let newMoon = Moon(position: moon.position, velocity: velocity)
            result.append(newMoon)
    }
    return result
}

func updatePositions(_ moons: [Moon]) -> [Moon] {
    return moons.map {
        Moon(position: $0.position.adding($0.velocity), velocity: $0.velocity)
    }
}

func calculateTotalEnergy(_ moons: [Moon]) -> Int {
    return moons.map { $0.position.absoluteValue * $0.velocity.absoluteValue }.reduce(0, +)
}

func printMoons(_ moons: [Moon]) {
    moons.forEach { vprint("\($0)") }
    vprint("")
}

//assert(solvePart1(test1) == 293)
//assert(solvePart1(test2) == 1940)

// MARK: Part 2
func solvePart2(_ string: String) -> Int {
    let moons = string.components(separatedBy: .newlines).map { Moon(string: $0) }

    let x = calculateRepetition(moons, by: \.x)
    let y = calculateRepetition(moons, by: \.y)
    let z = calculateRepetition(moons, by: \.z)

    vprint("X: \(x), Y: \(y), Z: \(z)")

    return calculateLCM(Set([x,y,z]))
}

func calculateRepetition(_ moons: [Moon], by keypath: KeyPath<Point, Int>) -> Int {
    var moons = moons
    var previousStates: Set<([Int])> = [moons.flatMap{ [$0.position[keyPath: keypath], $0.velocity[keyPath: keypath]] }]
    var counter = 0
    var last = 0
    var deltas = 0
    while counter < 1000000 {
        counter += 1
        moons = updateVelocities(moons)
        moons = updatePositions(moons)
        let new = moons.flatMap{ [$0.position[keyPath: keypath], $0.velocity[keyPath: keypath]] }
        if previousStates.contains(new) {
            vprint("\(keypath.string) axis repeats at \(counter)\tdelta: \(counter-last)")
            if counter-last == 1 {
                deltas += 1
                if deltas > 5 { return counter - 6}
            } else {
                deltas = 0
            }
            last = counter
        }
        previousStates.insert(new)
    }
    return -1
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

    if string == test1 { string = test1 }

    startTime = CFAbsoluteTimeGetCurrent()
    let answer2 = solvePart2(string)
    print("Part 2 Answer: \(answer2)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
}

findAnswers(input)
