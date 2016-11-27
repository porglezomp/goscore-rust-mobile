//
//  ViewController.swift
//  goscore-rust
//
//  Created by Caleb Jones on 11/26/16.
//  Copyright © 2016 Caleb Jones. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var board: GoBoard = GoBoard()
    @IBOutlet var goView: GoBoardView!
    @IBOutlet var scoreLabel: UILabel!
    var komi: UInt = 7
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            let touch = touches.first!
            touch.location(in: goView)
        }
    }
    
    func reScoreBoard() {
        board.scoreStones()
        let scores = board.scoreSums(komi: self.komi)
        scoreLabel.text = "black \(scores.blackScore), white \(scores.whiteScore).5"
        goView.board = board
    }
    
    @IBAction func updateWidth(sender: AnyObject?) {
        guard let sender = sender as? UITextField
            else { return }
        
        guard let text = sender.text
            else { return }
        
        guard let width = UInt(text)
            else { return }
        
        if width == board.width {
            return
        }
        
        board = GoBoard(width: width, height: board.height)
        self.goView.board = board
        reScoreBoard()
    }
    
    @IBAction func updateHeight(sender: AnyObject?) {
        guard let sender = sender as? UITextField
            else { return }
        
        guard let text = sender.text
            else { return }
        
        guard let height = UInt(text)
            else { return }
        
        if height == board.height {
            return
        }
        
        board = GoBoard(width: board.width, height: height)
        self.goView.board = board
        reScoreBoard()
    }
    
    @IBAction func updateKomi(sender: AnyObject?) {
        guard let sender = sender as? UITextField
            else { return }
        
        guard let text = sender.text
            else { return }
        
        guard let komi = UInt(text)
            else { return }
        
        self.komi = komi
        reScoreBoard()
    }

}

