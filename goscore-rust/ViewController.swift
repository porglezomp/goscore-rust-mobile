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
    var goView: GoBoardView! {
        get { return super.view as! GoBoardView }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let e = Stone()
        let w = Stone(color: .white)
        let b = Stone(color: .black)
        board = GoBoard(stones: [e,e,b,e,e,
                                 e,e,b,e,e,
                                 b,b,b,w,w,
                                 e,e,w,e,e,
                                 e,e,w,e,e],
                        width: 5, height: 5)
        goView.board = board
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

