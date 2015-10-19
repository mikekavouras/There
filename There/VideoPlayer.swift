//
//  VideoPlayer.swift
//  There
//
//  Created by Michael Kavouras on 10/11/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation

class VideoPlayer: AVPlayer {
    
    override init() {
        super.init()
    }
    
    override init(playerItem item: AVPlayerItem) {
        super.init(playerItem: item)
        setupObservers()
        play()
    }
    
    deinit {
        currentItem?.removeObserver(self, forKeyPath: "playbackBufferFull")
    }
    
    private func setupObservers() {
        currentItem?.addObserver(self, forKeyPath: "playbackBufferFull", options: .New, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if let item = currentItem {
            if let object = object {
                if item == object as! NSObject {
                    if keyPath == "playbackBufferFull" {
                        play()
                    }
                }
            }
        }
        
        super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    }
    
}