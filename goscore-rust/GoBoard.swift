//
//  GoBoard.swift
//  goscore-rust
//
//  Created by Caleb Jones on 11/26/16.
//  Copyright © 2016 Caleb Jones. All rights reserved.
//

import Foundation

struct Stone {

    var value: CChar

}

class GoBoard {
    
    var components: [Stone] = []
    var width: UInt = 0
    var height: UInt = 0
    
}
