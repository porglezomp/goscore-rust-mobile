//
//  ViewController.swift
//  goscore-rust
//
//  Created by Caleb Jones on 11/26/16.
//  Copyright © 2016 Caleb Jones. All rights reserved.
//

import UIKit

class ViewController: UncoveredContentViewController, GoBoardDelegate {
    
    enum Tool {
        case color
        case dead
    }

    @IBOutlet var goView: GoBoardView!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var colorButton: UIButton!
    @IBOutlet var deadButton: UIButton!
    
    var board: GoBoard = GoBoard()
    var komi: UInt = 7
    var tool: Tool = .color
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goView.delegate = self
        
        let e = Stone()
        let w = Stone(color: .white)
        let b = Stone(color: .black)
        var d = Stone(color: .black)
        d.dead = true
        
        board = GoBoard(stones: [e,e,e,b,e,e,e,
                                 e,e,e,b,e,e,e,
                                 e,e,e,b,e,e,e,
                                 b,b,b,b,w,w,w,
                                 e,e,e,w,e,e,e,
                                 w,e,e,w,e,e,d,
                                 e,w,e,w,e,d,e],
                        width: 7, height: 7)
        
        reScoreBoard()
        highlightButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func highlightButtons() {
        switch tool {
        case .color:
            colorButton.isSelected = true
            deadButton.isSelected = false
        case .dead:
            colorButton.isSelected = false
            deadButton.isSelected = true
        }
    }
    
    func reScoreBoard() {
        board.scoreStones()
        let scores = board.scoreSums(komi: self.komi)
        scoreLabel.text = "black \(scores.blackScore), white \(scores.whiteScore).5"
        goView.board = board
    }
    
    func touch(at boardLocation: (row: UInt, col: UInt)) {
        var stone = board[boardLocation]
        
        switch tool {
        case .color:
            switch stone.color {
            case .none:
                stone.color = .black
                stone.dead = false
            case .some(.black):
                stone.color = .white
            case .some(.white):
                stone.color = nil
                stone.dead = false
            }
        case .dead:
            stone.dead = !stone.dead
        }
        
        board[boardLocation] = stone
        reScoreBoard()
    }
    
    @IBAction func updateWidth(_ sender: UITextView) {
        guard let text = sender.text else { return }
        guard let width = UInt(text) else { return }
        if width == board.width { return }
        
        board = GoBoard(width: width, height: board.height)
        self.goView.board = board
        reScoreBoard()
    }
    
    @IBAction func updateHeight(_ sender: UITextView) {
        guard let text = sender.text else { return }
        guard let height = UInt(text) else { return }
        if height == board.height { return }
        
        board = GoBoard(width: board.width, height: height)
        self.goView.board = board
        reScoreBoard()
    }
    
    @IBAction func updateKomi(_ sender: UITextView) {
        guard let text = sender.text else { return }
        guard let komi = UInt(text) else { return }
        
        self.komi = komi
        reScoreBoard()
    }
    
    @IBAction func setToolToColor(_ sender: AnyObject?) {
        tool = .color
        highlightButtons()
    }
    
    @IBAction func setToolToDead(_ sender: AnyObject?) {
        tool = .dead
        highlightButtons()
    }

}

