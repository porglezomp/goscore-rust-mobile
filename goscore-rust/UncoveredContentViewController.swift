//
//  UncoveredContentViewController.swift
//
//  Created by Glauco Custódio on 9/26/15.
//  Copyright © 2015 Glauco Custódio. All rights reserved.
//  http://glaucocustodio.com/2015/09/26/content-locked-under-keyboard-another-approach-to-solve/
//

import Foundation

import UIKit

class UncoveredContentViewController: UIViewController {
    var activeField: UIView?
    var changedY = false
    var keyboardHeight: CGFloat = 300
    @IBOutlet var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow(sender:)),
            name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide(sender:)),
            name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        
        doneButton.isHidden = true
    }
    
    func keyboardWillShow(sender: NSNotification) {
        let kbSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        
        keyboardHeight = kbSize!.height
        var aRect = self.view.frame;
        aRect.size.height = aRect.size.height - kbSize!.height - CGFloat(20);
        
        
        if activeField != nil && !aRect.contains(activeField!.frame.origin) {
            if (!changedY) {
                self.view.frame.origin.y -= keyboardHeight
            }
            changedY = true
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if changedY {
            self.view.frame.origin.y += keyboardHeight
        }
        changedY = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    
    @IBAction func textFieldEditingDidBegin(sender: UITextField){
        activeField = sender
        doneButton.isHidden = false
    }
    
    @IBAction func textFieldEditingDidEnd(sender: UITextField) {
        activeField = nil
        doneButton.isHidden = true
    }
    
    @IBAction func dismissKeyboard(sender: UIButton) {
        activeField?.endEditing(true)
    }
}
