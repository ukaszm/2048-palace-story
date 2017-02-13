//
//  File.swift
//  PalaceStory
//
//  Created by Łukasz Majchrzak on 18/08/16.
//  Copyright © 2016 Łukasz Majchrzak. All rights reserved.
//

import Foundation
import SpriteKit

enum TileType: Int {
    case unknown = 0, fireplace_1, halftent_2, fulltent_3, shed_4, hut_5, house_6, maisonette_7, residence_8, villa_9, manorHouse_10, castle_11, palace_12
    
}

//MARK: TileType - computed properties
extension TileType {
    var name: String {
        let names = ["Unknown", "Fireplace_1", "Halftent_2", "Fulltent_3", "Shed_4", "Hut_5", "House_6", "Maisonette_7", "Residence_8", "Villa_9", "ManorHouse_10", "Castle_11", "Palace_12"]
        return names[rawValue]
    }
    
    var spriteName: String {
        return "b_\(rawValue)"
    }
    
    var nextTile: TileType {
        guard let tile = TileType(rawValue: rawValue + 1) else { return .palace_12 }
        return tile
    }
    
    var upgradePoints: Int {
        return rawValue
    }
    
    static var basicTile: TileType {
        return .fireplace_1
    }
}


//MARK: TileType: CustomStringConvertible
extension TileType: CustomStringConvertible {
    var description: String {
        return name
    }
}

//MARK: class Tile
class Tile {
    var sprite: SKSpriteNode?
    var row: Int
    var column: Int
    var canEvolve: Bool
    let tileType: TileType
    
    init(row: Int, column: Int, tileType: TileType) {
        self.row = row
        self.column = column
        self.tileType = tileType
        self.canEvolve = false
    }
}

//MARK: Tile: CustomStringConvertible
extension Tile: CustomStringConvertible {
    var description: String {
        return "type: \(tileType) (\(row), \(column))"
    }
}
