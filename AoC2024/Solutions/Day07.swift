//
//  Day01.swift
//  AoC2024
//
//  Created by Marcel Zanoni on 02.12.24.
//

import Algorithms

enum Day07: Day {

    static var input: String {
        """
        190: 10 19
        3267: 81 40 27
        83: 17 5
        156: 15 6
        7290: 6 8 6 15
        161011: 16 10 13
        192: 17 8 14
        21037: 9 7 18 13
        292: 11 6 16 20
        """
    }

    enum Operation {
        case addition
        case multiplication
        case concatenation

        var operation: ((Int, Int) -> Int) {
            switch self {
            case .addition:
                { (x: Int,y: Int) -> Int in x + y }
            case .multiplication:
                { (x: Int,y: Int) -> Int in x * y }
            case .concatenation:
                { (x: Int,y: Int) -> Int in
                    Int("\(String(x))\(String(y))")!
                }
            }
        }
    }

    static func calculateSum(_ lines: [String], ops: [Operation]) -> Int {
        var total = 0

        for line in lines {
            let sumAndValues = line.split(separator: ":")
            let sum = Int(sumAndValues.first!)!
            let values: [Int] = sumAndValues[1].dropFirst().split(separator: " ").map { Int($0)! }

            let permutations = CombinationsWithRepetition(of: ops, length: values.count - 1)

            for permutation in permutations {
                var calculatedSum = values.first!
                let valuesDroppingFirst = values.dropFirst()
                for (i, operation) in permutation.enumerated() {
                    calculatedSum = operation.operation(calculatedSum, valuesDroppingFirst[valuesDroppingFirst.startIndex + i])
                    guard calculatedSum <= sum else { break }
                }
                if calculatedSum == sum {
                    total += calculatedSum
                    break
                }
            }
        }

        return total
    }

    static func part1() -> Int {
        calculateSum(input.lines(), ops: [.addition, .multiplication])
    }

    static func part2() -> Int {
        calculateSum(input.lines(), ops: [.addition, .multiplication, .concatenation])
    }
}
