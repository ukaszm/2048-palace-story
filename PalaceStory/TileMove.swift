//
//  TileMove.swift
//  PalaceStory
//
//  Created by Łukasz Majchrzak on 23/08/16.
//  Copyright © 2016 Łukasz Majchrzak. All rights reserved.
//

import Foundation

struct TileMove {
    let tile: Tile
    let from: BoardCoords
    let to: BoardCoords
    let tileB: Tile?
    let newTile: Tile?
}
