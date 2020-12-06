import Foundation

struct Executor {
    func run(_ solution: Solution, with input: String) {
        var startTime = CFAbsoluteTimeGetCurrent()
        let answer1 = solution.solvePart1(input)
        print("Part 1 Answer: \(answer1)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")

        startTime = CFAbsoluteTimeGetCurrent()
        let answer2 = solution.solvePart2(input)
        print("Part 2 Answer: \(answer2)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
    }
}
