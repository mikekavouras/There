//
//  UploadQueue.swift
//  There
//
//  Created by Michael Kavouras on 10/19/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import Foundation

protocol UploadQueueDelegate: class {
    func uploadQueueWillProcessUpload(queue: UploadQueue)
    func uploadQueueDidProcessUpload(queue: UploadQueue)
    func uploadQueueDidFinishProcessingUploads(queue: UploadQueue)
}

class UploadQueue: UploadDelegate {
    
    static let sharedQueue = UploadQueue()
    
    weak var delegate: UploadQueueDelegate?
    
    var uploads = [Upload]() {
        didSet {
            if uploads.count == 0 {
                delegate?.uploadQueueDidProcessUpload(self)
                delegate?.uploadQueueDidFinishProcessingUploads(self)
            } else {
                if oldValue.count > uploads.count {
                    delegate?.uploadQueueDidProcessUpload(self)
                } else {
                    delegate?.uploadQueueWillProcessUpload(self)
                }
            }
        }
    }
    
    func addUpload(upload: Upload) {
        upload.delegate = self
        uploads.append(upload)
        upload.process()
    }
    
    func uploadDidBeginProcessing(upload: Upload) {
        
    }
    
    func uploadDidFinishProcessing(upload: Upload) {
        
        var index = -1
        for (i, u) in uploads.enumerate() {
            if u == upload {
                index = i
            }
        }
        
        if index != -1 {
            uploads.removeAtIndex(index)
        }
        
    }
    
    func uploadDidFailToProcess(upload: Upload) {
        // handle error
    }
    
}