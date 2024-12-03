//
//  Day02.swift
//  AoC2024
//
//  Created by Marcel Zanoni on 02.12.24.
//

enum Day02: Day {
    static var input: String {
        """
        """
    }

    static func part1() -> Int {
        var safe = 0

        let reportLines = input.split(separator: "\n")
        for report in reportLines {
            let numbers = report.split(separator: " ").map { Int($0)! }

            var currentIsSafe = true

            for i in 0..<numbers.count - 2 {
                let a = numbers[i]
                let b = numbers[i+1]
                let c = numbers[i+2]

                if (a > b && b > c) || (a < b && b < c) {
                    continue
                } else {
                    currentIsSafe = false
                    break
                }
            }

            guard currentIsSafe else {
                continue
            }

            for i in 0..<numbers.count - 1 {
                let a = numbers[i]
                let b = numbers[i+1]

                let distance = abs(a - b)
                if distance >= 1 && distance <= 3 {
                    continue
                } else {
                    currentIsSafe = false
                    break
                }
            }

            if currentIsSafe {
                safe += 1
            }
        }

        return safe
    }

    static func part2() -> Int {
        func isSafe(_ input: [Int]) -> Bool {
            var isSafe = true

            for i in 0..<input.count - 2 {
                let a = input[i]
                let b = input[i+1]
                let c = input[i+2]

                if (a > b && b > c) || (a < b && b < c) {
                    continue
                } else {
                    isSafe = false
                    break
                }
            }

            guard isSafe else {
                return false
            }

            for i in 0..<input.count - 1 {
                let a = input[i]
                let b = input[i+1]

                let distance = abs(a - b)
                if distance >= 1 && distance <= 3 {
                    continue
                } else {
                    isSafe = false
                    break
                }
            }

            return isSafe
        }

        var safe = 0

        let reportLines = input.split(separator: "\n")
        for report in reportLines {
            let numbers = report.split(separator: " ").map { Int($0)! }

            if isSafe(numbers) {
                safe += 1
            } else {
                for i in 0..<numbers.count {
                    var dampened = numbers
                    dampened.remove(at: i)
                    if isSafe(dampened) {
                        safe += 1
                        break
                    }
                }
            }
        }

        return safe
    }
}
