import Foundation

struct Day4: Solution {

    private func parseInput(_ string: String) -> [Passport] {
        string.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "\n\n").compactMap(Passport.init)
    }

    func solvePart1(_ string: String) -> String {
        let input = parseInput(string)

        return "\(input.count)"
    }

    func solvePart2(_ string: String) -> String {
        let input = parseInput(string)
        let valid = input.filter { $0.isValid() }
        return "\(valid.count)"
    }
}

extension Day4 {
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
                  let _ = Color(hairColor),
                  let _ = EyeColor(rawValue: eyeColor),
                  let _ = Int(id) else { return false }

            let isValid = birthYear >= 1920 &&
                birthYear <= 2002 &&
                issueYear >= 2010 &&
                issueYear <= 2020 &&
                expirationYear >= 2020 &&
                expirationYear <= 2030 &&
                height.isValid &&
                id.count == 9
            return isValid
        }
    }
}
