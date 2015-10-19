//
//  Upload.swift
//  There
//
//  Created by Michael Kavouras on 10/19/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import Foundation

protocol UploadDelegate: class {
    func uploadDidBeginProcessing(upload: Upload)
    func uploadDidFinishProcessing(upload: Upload)
    func uploadDidFailToProcess(upload: Upload)
}

class Upload: NSObject {
    
    let entry: Entry
    weak var delegate: UploadDelegate?
    
    init(entry: Entry) {
        self.entry = entry
    }
    
    func process() {
        delegate?.uploadDidBeginProcessing(self)
        
        let onCompleteHandler: (Bool, NSError?) -> Void = { saved, error in
            if let _ = error {
                self.delegate?.uploadDidFailToProcess(self)
            } else {
                self.delegate?.uploadDidFinishProcessing(self)
            }
        }
        
        if entry.saveLocal {
            // currently fails silently
            entry.saveMediaToCameraRoll()
        }
        
        entry.saveInBackgroundWithBlock { (saved: Bool, error: NSError?) -> Void in
            onCompleteHandler(saved, error)
        }
    }
}