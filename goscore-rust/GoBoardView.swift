//
//  GoBoardView.swift
//  goscore-rust
//
//  Created by Caleb Jones on 11/26/16.
//  Copyright © 2016 Caleb Jones. All rights reserved.
//

import UIKit

protocol GoBoardDelegate {
    func touch(at boardLocation: (row: UInt, col: UInt));
}

class GoBoardView : UIView {
    
    private var _board: GoBoard = GoBoard()
    var board: GoBoard {
        get { return _board }
        set {
            _board = newValue
            self.updateConstraints()
            self.setNeedsDisplay()
        }
    }
    var aspectRatio: NSLayoutConstraint?
    var delegate: GoBoardDelegate?
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count != 1 {
            return
        }
        
        let location = touches.first!.location(in: self)
        let col = UInt(location.x / self.frame.width * CGFloat(board.width+1) - 0.5)
        let row = UInt(location.y / self.frame.height * CGFloat(board.height+1) - 0.5)
        
        if 0 > col || col >= board.width || 0 > row || row >= board.height {
            return
        }
        
        delegate?.touch(at: (row, col))
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        if let constraint = aspectRatio {
            self.removeConstraint(constraint)
        }
        
        aspectRatio = NSLayoutConstraint(
            item: self, attribute: .width, relatedBy: .equal,
            toItem: self, attribute: .height,
            multiplier: CGFloat(board.width+1) / CGFloat(board.height+1),
            constant: 0)
        self.addConstraint(aspectRatio!)
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext()
            else { return }
        
        // Draw the background
        context.setFillColor(UIColor.brown.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
        
        // Draw the board lines
        context.setStrokeColor(UIColor.black.cgColor)
        let cellWidth = rect.width / CGFloat(board.width + 1)
        let cellHeight = rect.height / CGFloat(board.height + 1)
        
        for row in 0..<board.height {
            let y = CGFloat(row) * cellHeight + cellHeight
            context.move(to: CGPoint(x: cellWidth, y: y))
            context.addLine(to: CGPoint(x: rect.width - cellWidth, y: y))
        }
        
        for col in 0..<board.width {
            let x = CGFloat(col) * cellWidth + cellWidth
            context.move(to: CGPoint(x: x, y: cellHeight))
            context.addLine(to: CGPoint(x: x, y: rect.height - cellHeight))
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
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineCap(.round)
        let scaler = CGFloat(max(board.width, board.height))
        context.setLineWidth(40 / scaler)
        for row in 0..<board.height {
            for col in 0..<board.width {
                let x = CGFloat(col) * cellWidth + cellWidth * (2/3)
                let y = CGFloat(row) * cellHeight + cellHeight * (2/3)
                if board[(row, col)].dead {
                    context.move(to: CGPoint(x: x, y: y))
                    context.addLine(to: CGPoint(x: x + cellWidth * (2/3),
                                                y: y + cellHeight * (2/3)))
                    context.move(to: CGPoint(x: x, y: y + cellHeight * (2/3)))
                    context.addLine(to: CGPoint(x: x + cellWidth * (2/3), y: y))
                }
            }
        }
        context.strokePath()
    }
    
}
