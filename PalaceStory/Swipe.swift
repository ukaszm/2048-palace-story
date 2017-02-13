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
    case unknown = 0, left, right, up, down
    
    var description: String {
        let directions = ["Unknown", "Left", "Right", "Up", "Down"]
        return directions[rawValue]
    }
}

struct Swipe {
    
    var start: CGPoint?
    var stop: CGPoint?
    
    var direction: MoveDirection {
        guard let start = start, let stop = stop else { return .unknown }
        let dirX = stop.x - start.x
        let dirY = stop.y - start.y
        guard abs(dirX) >= GameOptions.minMoveLength || abs(dirY) >= GameOptions.minMoveLength else { return .unknown }
        
        let horizontal: MoveDirection = dirX > 0 ? .right : .left
        let vertical: MoveDirection = dirY > 0 ? .up : .down
        
        return abs(dirX) >= abs(dirY) ? horizontal : vertical
    }
}

extension Swipe: CustomStringConvertible {
    var description: String {
        return "move from \(start), to \(stop)"
    }
}
