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
}
