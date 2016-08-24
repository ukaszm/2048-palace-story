//
//  Board.swift
//  PalaceStory
//
//  Created by Łukasz Majchrzak on 18/08/16.
//  Copyright © 2016 Łukasz Majchrzak. All rights reserved.
//

import SpriteKit

struct BoardCoords {
    var row: Int
    var column: Int
}

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
    
    func addBasicTile() -> Tile? {
        guard let coords = findEmptyField() else { return nil}
        let tile = Tile(row: coords.row, column: coords.column, tileType: TileType.basicTile)
        tiles[coords.row, coords.column] = tile
        return tile
    }
    
    func isItGameOver() -> Bool {
        prepareForHandlingMove()
        return !(isPossibleMove(.Left) || isPossibleMove(.Right) || isPossibleMove(.Up) || isPossibleMove(.Down))
    }
    
    func prepareForHandlingMove() {
        Board.executeForEveryField { [unowned self] coords in
            self.tiles[coords.row, coords.column]?.canEvolve = true
        }
    }
    
    func isPossibleMove(direction: MoveDirection) -> Bool {
        
        var canMove = false
        executeForTileSwiping(direction) { [unowned self] (tileCoords, nextTileCoords) in
            if self.checkMoveConditionsFor(tile: self.tiles[tileCoords.row, tileCoords.column], nextTile: self.tiles[nextTileCoords.row, nextTileCoords.column]) {
                canMove = true
            }
        }
        return canMove
    }

    func performSwipe(direction: MoveDirection) -> [TileMove] {
        return moveTiles(direction)
    }

}

//MARK: private methods
extension Board {
    func findEmptyField() -> BoardCoords? {
        var emptyTiles = [BoardCoords]()
        
        Board.executeForEveryField { [unowned self] coords in
            if self.tiles[coords.row, coords.column] == nil {
                emptyTiles.append(coords)
            }
        }
        
        guard emptyTiles.count > 0 else { return nil }
        return emptyTiles[Int(arc4random_uniform(UInt32(emptyTiles.count)))]
    }
    
    private func moveTiles(direction: MoveDirection) -> [TileMove] {
        var moves = [TileMove]()
        executeForTileSwiping(direction) { [unowned self] (tileCoords, nextTileCoords) in
            guard let tile = self.tiles[tileCoords.row, tileCoords.column] else { return }
            guard let nextTile = self.tiles[nextTileCoords.row, nextTileCoords.column] else {
                self.tiles[tileCoords.row, tileCoords.column] = nil
                self.tiles[nextTileCoords.row, nextTileCoords.column] = tile
                tile.row = nextTileCoords.row
                tile.column = nextTileCoords.column
                moves.append(TileMove(tile: tile, from: tileCoords, to: nextTileCoords, tileB: nil, newTile: nil))
                return
            }
            guard tile.tileType == nextTile.tileType && tile.canEvolve && nextTile.canEvolve else { return }
            let newTile = Tile(row: nextTileCoords.row, column: nextTileCoords.column, tileType: tile.tileType.nextTile)
            self.tiles[tileCoords.row, tileCoords.column] = nil
            self.tiles[nextTileCoords.row, nextTileCoords.column] = newTile
            
            moves.append(TileMove(tile: tile, from: tileCoords, to: nextTileCoords, tileB: nextTile, newTile: newTile))
        }
        return moves
    }
    
    private func executeForTileSwiping(direction: MoveDirection, action: (tileCoords: BoardCoords, nextTileCoords: BoardCoords)->()) {
        var rowsStride    = 0.stride(through: GameOptions.boardSize - 1, by: 1)
        var columnsStride = 0.stride(through: GameOptions.boardSize - 1, by: 1)
        var nextRowOffset    = 0
        var nextColumnOffset = 0
        
        switch direction {
        case .Unknown:
            return
        case .Left:
            columnsStride = 1.stride(through: GameOptions.boardSize - 1, by: 1)
            nextColumnOffset = -1
        case .Right:
            columnsStride = (GameOptions.boardSize - 2).stride(through: 0, by: -1)
            nextColumnOffset = 1
        case .Up:
            rowsStride = 1.stride(through: GameOptions.boardSize - 1, by: 1)
            nextRowOffset = -1
        case .Down:
            rowsStride = (GameOptions.boardSize - 2).stride(through: 0, by: -1)
            nextRowOffset = 1
        }
        
        for row in rowsStride {
            for column in columnsStride {
                action(tileCoords: BoardCoords(row: row, column: column), nextTileCoords: BoardCoords(row: row + nextRowOffset, column: column + nextColumnOffset))
            }
        }
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
    static func executeForEveryField(toExecute: (BoardCoords)->()) {
        for row in 0..<GameOptions.boardSize {
            for column in 0..<GameOptions.boardSize {
                toExecute(BoardCoords(row: row, column: column))
            }
        }
    }
}