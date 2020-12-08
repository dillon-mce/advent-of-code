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
        case 2: return Day2()
        case 3: return Day3()
        case 4: return Day4()
        case 5: return Day5()
        case 6: return Day6()
        case 7: return Day7()
        case 8: return Day8()
        default: throw AdventOfCodeError.noSolutionFound
        }
    }
}
