import AdventOfCodeCore
import ArgumentParser

struct AdventOfCodeRunner: ParsableCommand {

    static let adventOfCode = AdventOfCode()

    @Flag(name: .shortAndLong, help: "Interactive mode")
    var interactive = false

    public mutating func run() throws {
        while interactive {
            try interactiveRun()
        }
    }

    private mutating func interactiveRun() throws {
        print("What day do you want to run?")
        guard let input = readLine() else { throw AdventOfCodeError.invalidInput }
        if let day = Int(input) {
            try Self.adventOfCode.run(day)
        } else if input == "exit" {
            interactive = false
        } else {
            throw AdventOfCodeError.invalidInput
        }
    }
}

AdventOfCodeRunner.main()

enum AdventOfCodeError: Error {
    case invalidInput
}
