import XCTest
@testable import AdventOfCodeCore

final class Day10Tests: XCTestCase {
    let sut = Day10()

    let test1 = """
    16
    10
    15
    5
    1
    11
    7
    19
    6
    12
    4
    """

    let test2 = """
    28
    33
    18
    42
    31
    14
    46
    20
    48
    47
    24
    23
    49
    45
    19
    38
    39
    11
    1
    32
    25
    35
    8
    17
    7
    9
    4
    2
    34
    10
    3
    """

    func test_Part1_first() {
        // given
        let expectedResult = "35"

        // when
        let result = sut.solvePart1(test1)

        // then
        XCTAssertEqual(expectedResult, result)
    }

    func test_Part1_second() {
        // given
        let expectedResult = "220"

        // when
        let result = sut.solvePart1(test2)

        // then
        XCTAssertEqual(expectedResult, result)
    }

    func test_Part2_first() {
        // given
        let expectedResult = "8"

        // when
        let result = sut.solvePart2(test1)

        // then
        XCTAssertEqual(expectedResult, result)
    }

    func test_Part2_second() {
        // given
        let expectedResult = "19208"

        // when
        let result = sut.solvePart2(test2)

        // then
        XCTAssertEqual(expectedResult, result)
    }
}
