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
    
    var selectedIndex: Int? {
        didSet {
            if selectedIndex != oldValue {
                updateSelectedView()
            }
        }
    }
    
    var numberOfSelections = 1
    
    lazy var selectionWidth: CGFloat = {
        return self.frame.size.width / CGFloat(self.numberOfSelections)
    }()
    
    func selectViewForPoint(point: CGPoint) {
        selectedIndex = Int(floor(point.x / selectionWidth))
    }
    
    private func updateSelectedView() {
        let point = CGPointMake(self.selectionWidth * CGFloat(selectedIndex!) + 1, 1)
        for subview in subviews {
            (subview as! SelectorView).selected = false
        }
        if let subview = (subviews.filter { $0.frame.contains(point) }).first as? SelectorView {
            subview.selected = true
        }
    }
    
}
