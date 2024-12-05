//
//  Day02.swift
//  AoC2024
//
//  Created by Marcel Zanoni on 02.12.24.
//

enum Day05: Day {
    static var input: String {
        """
        47|53
        97|13
        97|61
        97|47
        75|29
        61|13
        75|53
        29|13
        97|29
        53|29
        61|53
        97|53
        61|29
        47|13
        75|47
        97|75
        47|61
        75|61
        47|29
        75|13
        53|13
        
        75,47,61,53,29
        97,61,53,29,13
        75,29,13
        75,97,47,61,53
        61,13,29
        97,13,75,29,47
        """
    }

    static func part1() -> Int {
        let rulesAndPages = input.split(separator: "\n\n")
        let rules = rulesAndPages[0]
            .split(separator: "\n")
            .map {
                let rule = $0.split(separator: "|")
                return (Int(rule[0])!, Int(rule[1])!)
            }
        let listOfPages = rulesAndPages[1].split(separator: "\n")
            .map {
                $0.split(separator: ",").map { Int($0)! }
            }

        var sum = 0
        for pages in listOfPages {
            var compliant = true

            for (i, page) in pages.enumerated() {
                for rule in rules.filter({ $0.0 == page }) {
                    let beforePage = rule.1

                    if let firstIndex = pages.firstIndex(of: beforePage), firstIndex < i {
                        compliant = false
                        break
                    }
                }
            }

            if compliant {
                sum += pages[pages.count / 2]
            }
        }

        return sum
    }

    static func part2() -> Int {
        let rulesAndPages = input.split(separator: "\n\n")
        let rules = rulesAndPages[0]
            .split(separator: "\n")
            .map {
                let rule = $0.split(separator: "|")
                return (Int(rule[0])!, Int(rule[1])!)
            }
        let listOfPages = rulesAndPages[1].split(separator: "\n")
            .map {
                $0.split(separator: ",").map { Int($0)! }
            }

        func findAllErrors(_ pages: [Int], rules: [(Int, Int)]) -> [(Int, (Int,Int))] {
            var errors = [(Int, (Int,Int))]()
            for (i, page) in pages.enumerated() {
                let rules = rules.filter({ $0.0 == page })

                for rule in rules {
                    let beforePage = rule.1

                    if let firstIndex = pages.firstIndex(of: beforePage), firstIndex < i {
                        errors.append((i, rule))
                    }
                }
            }
            return errors
        }

        var sum = 0
        for pages in listOfPages {
            var errors = findAllErrors(pages, rules: rules)
            var swapped = pages

            if errors.isEmpty { continue }

            while !errors.isEmpty {
                for error in errors {
                    let rule = error.1
                    let otherIndex = swapped.firstIndex(of: rule.1)!
                    swapped.swapAt(error.0, otherIndex)
                }

                errors = findAllErrors(swapped, rules: rules)
            }

            sum += swapped[swapped.count / 2]
        }

        return sum
    }
}
