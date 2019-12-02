#!/usr/bin/swift
import Cocoa

let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 2"
day += input == "" ? " – TEST" : ""
let underscores = Array(repeating: "—", count: day.count).joined()

print("\n\(underscores)\n\(day)\n\(underscores)")

// Tests
let test1 = "1,9,10,3,2,3,11,0,99,30,40,50"
let test2 = "1,1,1,4,99,5,6,0,99"

// Part 1
func solvePart1(_ string: String) -> Int {
    let array = string.components(separatedBy: ",").compactMap { Int($0) }
    let result = runProgram(array)
    return result[0]
}

func runProgram(_ array: [Int]) -> [Int] {
    var result = array
    var pointer = 0
    while true {
        switch result[pointer] {
        case 1:
            let a = result[pointer+1]
            let b = result[pointer+2]
            let c = result[pointer+3]
            result[c] = result[a] + result[b]
            pointer += 4
        case 2:
            let a = result[pointer+1]
            let b = result[pointer+2]
            let c = result[pointer+3]
            result[c] = result[a] * result[b]
            pointer += 4
        case 99:
            return result
        default:
            break
        }
    }
}

//print(solvePart1(test1))
assert(solvePart1(test1) == 3500)
assert(solvePart1(test2) == 30)

// Part 2
func solvePart2(_ string: String) -> Int {
    var array = string.components(separatedBy: ",").compactMap { Int($0) }
    let target = 19690720
    for noun in 0...99 {
        for verb in 0...99 {
            array[1] = noun
            array[2] = verb
            let result = runProgram(array)
            if result[0] == target {
                return 100 * noun + verb
            }
        }
    }
    return -1
}

//assert(solvePart2(test2) == "")

func findAnswers(_ string: String) {
    var string = string
    if string.isEmpty { string = test1 }

    var startTime = CFAbsoluteTimeGetCurrent()
    let answer1 = solvePart1(string)
    print("Part 1 Answer: \(answer1)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")

    if string == test1 { string = test2 }

    startTime = CFAbsoluteTimeGetCurrent()
    let answer2 = solvePart2(string)
    print("Part 2 Answer: \(answer2)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
}

findAnswers(input)
