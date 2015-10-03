//
//  PullToSelectView.swift
//  There
//
//  Created by Michael Kavouras on 10/2/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

@IBDesignable
class PullToSelectView: UIView {
    
    var selectedIndex: Int?
    var numberOfSelections = 1
    lazy var selectionWidth: CGFloat = {
        return self.frame.size.width / CGFloat(self.numberOfSelections)
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        reset()
    }
    
    func reset() {
        for subview in subviews {
            subview.backgroundColor = subview.backgroundColor?.colorWithAlphaComponent(0.2)
        }
    }
    
    func selectViewAtPoint(point: CGPoint) {
        for subview in subviews {
            if subview.frame.contains(point) {
                subview.backgroundColor = subview.backgroundColor?.colorWithAlphaComponent(1.0)
                selectedIndex = Int(floor(point.x / selectionWidth))
            } else {
                subview.backgroundColor = subview.backgroundColor?.colorWithAlphaComponent(0.2)
            }
        }
    }
    
}
