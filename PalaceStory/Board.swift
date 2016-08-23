//
//  Board.swift
//  PalaceStory
//
//  Created by Łukasz Majchrzak on 18/08/16.
//  Copyright © 2016 Łukasz Majchrzak. All rights reserved.
//

import SpriteKit

class Board {
    private var tiles: Array2D<Tile>
    
    init() {
        tiles = Array2D(row: GameOptions.boardSize, column: GameOptions.boardSize)
    }
}

//MARK: methods
extension Board {
    func tileAt(row row: Int, column: Int) -> Tile? {
        assert(row>=0 && row<GameOptions.boardSize)
        assert(column>=0 && column<GameOptions.boardSize)
        return tiles[row, column]
    }
    
    func newGame() -> [Tile?] {
        tiles = Array2D(row: GameOptions.boardSize, column: GameOptions.boardSize)

        let newTiles = [addBasicTile(), addBasicTile()]
        return newTiles
    }
    
    func isItGameOver() -> Bool {
        return true
    }
    
    func prepareForHandlingMove() {
        Board.executeForEveryField { [unowned self] (row, column) in
            self.tiles[row, column]?.canEvolve = true
        }
    }
    
    func isPossibleMove(direction: MoveDirection) -> Bool {
        switch direction {
        case .Unknown:
            return false
        case .Left:
            return canMoveLeft()
        case .Right:
            return canMoveRight()
        case .Up:
            return canMoveUp()
        case .Down:
            return canMoveDown()
        }
    }

    func performSwipe(direction: MoveDirection) {
        
        
    }
    
    func continueSwipe(direction: MoveDirection) {
        
    }
}

//MARK: private methods
extension Board {
    func findEmptyField() -> (row:Int, column:Int)? {
        var emptyTiles = [(Int, Int)]()
        
        Board.executeForEveryField { [unowned self] (row, column) in
            if self.tiles[row, column] == nil {
                emptyTiles.append(row, column)
            }
        }
        
        guard emptyTiles.count > 0 else { return nil }
        return emptyTiles[Int(arc4random_uniform(UInt32(emptyTiles.count)))]
    }
    
    private func addBasicTile() -> Tile? {
        guard let coords = findEmptyField() else { return nil}
        let tile = Tile(row: coords.row, column: coords.column, tileType: TileType.basicTile)
        tiles[coords.row, coords.column] = tile
        return tile
    }
    

    
    private func canMoveLeft() -> Bool {
        for row in 0..<GameOptions.boardSize {
            for column in 1..<GameOptions.boardSize {
                if checkMoveConditionsFor(tile: tiles[row, column], nextTile: tiles[row, column - 1]) {
                    return true
                }
            }
        }
        return false
    }
    
    private func canMoveRight() -> Bool {
        for row in 0..<GameOptions.boardSize {
            for column in (0..<GameOptions.boardSize-1).reverse() {
                if checkMoveConditionsFor(tile: tiles[row, column], nextTile: tiles[row, column + 1]) {
                    return true
                }
            }
        }
        return false
    }
    
    private func canMoveUp() -> Bool {
        for column in 0..<GameOptions.boardSize {
            for row in 1..<GameOptions.boardSize {
                if checkMoveConditionsFor(tile: tiles[row, column], nextTile: tiles[row - 1, column]) {
                    return true
                }
            }
        }
        return false
    }
    
    private func canMoveDown() -> Bool {
        for column in 0..<GameOptions.boardSize {
            for row in (0..<GameOptions.boardSize - 1).reverse() {
                if checkMoveConditionsFor(tile: tiles[row, column], nextTile: tiles[row + 1, column]) {
                    return true
                }
            }
        }
        return false
    }
    
    private func checkMoveConditionsFor(tile tile: Tile?, nextTile: Tile?) -> Bool {
        guard let tile = tile else { return false }
        guard let nextTile = nextTile else { return true }
        if tile.tileType == nextTile.tileType && tile.canEvolve && nextTile.canEvolve { return true }
        return false
    }

}

//MARK: static methods
extension Board {
    static func executeForEveryField(toExecute: (Int, Int)->()) {
        for column in 0..<GameOptions.boardSize {
            for row in 0..<GameOptions.boardSize {
                toExecute(column, row)
            }
        }
    }
}