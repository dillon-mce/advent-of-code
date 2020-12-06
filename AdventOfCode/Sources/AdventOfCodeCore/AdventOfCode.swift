import Foundation

public final class AdventOfCode {

    public init() {}

    let printer = Printer()
    let loader = Loader()
    let executor = Executor()

    public func run(_ day: Int) throws {
        printer.printHeader(for: day)
        let solution = try loader.solution(for: day)
        let input = try loader.input(for: day)
        executor.run(solution, with: input)
    }
}
