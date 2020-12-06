import XCTest
@testable import AdventOfCodeCore

final class Day5Tests: XCTestCase {
    let sut = Day5()

    let test1 = "FBFBBFFRLR"
    let test2 = "BFFFBBFRRR"
    let test3 = "FFFBBBFRRR"
    let test4 = "BBFFBBFRLL"

    func test_Part1_test1() {
        // given
        let expectedResult = "357"

        // when
        let result = sut.solvePart1(test1)

        // then
        XCTAssertEqual(expectedResult, result)
    }

    func test_Part1_test2() {
        // given
        let expectedResult = "567"

        // when
        let result = sut.solvePart1(test2)

        // then
        XCTAssertEqual(expectedResult, result)
    }

    func test_Part1_test3() {
        // given
        let expectedResult = "119"

        // when
        let result = sut.solvePart1(test3)

        // then
        XCTAssertEqual(expectedResult, result)
    }

    func test_Part1_test4() {
        // given
        let expectedResult = "820"

        // when
        let result = sut.solvePart1(test4)

        // then
        XCTAssertEqual(expectedResult, result)
    }
}
