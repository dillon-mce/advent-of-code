import XCTest
@testable import AdventOfCodeCore

final class Day2Tests: XCTestCase {
    let sut = Day2()

    let test1 = """
    1-3 a: abcde
    1-3 b: cdefg
    2-9 c: ccccccccc
    """

    func test_Part1() {
        // given
        let expectedResult = "2"

        // when
        let result = sut.solvePart1(test1)

        // then
        XCTAssertEqual(expectedResult, result)
    }

    func test_Part2() {
        // given
        let expectedResult = "1"

        // when
        let result = sut.solvePart2(test1)

        // then
        XCTAssertEqual(expectedResult, result)
    }
}
