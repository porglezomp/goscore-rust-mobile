//
//  GoBoardView.swift
//  goscore-rust
//
//  Created by Caleb Jones on 11/26/16.
//  Copyright © 2016 Caleb Jones. All rights reserved.
//

import UIKit

class GoBoardView : UIView {
    
    private var _board: GoBoard = GoBoard()
    var board: GoBoard {
        get { return _board }
        set {
            _board = newValue
            self.setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext()
            else { return }
        
        // Draw the background
        context.setFillColor(UIColor.brown.cgColor)
        let size = min(rect.width, rect.height)
        let x = (rect.width - size) / 2
        let y = (rect.height - size) / 2
        context.fill(CGRect(x: x, y: y, width: size, height: size))
        
        // Draw the board lines
        
        // Draw the territory
        
        // Draw the stones
        
        // Mark the dead stones
    }
    
}
