//
//  HighScore.swift
//  PalaceStory
//
//  Created by Łukasz Majchrzak on 30/08/16.
//  Copyright © 2016 Łukasz Majchrzak. All rights reserved.
//

import Foundation

class HighScore {
    fileprivate static let highScoreKey = "highScoreKey"
    static var points: Int {
        get {
            return UserDefaults.standard.integer(forKey: highScoreKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: highScoreKey)
        }
    }
    static func newHighScore(_ score: Int) -> Bool {
        if score > points {
            points = score
            return true
        }
        return false
    }
}
