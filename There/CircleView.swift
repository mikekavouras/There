//
//  CircleView.swift
//  There
//
//  Created by Michael Kavouras on 10/2/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

class CircleView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = frame.size.height / 2.0
    }

}
