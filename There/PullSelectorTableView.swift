//
//  OptionSelectableTableView.swift
//  There
//
//  Created by Michael Kavouras on 10/2/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

protocol PullSelectorTableViewDelegate {
    func pullSelectorTableView(tableView: PullSelectorTableView, didSelectOptionAtIndex index: Int)
}

class PullSelectorTableView: UITableView, UIGestureRecognizerDelegate {
    
    var pullSelectorDelegate: PullSelectorTableViewDelegate?
    
    lazy var selectView: PullToSelectView = {
        return NSBundle.mainBundle().loadNibNamed("PullToSelectView", owner: self, options: nil).first as! PullToSelectView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(selectView)
        addObserver(self, forKeyPath: "contentOffset", options: .New, context: nil)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: "panning:")
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
    }
    
    @objc private func panning(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Changed:
            var point = gesture.locationInView(self)
            point.y = 0
            if fabs(gesture.translationInView(self).x) > 10 {
                selectView.selectViewAtPoint(point)
            }
        case .Ended:
            if let idx = selectView.selectedIndex {
                pullSelectorDelegate?.pullSelectorTableView(self, didSelectOptionAtIndex: idx)
                selectView.reset()
            }
        default: break
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let _ = object as? PullSelectorTableView,
            _ = keyPath {
                let offsetY = contentOffset.y + 64
                selectView.frame.origin.y = offsetY
                selectView.frame.size.height = -offsetY
                return
        }
        super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    }
    
    // MARK: Gesture recognizer delegate
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
