//
//  SelectableCircleView.swift
//  There
//
//  Created by Michael Kavouras on 10/17/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

@IBDesignable
class SelectableCircleView: UIView {
    
    var _borderWidth: CGFloat = 0

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
            _borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var fillColor: UIColor = UIColor.greenColor()
    
    var selected = false {
        didSet {
            updateSelectedState()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        selected = !selected
        layer.borderWidth = selected ? 0 : _borderWidth
    }
    
    private func updateSelectedState() {
        backgroundColor = selected ? fillColor : UIColor.clearColor()
    }

}
