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
        goView.board = board;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

