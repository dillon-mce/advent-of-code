import XCTest
@testable import AdventOfCodeCore

final class Day3Tests: XCTestCase {
    let sut = Day3()

    let test1 = """
    ..##.......
    #...#...#..
    .#....#..#.
    ..#.#...#.#
    .#...##..#.
    ..#.##.....
    .#.#.#....#
    .#........#
    #.##...#...
    #...##....#
    .#..#...#.#
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
        let expectedResult = "336"

        // when
        let result = sut.solvePart2(test1)

        // then
        XCTAssertEqual(expectedResult, result)
    }
}
