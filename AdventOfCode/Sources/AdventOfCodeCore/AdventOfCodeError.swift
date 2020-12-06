import Foundation

enum AdventOfCodeError: Error, LocalizedError {
    case noSolutionFound
    case noInputFound

    var errorDescription: String? {
        switch self {
        case .noSolutionFound: return "Couldn't find a solution class for that day"
        case .noInputFound: return "Couldn't find an input file for that day"
        }
    }
}
