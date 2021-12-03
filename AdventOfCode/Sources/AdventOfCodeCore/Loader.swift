import Foundation

class Loader {
    func input(for day: Int) throws -> String {
        let filename = "Day-\(day)-Input"
        guard let url = Bundle.module.url(forResource: filename, withExtension: "txt") else { throw AdventOfCodeError.noInputFound }
        return try String(contentsOf: url)
    }

    func solution(for day: Int) throws -> Solution {
        switch day {
        case 1: return Day1()
        default: throw AdventOfCodeError.noSolutionFound
        }
    }
}
