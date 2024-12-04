//
//  Day02.swift
//  AoC2024
//
//  Created by Marcel Zanoni on 02.12.24.
//

enum Day04: Day {
    static var input: String {
        // Example
        """
        MMMSXXMASM
        MSAMXMSMSA
        AMXSXMAAMM
        MSAMASMSMX
        XMASAMXAMM
        XXAMMXXAMA
        SMSMSASXSS
        SAXAMASAAA
        MAMMMXMMMM
        MXMXAXMASX
        """
    }

    static func part1() -> Int {
        func rotate(_ matrix: [[Character]]) -> [[Character]] {
            var charColumns = [[Character]]()

            for (i, line) in charLines.enumerated() {
                if i == 0 {
                    for char in line {
                        charColumns.append([char])
                    }
                } else {
                    for (j, char) in line.enumerated() {
                        charColumns[j].append(char)
                    }
                }
            }

            return charColumns
        }

        func diagonals(_ matrix: [[Character]]) -> [[Character]] {
            let width = matrix.first!.count
            let height = matrix.count

            let numberOfDiagonals = width + height - 1

            var diagonals = [[Character]]()

            for k in 0..<numberOfDiagonals {
                var diagonal = [Character]()

                for i in (max(0, k - width + 1))..<(min(k + 1, height)) {
                    let j = k - i
                    diagonal.append(charLines[i][j])
                }
                diagonals.append(diagonal)
            }

            return diagonals
        }

        let pattern = Regex(/XMAS|SAMX/)
        var matches = 0
        let lines = input.split(separator: "\n")
        let charLines: [[Character]] = lines.map {
            Array($0)
        }

        // 1. Count forwards & backwards in lines
        for line in lines {
            matches += line.ranges(of: pattern).count
        }

        // 2. Count forwards & backwards in columns

        let rotated = rotate(charLines)

        rotated.map {
            String($0)
        }.forEach {
            matches += $0.ranges(of: pattern).count
        }

        // 3. Count forwards and backwards in diagonals
        diagonals(charLines).map { String($0) }.forEach { matches += $0.ranges(of: pattern).count }
        diagonals(rotated).map { String($0) }.forEach { matches += $0.ranges(of: pattern).count }

        return matches
    }

    static func part2() -> Int {
        0
    }
}
