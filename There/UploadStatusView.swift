//
//  UploadStatusView.swift
//  There
//
//  Created by Michael Kavouras on 10/19/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

class UploadStatusView: UIView {

    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        clipsToBounds = true
    }

    func show() {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.heightConstraint.constant = 38.0
            self.layoutIfNeeded()
        })
    }
    
    func hide() {
        UIView.animateWithDuration(0.4, delay: 0.4, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.heightConstraint.constant = 0.0
            self.layoutIfNeeded()
        }, completion: nil)
    }
}
