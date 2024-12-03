//
//  Day02.swift
//  AoC2024
//
//  Created by Marcel Zanoni on 02.12.24.
//

enum Day03: Day {
    static var input: String {
        // Example
        "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
    }

    static func part1() -> Int {
        let mulPattern = Regex(/mul\(\d{1,3},\d{1,3}\)/)
        let mulPatternRanges = input.ranges(of: mulPattern)

        let multiplications = mulPatternRanges.map { range in
            input[range]
        }

        let numberPattern = Regex(/\d{1,3},\d{1,3}/)
        var pairs = [(Int, Int)]()

        for multiplication in multiplications {
            let numberRanges = multiplication.ranges(of: numberPattern)
            for range in numberRanges {
                let pairStringWithComma = multiplication[range]
                let splits = pairStringWithComma.split(separator: ",")
                pairs.append((
                    Int(splits[0])!,
                    Int(splits[1])!
                ))
            }
        }

        let sum = pairs.reduce(0) { (partialResult, pair) in
            partialResult + pair.0 * pair.1
        }

        return sum
    }

    static func part2() -> Int {
        let pattern = Regex(/(mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\))/)
        let patternRanges = input.ranges(of: pattern)

        let matches = patternRanges.map { range in
            input[range]
        }

        var sanitized = [String]()
        var skipping: Bool = false
        for match in matches {
            if match == "don't()" {
                skipping = true
            } else if match == "do()" {
                skipping = false
            }

            if !skipping {
                sanitized.append(String(match))
            }
        }

        let numberPattern = Regex(/\d{1,3},\d{1,3}/)
        var pairs = [(Int, Int)]()

        for multiplication in sanitized {
            let numberRanges = multiplication.ranges(of: numberPattern)
            for range in numberRanges {
                let pairStringWithComma = multiplication[range]
                let splits = pairStringWithComma.split(separator: ",")
                pairs.append((
                    Int(splits[0])!,
                    Int(splits[1])!
                ))
            }
        }

        let sum = pairs.reduce(0) { (partialResult, pair) in
            partialResult + pair.0 * pair.1
        }

        return sum
    }
}
