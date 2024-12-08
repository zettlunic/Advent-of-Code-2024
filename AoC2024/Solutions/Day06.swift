//
//  Day01.swift
//  AoC2024
//
//  Created by Marcel Zanoni on 02.12.24.
//

enum Day06: Day {

    static var input: String {
        """
        ....#.....
        .........#
        ..........
        ..#.......
        .......#..
        ..........
        .#..^.....
        ........#.
        #.........
        ......#...
        """
    }

    struct Position: Hashable {
        let x: Int
        let y: Int
    }

    enum Direction {
        case up
        case down
        case left
        case right

        var manipulation: (Int, Int) {
            switch self {
            case .up:
                (-1, 0)
            case .down:
                (+1, 0)
            case .left:
                (0, -1)
            case .right:
                (0, +1)
            }
        }
    }

    static func turnRight(_ current: Direction) -> Direction {
        switch current {
        case .up:
                .right
        case .down:
                .left
        case .left:
                .up
        case .right:
                .down
        }
    }

    static func findStartingPosition(_ grid: Grid) -> Position {
        for (y, row) in grid.enumerated() {
            if let x = row.firstIndex(where: { column in
                column == "^"
            }) {
                return .init(x: x, y: y)
            }
        }

        return .init(x: -1, y: -1)
    }

    static func visitedPositions(for grid: Grid) -> [(Position, Direction)] {
        var currentPosition: Position = findStartingPosition(grid)
        var nextDirection: Direction = .up

        var positionsVisited = [(currentPosition, nextDirection)]

        while true {
            let nextX = currentPosition.x + nextDirection.manipulation.1
            let nextY = currentPosition.y + nextDirection.manipulation.0

            guard (nextX >= 0 && nextX < grid.first!.count && nextY >= 0 && nextY < grid.count) else { break }

            let nextPosition = grid[nextY][nextX]

            switch nextPosition {
            case ".", "^":
                positionsVisited.append((.init(x: nextX, y: nextY), nextDirection))
                // go ahead
                currentPosition = .init(x: nextX, y: nextY)
            case "#":
                // turn 90º
                nextDirection = turnRight(nextDirection)
            default:
                break
            }
        }

        return positionsVisited
    }

    static func visitedPositionsContainLoop(for grid: Grid) -> Bool {
        var currentPosition: Position = findStartingPosition(grid)
        var nextDirection: Direction = .up

        var obstacles = [(currentPosition, nextDirection)]

        while true {
            let nextX = currentPosition.x + nextDirection.manipulation.1
            let nextY = currentPosition.y + nextDirection.manipulation.0

            guard (nextX >= 0 && nextX < grid.first!.count && nextY >= 0 && nextY < grid.count) else { break }

            let nextPosition = Position(x: nextX, y: nextY)
            let nextField = grid[nextY][nextX]

            switch nextField {
            case ".", "^":
                // go ahead
                currentPosition = nextPosition
            case "#", "0":
                // check if this obstacle & position were encountered before
                if obstacles.contains(where: {
                    $0.0 == .init(x: nextX, y: nextY) && $0.1 == nextDirection
                }) {
                    return true
                } else {
                    // add obstacle to known list
                    obstacles.append((nextPosition, nextDirection))
                    // turn 90º
                    nextDirection = turnRight(nextDirection)
                }
            default:
                break
            }
        }

        return false
    }

    static func part1() -> Int {
        Set(visitedPositions(for: input.grid()).map { $0.0 }).count
    }

    static func resultsInLoop(_ grid: Grid, startingPosition: Position, direction: Direction) -> Bool {
        switch direction {
        case .up:
            // object A in upwards path
            let columnA = grid.column(startingPosition.x)
            guard let indexA = objectInPath(columnA, direction: .upOrLeft(startingPosition.y - 1)) else { return false }

            // object B in righthand path below object A
            let rowB = grid.row(indexA + 1)
            guard let indexB = objectInPath(rowB, direction: .downOrRight(startingPosition.x + 2)) else { return false }

            // object C in downwards path before object B
            let columnC = grid.column(indexB - 1)
            guard let indexC = objectInPath(columnC, direction: .downOrRight(indexA + 2)) else { return false }

            // object D in lefthand path above object C
            let rowD = grid.row(indexC - 1)
            guard let indexD = objectInPath(rowD, direction: .upOrLeft(indexA - 1)), indexD == startingPosition.x - 1 else { return false }

            return true
        case .down:
            // object A in downwards path
            let columnA = grid.column(startingPosition.x)
            guard let indexA = objectInPath(columnA, direction: .downOrRight(startingPosition.y + 1)), indexA > startingPosition.y else { return false }

            // object B in lefthand path before object A
            let rowB = grid.row(indexA - 1)
            guard let indexB = objectInPath(rowB, direction: .upOrLeft(startingPosition.x - 2)) else { return false }

            // object C in upwards path above object B
            let columnC = grid.column(indexB + 1)
            guard let indexC = objectInPath(columnC, direction: .upOrLeft(indexA - 2)) else { return false }

            // object D in righthand path after object C
            let rowD = grid.row(indexC + 1)
            guard let indexD = objectInPath(rowD, direction: .downOrRight(indexB + 2)), indexD == startingPosition.x + 1 else { return false }

            return true
        case .left:
            // object A in lefthand path
            let rowA = grid.row(startingPosition.y)
            guard let indexA = objectInPath(rowA, direction: .upOrLeft(startingPosition.x - 1)) else { return false }

            // object B in upwards path before object A
            let columnB = grid.column(indexA + 1)
            guard let indexB = objectInPath(columnB, direction: .upOrLeft(startingPosition.y - 2)) else { return false }

            // object C in righthand path below object B
            let rowC = grid.row(indexB + 1)
            guard let indexC = objectInPath(rowC, direction: .downOrRight(indexA + 2)) else { return false }

            // object D in downwards path after object C
            let columnD = grid.column(indexC - 1)
            guard let indexD = objectInPath(columnD, direction: .downOrRight(indexB + 2)), indexD == startingPosition.y + 1 else { return false }

            return true
        case .right:
            // object A in righthand path
            let rowA = grid.row(startingPosition.y)
            guard let indexA = objectInPath(rowA, direction: .downOrRight(startingPosition.x + 1)) else { return false }

            // object B in downwards path before object A
            let columnB = grid.column(indexA - 1)
            guard let indexB = objectInPath(columnB, direction: .downOrRight(startingPosition.y + 2)) else { return false }

            // object C in lefthand path above object B
            let rowC = grid.row(indexB - 1)
            guard let indexC = objectInPath(rowC, direction: .upOrLeft(indexA - 1)) else { return false }

            // object D in upwards path before object C
            let columnD = grid.column(indexC + 1)
            guard let indexD = objectInPath(columnD, direction: .upOrLeft(indexB - 2)), indexD == startingPosition.y - 1 else { return false }

            return true
        }
    }

    enum LookupDirection {
        case upOrLeft(Int) // left and up
        case downOrRight(Int) // right and down
    }

    static func objectInPath(_ path: [Character], direction: LookupDirection) -> Int? {
        switch direction {
        case .upOrLeft(let max):
            let newPath = path.dropLast(path.count - 1 - max)
            return newPath.lastIndex(of: "#")
        case .downOrRight(let min):
            let newPath = path.suffix(from: min)
            return newPath.firstIndex(of: "#")
        }
    }
    
    static var loopTestUpwards: String {
    """
    .......
    .......
    ..#....
    .#^.#..
    ...#...
    .......
    """
    }

    static var loopTestDownwards: String {
    """
    ....v..
    .......
    ...#...
    ..#..#.
    ....#..
    .......
    """
    }

    static var loopTestLefthand: String {
    """
    .......
    ...#...
    ....#..
    ..#...<
    ...#...
    .......
    """
    }

    static var loopTestRighthand: String {
    """
    .......
    ..#....
    >..#...
    .#.....
    ..#....
    .......
    """
    }

    static func part2() -> Int {
        let grid = input.grid()
        let positions = Set(visitedPositions(for: grid).map { $0.0 }.dropFirst())

        var loops = 0

        for position in positions {
            var mutatedGrid = grid
            mutatedGrid[position.y][position.x] = "0"

            if visitedPositionsContainLoop(for: mutatedGrid) {
                // print("A: Loop for # @ (\(position.x), \(position.y))")
                // print(mutatedGrid.print())
                loops += 1
            }
        }

        return loops
    }
}

extension Grid {
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
