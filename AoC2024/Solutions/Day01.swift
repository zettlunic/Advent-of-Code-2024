//
//  Day01.swift
//  AoC2024
//
//  Created by Marcel Zanoni on 02.12.24.
//

enum Day01: Day {

    static var input: String {
        """
        """
    }

    static func part1() -> Int {
        let pairs = input.split(separator: "\n")
        let alternating = pairs.flatMap { $0.split(separator: "   ") }
        var left = [Int]()
        var right = [Int]()
        for i in 0...alternating.count - 1 {
            if i % 2 == 0 {
                right.append(Int(alternating[i])!)
            } else {
                left.append(Int(alternating[i])!)
            }
        }

        left = left.sorted()
        right = right.sorted()

        var distances = [Int]()

        for i in 0...left.count - 1 {
            let l = left[i]
            let r = right[i]
            let distance = abs(l - r)
            distances.append(distance)
        }

        return distances.reduce(0, +)
    }

    static func part2() -> Int {
        let pairs = input.split(separator: "\n")
        let alternating = pairs.flatMap { $0.split(separator: "   ") }
        var left = [Int]()
        var right = [Int]()
        for i in 0...alternating.count - 1 {
            if i % 2 == 0 {
                right.append(Int(alternating[i])!)
            } else {
                left.append(Int(alternating[i])!)
            }
        }

        var score = 0

        for l in left {
            let occurrences = right.count { r in
                r == l
            }

            score += l * occurrences
        }

        return score
    }
}
