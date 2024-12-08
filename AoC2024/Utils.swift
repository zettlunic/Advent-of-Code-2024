//
//  Utils.swift
//  AoC2024
//
//  Created by Marcel Zanoni on 06.12.24.
//

typealias Grid = [[Character]]

extension String {
    func grid() -> Grid {
        self.split(separator: "\n")
            .map {
                Array($0)
            }
    }
}

extension Grid {
    func print() -> String {
        self.reduce("") { partialResult, row in
            partialResult.appending(String(row + ["\n"]))
        }
    }

    func column(_ index: Int) -> [Character] {
        self.map {
            $0[index]
        }
    }

    func row(_ index: Int) -> [Character] {
        self[index]
    }
}

extension Collection {
    func windows(of count: Int) -> UnfoldSequence<SubSequence,Index> {
        sequence(state: startIndex) { start in
            guard start < endIndex,
                  let end = index(
                    start,
                    offsetBy: count,
                    limitedBy: endIndex
                  )
            else { return nil }
            defer { formIndex(after: &start) }
            return self[start..<end]
        }
    }
}
