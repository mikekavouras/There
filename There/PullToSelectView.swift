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
    
    func reset() {
        for subview in subviews {
            subview.backgroundColor = subview.backgroundColor?.colorWithAlphaComponent(0.2)
        }
    }
    
    func selectViewAtPoint(point: CGPoint) {
        for subview in subviews {
            if subview.frame.contains(point) {
                subview.backgroundColor = subview.backgroundColor?.colorWithAlphaComponent(1.0)
                selectedIndex = subviews.indexOf(subview)
            } else {
                subview.backgroundColor = subview.backgroundColor?.colorWithAlphaComponent(0.2)
            }
        }
    }
    
}
