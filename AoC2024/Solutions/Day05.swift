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

        struct PrintAndRules {
            let print: [Int]
            let rules: [(Int, Int)]
            let errors: [Int]
        }

        func evaluate(_ pages: [Int], rules: [(Int, Int)]) -> [(Int,Int)] {
            var brokenRules = [(Int,Int)]()
            for (i, page) in pages.enumerated() {
                let rules = rules.filter({ $0.0 == page })

                for rule in rules {
                    let beforePage = rule.1

                    if let firstIndex = pages.firstIndex(of: beforePage), firstIndex < i {
                        brokenRules.append(rule)
                    }
                }
            }

            return brokenRules
        }

        var incorrectPrints = [PrintAndRules]()
        for pages in listOfPages {
            var compliant = true
            var applicableRules = [(Int, Int)]()
            var errors = [Int]()

            for (i, page) in pages.enumerated() {
                let rules = rules.filter({ $0.0 == page })
                applicableRules.append(contentsOf: rules)

                for rule in rules {
                    let beforePage = rule.1

                    if let firstIndex = pages.firstIndex(of: beforePage), firstIndex < i {
                        compliant = false
                        errors.append(i)
                        break
                    }
                }
            }

            if !compliant {
                incorrectPrints.append(PrintAndRules(print: pages, rules: applicableRules, errors: errors))
            }
        }

        var corrected = [[Int]]()

        for printAndRules in incorrectPrints {

            func correct(_ print: PrintAndRules) -> (Int, [Int]) {
//                print("Page: \(printAndRules.print)\nRules: \(printAndRules.rules)\nErrors: \(printAndRules.errors)")

                var currentErrors = printAndRules.errors
                var currentPage = printAndRules.print
                for error in printAndRules.errors {
                    let otherIndizes = Set(printAndRules.print.indices).subtracting(Set([error]))

                    for otherIndex in otherIndizes {
                        var swapped = currentPage
                        swapped.swapAt(error, otherIndex)

                        let brokenRules = evaluate(swapped, rules: printAndRules.rules)
                        //                        .filter { rule in
                        //                            rule.0 == printAndRules.print[error]
                        //                    }

                        if brokenRules.count < currentErrors.count {
                            currentErrors = brokenRules
                            currentPage = swapped
                            continue
                        }
                    }
                }
                return (currentErrors, currentPage)
            }

            let currentResult = correct(printAndRules)
            let currentErrors = currentResult.0

            if currentErrors == 0 {
                print("Solved: \(currentResult.1)")
                corrected.append(currentResult.1)
            } else {
                correct(PrintAndRules(
                    print: currentResult.1,
                    rules: printAndRules.rules,
                    errors: currentResult))
            }
        }

        fatalError()
        return 0
    }
}
