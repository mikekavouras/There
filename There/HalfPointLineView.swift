//
//  HalfPointLineView.swift
//  There
//
//  Created by Michael Kavouras on 10/6/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

class HalfPointLineView: UIView {
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!


    override func awakeFromNib() {
        super.awakeFromNib()
        heightConstraint.constant = 0.5
    }
}
