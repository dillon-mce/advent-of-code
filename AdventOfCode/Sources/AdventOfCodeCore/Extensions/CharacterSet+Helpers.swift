import Foundation

extension CharacterSet: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(charactersIn: "\(value)")
    }
}
