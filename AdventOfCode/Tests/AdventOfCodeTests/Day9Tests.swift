import XCTest
@testable import AdventOfCodeCore

final class Day9Tests: XCTestCase {
    let sut = Day9(length: 5)

    let test1 = """
    35
    20
    15
    25
    47
    40
    62
    55
    65
    95
    102
    117
    150
    182
    127
    219
    299
    277
    309
    576
    """

    func test_Part1() {
        // given
        let expectedResult = "127"

        // when
        let result = sut.solvePart1(test1)

        // then
        XCTAssertEqual(expectedResult, result)
    }

    func test_Part2() {
        // given
        let expectedResult = "62"

        // when
        let result = sut.solvePart2(test1)

        // then
        XCTAssertEqual(expectedResult, result)
    }
}
