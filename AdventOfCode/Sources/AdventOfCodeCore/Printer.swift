import Foundation

struct Printer {
    func printHeader(for day: Int) {
        let title = "   DAY \(day)   "
        printBanner(title)
    }

    func printBanner(_ string: String) {
        let underscores = Array(repeating: "-", count: string.count).joined()
        print("\n\(underscores)\n\(string)\n\(underscores)")
    }
}
