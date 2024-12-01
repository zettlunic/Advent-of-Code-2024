//
//  Day.swift
//  AoC2024
//
//  Created by Roman Mirzoyan on 01.12.24.
//

protocol Day {
    static var dayNumber: Int { get }
    static var input: String { get }
    static func part1() -> Int
    static func part2() -> Int
}
