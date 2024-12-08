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

    static func visitedPositions(for grid: Grid) -> [Position] {
        var currentPosition: Position = findStartingPosition(grid)
        var nextDirection: Direction = .up

        var positionsVisited = [currentPosition]

        while true {
            let nextX = currentPosition.x + nextDirection.manipulation.1
            let nextY = currentPosition.y + nextDirection.manipulation.0

            guard (nextX >= 0 && nextX < grid.first!.count && nextY >= 0 && nextY < grid.count) else { break }

            let nextPosition = grid[nextY][nextX]

            switch nextPosition {
            case ".", "^":
                positionsVisited.append(.init(x: nextX, y: nextY))
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
        Set(visitedPositions(for: input.grid())).count
    }

    static func part2() -> Int {
        let grid = input.grid()
        let positions = Set(visitedPositions(for: grid).dropFirst())

        var loops = 0

        for position in positions {
            var mutatedGrid = grid
            mutatedGrid[position.y][position.x] = "0"

            if visitedPositionsContainLoop(for: mutatedGrid) {
                loops += 1
            }
        }

        return loops
    }
}
