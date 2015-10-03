//
//  SelectorView.swift
//  There
//
//  Created by Michael Kavouras on 10/2/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

struct KVOPaths {
    static let LayerBounds = "layer.bounds"
}

class SelectorView: UIView {
 
    @IBOutlet var label: UILabel!
    
    deinit {
        removeObserver(self, forKeyPath: KVOPaths.LayerBounds)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addObserver(self, forKeyPath: KVOPaths.LayerBounds, options: .New, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let _ = object as? SelectorView,
            _ = keyPath {
                label.alpha = (frame.size.height / 50) - 0.5
                return
        }
        super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    }

}
