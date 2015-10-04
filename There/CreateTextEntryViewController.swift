//
//  CreateTextEntryViewController.swift
//  There
//
//  Created by Michael Kavouras on 10/2/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

class CreateTextEntryViewController: CreateEntryViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        entry.typeMapped = .Text
        navigationItem.title = entry.type.capitalizedString
        
        setupNotificationObservers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    private func setupNotificationObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    @IBAction override func createEntryButtonTapped(sender: AnyObject) {
        entry.caption = textView.text
        super.createEntryButtonTapped(sender)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let info = notification.userInfo {
            if let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSValue) as? NSTimeInterval,
                size = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
                buttonBottomConstraint.constant = size.height
                UIView.animateWithDuration(duration, animations: {
                   self.view.setNeedsLayout()
                })
            }
        }
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
