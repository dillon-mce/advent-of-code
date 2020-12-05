#!/usr/bin/swift
import Cocoa

// MARK: Input Handling
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 2"
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

struct PasswordPolicy {
    let high: Int
    let low: Int
    let letter: Character

    init?(string: String) {
        let numbers = string.components(separatedBy: CharacterSet(charactersIn: " -"))
            .compactMap(Int.init)
        guard let low = numbers.first,
              let high = numbers.last,
              let letter = string.last else { return nil }
        self.low = low
        self.high = high
        self.letter = letter
    }

    func approves(_ password: String) -> Bool {
        let count = password.filter { $0 == letter }.count
        return count >= low && count <= high
    }

    func approves2(_ password: String) -> Bool {
        let array = Array(password)
        let first = low - 1
        let second = high - 1
        guard array.count >= second else { return false }
        let firstMatches = array[first] == letter
        let secondMatches = array[second] == letter
        return firstMatches != secondMatches
    }
}

struct Password {
    let policy: PasswordPolicy
    let password: String

    init?(string: String) {
        let halves = string.components(separatedBy: ": ")
        guard let first = halves.first,
              let password = halves.last,
              let policy = PasswordPolicy(string: first) else {
            return nil
        }
        self.policy = policy
        self.password = password
    }

    func isValid() -> Bool { policy.approves(password) }

    func isValid2() -> Bool { policy.approves2(password) }
}

// MARK: Tests
let test1 = """
1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
"""
let test2 = ""

// MARK: Part 1
func solvePart1(_ string: String) -> String {
    let passwords = parseInput(string)
    let validPasswords = passwords.filter { $0.isValid() }

    return "\(validPasswords.count)"
}

private func parseInput(_ string: String) -> [Password] {
    string.components(separatedBy: .newlines)
        .compactMap(Password.init)
}

//print(solvePart1(test1))
assert(solvePart1(test1) == "2")

// MARK: Part 2
func solvePart2(_ string: String) -> String {
    let passwords = parseInput(string)
    let validPasswords = passwords.filter { $0.isValid2() }

    return "\(validPasswords.count)"
}

//print(solvePart2(test2))
assert(solvePart2(test1) == "1")

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
