//
//  Move.swift
//  PalaceStory
//
//  Created by Łukasz Majchrzak on 18/08/16.
//  Copyright © 2016 Łukasz Majchrzak. All rights reserved.
//

import SpriteKit
import Foundation

enum MoveDirection: Int, CustomStringConvertible {
    case Unknown = 0, Left, Right, Up, Down
    
    var description: String {
        let directions = ["Unknown", "Left", "Right", "Up", "Down"]
        return directions[rawValue]
    }
}

struct Swipe {
    
    var start: CGPoint?
    var stop: CGPoint?
    
    var direction: MoveDirection {
        guard let start = start, stop = stop else { return .Unknown }
        let dirX = stop.x - start.x
        let dirY = stop.y - start.y
        guard abs(dirX) >= GameOptions.minMoveLength || abs(dirY) >= GameOptions.minMoveLength else { return .Unknown }
        
        let horizontal: MoveDirection = dirX > 0 ? .Right : .Left
        let vertical: MoveDirection = dirY > 0 ? .Up : .Down
        
        return abs(dirX) >= abs(dirY) ? horizontal : vertical
    }
}

extension Swipe: CustomStringConvertible {
    var description: String {
        return "move from \(start), to \(stop)"
    }
}