//
//  UploadQueue.swift
//  There
//
//  Created by Michael Kavouras on 10/19/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

protocol UploadQueueDelegate: class {
    func uploadQueueWillProcessUpload(queue: UploadQueue)
    func uploadQueueDidProcessUpload(queue: UploadQueue)
}

class UploadQueue: UploadDelegate {
    
    static let sharedQueue = UploadQueue()
    
    weak var delegate: UploadQueueDelegate?
    
    var isEmpty: Bool {
        return queue.count == 0
    }
    
    var description: String {
        switch queue.count {
        case 0:
            return "Processing 0 uploads"
        case 1:
            return "Processing 1 upload"
        default:
            return "Processing \(queue.count) uploads"
        }
    }
    
    private var queue = [Upload]() {
        didSet {
            if oldValue.count > queue.count {
                delegate?.uploadQueueDidProcessUpload(self)
                
                // If the queue isn't empty, begin processing the next item
                if !isEmpty {
                    processNextItem()
                }
            } else {
                delegate?.uploadQueueWillProcessUpload(self)
                
                // Process the item immediately if it's the only one in the queue
                if queue.count == 1 {
                    processNextItem()
                }
            }
        }
    }
    
    func addItem(item: Upload) {
        item.delegate = self
        queue.append(item)
    }
    
    private func removeItem(upload: Upload) {
        var index = -1
        for (i, u) in queue.enumerate() {
            if u == upload {
                index = i
            }
        }
        
        if index != -1 {
            queue.removeAtIndex(index)
        }
    }
    
    private func processNextItem() {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            appDelegate.addFiniteBackgroundTask({ (identifier: UIBackgroundTaskIdentifier) -> () in
                self.queue.first!.process {
                    UIApplication.sharedApplication().endBackgroundTask(identifier)
                    print("finished background task")
                }
            })
        }
    }
    
    // MARK: -
    // MARK: Upload delegate
    
    func uploadDidBeginProcessing(upload: Upload) {
        print("begin upload")
    }
    
    func uploadDidFinishProcessing(upload: Upload) {
        print("finished upload")
        
        removeItem(upload)
    }
    
    func uploadDidFailToProcess(upload: Upload) {
        
        // TODO: Handle Error
        print("error uploading")
    }
    
}