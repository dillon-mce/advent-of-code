import XCTest
@testable import AdventOfCodeCore

final class Day6Tests: XCTestCase {
    let sut = Day6()

    let test1 = """
    abc

    a
    b
    c

    ab
    ac

    a
    a
    a
    a

    b
    """

    func test_Part1() {
        // given
        let expectedResult = "11"

        // when
        let result = sut.solvePart1(test1)

        // then
        XCTAssertEqual(expectedResult, result)
    }

    func test_Part2() {
        // given
        let expectedResult = "6"

        // when
        let result = sut.solvePart2(test1)

        // then
        XCTAssertEqual(expectedResult, result)
    }
}
