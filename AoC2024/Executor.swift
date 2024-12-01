//
//  Executor.swift
//  AoC2024
//
//  Created by Roman Mirzoyan on 01.12.24.
//

import Foundation

enum Executor {
    private static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 4
        return formatter
    }()

    static func execute<T: Day>(_ day: T.Type) {
        print("Day \(day.dayNumber)")
        execute(part: day.part1)
        execute(part: day.part2)
    }

    private static func execute(part: () -> Int) {
        let date = Date.now
        let result = part()
        let elapsed = date.timeIntervalSinceNow
        let elapsedNumber = NSNumber(floatLiteral: abs(elapsed))

        print("- Result:", result, "Time:", "\(Self.numberFormatter.string(from: elapsedNumber)!)s")
    }
}
