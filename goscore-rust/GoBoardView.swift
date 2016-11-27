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
        
        // Find the drawing offset
        let size = min(rect.width, rect.height)
        let x0 = (rect.width - size) / 2
        let y0 = (rect.height - size) / 2
        context.translateBy(x: x0, y: y0)
        
        // Draw the background
        context.setFillColor(UIColor.brown.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: size, height: size))
        
        // Draw the board lines
        context.setStrokeColor(UIColor.black.cgColor)
        let cellWidth = size / CGFloat(board.width + 1)
        let cellHeight = size / CGFloat(board.height + 1)
        
        for row in 0..<board.height {
            let y = CGFloat(row) * cellHeight + cellHeight
            context.addLines(between: [CGPoint(x: cellWidth, y: y),
                                       CGPoint(x: size - cellWidth, y: y)])
        }
        
        for col in 0..<board.width {
            let x = CGFloat(col) * cellWidth + cellWidth
            context.addLines(between: [CGPoint(x: x, y: cellHeight),
                                       CGPoint(x: x, y: size - cellHeight)])
        }
        
        context.strokePath()
        
        // Draw the territory
        context.setAlpha(0.4)
        for row in 0..<board.height {
            for col in 0..<board.width {
                let x = CGFloat(col) * cellWidth + cellWidth / 2
                let y = CGFloat(row) * cellHeight + cellHeight / 2
                switch board[(row, col)].score {
                case .some(.white):
                    context.setFillColor(UIColor.white.cgColor)
                    context.fill(CGRect(x: x, y: y, width: cellWidth, height: cellHeight))
                case .some(.black):
                    context.setFillColor(UIColor.black.cgColor)
                    context.fill(CGRect(x: x, y: y, width: cellWidth, height: cellHeight))
                case .none:
                    break
                }
            }
        }
        
        // Draw the stones
        let stoneRadius = min(cellWidth, cellHeight) * 0.45
        context.setAlpha(1)
        for row in 0..<board.height {
            for col in 0..<board.width {
                let x = CGFloat(col) * cellWidth + cellWidth - stoneRadius
                let y = CGFloat(row) * cellHeight + cellHeight - stoneRadius
                switch board[(row, col)].color {
                case .some(.white):
                    context.setFillColor(UIColor.white.cgColor)
                    context.fillEllipse(in: CGRect(x: x, y: y,
                                                   width: stoneRadius * 2, height: stoneRadius * 2))
                case .some(.black):
                    context.setFillColor(UIColor.black.cgColor)
                    context.fillEllipse(in: CGRect(x: x, y: y,
                                                   width: stoneRadius * 2, height: stoneRadius * 2))
                case .none:
                    break
                }
            }
        }
        
        // Mark the dead stones
    }
    
}
