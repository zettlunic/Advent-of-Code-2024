//
//  Utils.swift
//  AoC2024
//
//  Created by Marcel Zanoni on 06.12.24.
//

typealias Grid = [[Character]]

extension String {
    func lines() -> [String] {
        self.split(separator: "\n").map { String($0) }
    }
}

extension String {
    func grid() -> Grid {
        self.lines()
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

struct CombinationsWithRepetition<C: Collection> : Sequence {

    let base: C
    let length: Int

    init(of base: C, length: Int) {
        self.base = base
        self.length = length
    }

    struct Iterator : IteratorProtocol {
        let base: C

        var firstIteration = true
        var finished: Bool
        var positions: [C.Index]

        init(of base: C, length: Int) {
            self.base = base
            finished = base.isEmpty
            positions = Array(repeating: base.startIndex, count: length)
        }

        mutating func next() -> [C.Element]? {
            if firstIteration {
                firstIteration = false
            } else {
                // Update indices for next combination.
                finished = true
                for i in positions.indices.reversed() {
                    base.formIndex(after: &positions[i])
                    if positions[i] != base.endIndex {
                        finished = false
                        break
                    } else {
                        positions[i] = base.startIndex
                    }
                }

            }
            return finished ? nil : positions.map { base[$0] }
        }
    }

    func makeIterator() -> Iterator {
        return Iterator(of: base, length: length)
    }
}

extension ClosedRange where Bound == Unicode.Scalar {
    static let asciiPrintable: ClosedRange = " "..."~"
    var range: ClosedRange<UInt32>  { lowerBound.value...upperBound.value }
    var scalars: [Unicode.Scalar]   { range.compactMap(Unicode.Scalar.init) }
    var characters: [Character]     { scalars.map(Character.init) }
    var string: String              { String(scalars) }
}

extension String {
    init<S: Sequence>(_ sequence: S) where S.Element == Unicode.Scalar {
        self.init(UnicodeScalarView(sequence))
    }
}

struct Position: Hashable {
    let x: Int
    let y: Int
}
