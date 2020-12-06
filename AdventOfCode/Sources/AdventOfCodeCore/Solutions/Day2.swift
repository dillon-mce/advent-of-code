import Foundation

struct Day2: Solution {

    private func parseInput(_ string: String) -> [Password] {
        string.components(separatedBy: .newlines)
            .compactMap(Password.init)
    }

    func solvePart1(_ string: String) -> String {
        let input = parseInput(string)
        let validPasswords = input.filter { $0.isValid() }

        return "\(validPasswords.count)"
    }

    func solvePart2(_ string: String) -> String {
        let input = parseInput(string)
        let validPasswords = input.filter { $0.isValid2() }

        return "\(validPasswords.count)"
    }
}

extension Day2 {
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
}
