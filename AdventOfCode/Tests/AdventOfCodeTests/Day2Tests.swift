import XCTest
@testable import AdventOfCodeCore

final class Day2Tests: XCTestCase {
    let sut = Day2()

    let test1 = """
    forward 5
    down 5
    forward 8
    up 3
    down 8
    forward 2
    """

    func test_Part1() {
        // given
        let expectedResult = "150"

        // when
        let result = sut.solvePart1(test1)

        // then
        XCTAssertEqual(expectedResult, result)
    }

    func test_Part2() {
        // given
        let expectedResult = "900"

        // when
        let result = sut.solvePart2(test1)

        // then
        XCTAssertEqual(expectedResult, result)
    }
}
