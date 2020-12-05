#!/usr/bin/swift
import Cocoa

// MARK: Input Handling
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 4"
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

enum EyeColor: String {
    case amber = "amb"
    case blue = "blu"
    case brown = "brn"
    case gray = "gry"
    case green = "grn"
    case hazel = "hzl"
    case other = "oth"
}

struct Color {
    var hexValue: Int

    init?(_ string: String) {
        guard string.hasPrefix("#"),
              let value = Int(string.dropFirst(), radix: 16),
              value >= 0, value <= 0xFFFFFF else { return nil }
        hexValue = value
    }
}

struct Height {
    enum System {
        case imperial, metric
    }

    let value: Int
    let system: System

    init?(_ string: String) {
        if string.hasSuffix("cm") {
            system = .metric
        } else if string.hasSuffix("in") {
            system = .imperial
        } else {
            return nil
        }

        guard let value = Int(string.dropLast(2)) else { return nil }
        self.value = value
    }

    var isValid: Bool {
        switch system {
        case .imperial:
            return value >= 59 && value <= 76
        case .metric:
            return value >= 150 && value <= 193
        }
    }
}

struct Passport {
    let birthYear: String
    let issueYear: String
    let expirationYear: String
    let height: String
    let hairColor: String
    let eyeColor: String
    let id: String
    let countryId: String?

    init?(string: String) {
        let dict = string.components(separatedBy: .whitespacesAndNewlines).reduce(into: [String: String]()) {
            let halves = $1.components(separatedBy: ":")
            guard let first = halves.first, let second = halves.last else { return }
            $0[first] = second
        }
        guard let birthYear = dict["byr"],
        let issueYear = dict["iyr"],
        let expirationYear = dict["eyr"],
        let height = dict["hgt"],
        let hairColor = dict["hcl"],
        let eyeColor = dict["ecl"],
        let id = dict["pid"] else { return nil }

        self.birthYear = birthYear
        self.issueYear = issueYear
        self.expirationYear = expirationYear
        self.height = height
        self.hairColor = hairColor
        self.eyeColor = eyeColor
        self.id = id
        self.countryId = dict["cid"]
    }

    func isValid() -> Bool {
        guard let birthYear = Int(birthYear),
              let issueYear = Int(issueYear),
              let expirationYear = Int(expirationYear),
              let height = Height(height),
              let hairColor = Color(hairColor),
              let eyeColor = EyeColor(rawValue: eyeColor),
              let passportId = Int(id) else { return false }

        let isValid = birthYear >= 1920 &&
            birthYear <= 2002 &&
            issueYear >= 2010 &&
            issueYear <= 2020 &&
            expirationYear >= 2020 &&
            expirationYear <= 2030 &&
            height.isValid &&
            id.count == 9
        true
        return isValid
    }
}

private func parseInput(_ string: String) -> [Passport] {
    string.components(separatedBy: "\n\n").compactMap(Passport.init)
}

// MARK: Tests
let test1 = """
ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in
"""
let test2 = """
pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f

eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022

iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
"""

let test3 = """
eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946

hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007
"""

// MARK: Part 1
func solvePart1(_ string: String) -> String {
    let passports = parseInput(string)
    return "\(passports.count)"
}

//print(solvePart1(test1))
assert(solvePart1(test1) == "2")

// MARK: Part 2
func solvePart2(_ string: String) -> String {
    let passports = parseInput(string)
    let valid = passports.filter { $0.isValid() }
    return "\(valid.count)"
}

//print(solvePart2(test3))
//print(solvePart2(test2))
assert(solvePart2(test2) == "4")
assert(solvePart2(test3) == "0")

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
