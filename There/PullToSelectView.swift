//
//  PullToSelectView.swift
//  There
//
//  Created by Michael Kavouras on 10/2/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

class PullToSelectView: UIView {
    
    var selectedIndex: Int?
    private var numberOfSelections: Int {
       return subviews.count
    }
    
    func reset() {
        for subview in subviews {
            subview.alpha = 0.2
        }
    }
    
    func selectViewAtPoint(point: CGPoint) {
        for subview in subviews {
            if subview.frame.contains(point) {
                subview.alpha = 1.0
                selectedIndex = subviews.indexOf(subview)
            } else {
                subview.alpha = 0.2
            }
        }
    }
    
}
