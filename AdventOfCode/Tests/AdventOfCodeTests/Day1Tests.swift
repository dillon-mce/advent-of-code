import XCTest
@testable import AdventOfCodeCore

final class Day1Tests: XCTestCase {
    let sut = Day1()

    let test1 = """
    199
    200
    208
    210
    200
    207
    240
    269
    260
    263
    """

    func test_Part1() {
        // given
        let expectedResult = "7"

        // when
        let result = sut.solvePart1(test1)

        // then
        XCTAssertEqual(expectedResult, result)
    }

    func test_Part2() {
        // given
        let expectedResult = "5"

        // when
        let result = sut.solvePart2(test1)

        // then
        XCTAssertEqual(expectedResult, result)
    }
}
