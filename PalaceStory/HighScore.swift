//
//  HighScore.swift
//  PalaceStory
//
//  Created by Łukasz Majchrzak on 30/08/16.
//  Copyright © 2016 Łukasz Majchrzak. All rights reserved.
//

import Foundation

class HighScore {
    private static let highScoreKey = "highScoreKey"
    static var points: Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey(highScoreKey)
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: highScoreKey)
        }
    }
    static func newHighScore(score: Int) -> Bool {
        if score > points {
            points = score
            return true
        }
        return false
    }
}
