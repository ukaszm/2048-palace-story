//
//  Array2D.swift
//  PalaceStory
//
//  Created by Łukasz Majchrzak on 18/08/16.
//  Copyright © 2016 Łukasz Majchrzak. All rights reserved.
//

import Foundation

struct Array2D<T> {
    let rows: Int
    let columns: Int
    fileprivate var array: Array<T?>
    
    init(row: Int, column: Int) {
        self.rows = row
        self.columns = column
        array = Array<T?>(repeating: nil, count: row * column)
    }
    
    subscript (row: Int, column: Int) -> T? {
        get {
            return array[row * columns + column]
        }
        set {
            array[row * columns + column] = newValue
        }
    }
}
