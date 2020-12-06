import Foundation

extension Sequence where Element: Hashable {
    func counts() -> [Element: Int] {
        self.reduce(into: [Element: Int]()) {
            $0[$1, default: 0] += 1
        }
    }
}
