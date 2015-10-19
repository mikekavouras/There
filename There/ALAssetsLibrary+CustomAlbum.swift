//
//  ALAssetsLibrary+CustomAlbum.swift
//  There
//
//  Created by Michael Kavouras on 10/18/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import AssetsLibrary
import UIKit

extension ALAssetsLibrary {
    
    func saveImage(image: UIImage, toAlbum albumName: String, withCompletionBlock completionBlock: (NSError?) -> ()) {
        
        if let orientation = ALAssetOrientation(rawValue: image.imageOrientation.rawValue) {
            writeImageToSavedPhotosAlbum(image.CGImage, orientation: orientation) { (url: NSURL!, error: NSError?) -> Void in
                
                if let error = error {
                    completionBlock(error)
                    return
                }
                
                self.addAssetURL(url, toAlbum: albumName, withCompletionBlock: completionBlock)
            }
        }

    }
    
    func saveVideo(videoURL: NSURL, toAlbum albumName: String, withCompletionBlock completionBlock: (error: NSError?) -> ()) {
        
        writeVideoAtPathToSavedPhotosAlbum(videoURL) { (url: NSURL!, error: NSError!) -> Void in
            
            if let error = error {
                completionBlock(error: error)
                return
            }
            
            self.addAssetURL(url, toAlbum: albumName, withCompletionBlock: completionBlock)
        }
    }
    
    private func addAssetURL(assetURL: NSURL, toAlbum albumName: String, withCompletionBlock completionBlock: (NSError?) -> ()) {
        
        var albumFound = false
        
        let addAssetBlock = { (group: ALAssetsGroup!) -> Void in
            self.assetForURL(assetURL, resultBlock: { (asset: ALAsset!) -> Void in
                group.addAsset(asset)
                completionBlock(nil)
                return
                }, failureBlock: { (error: NSError!) -> Void in
                    completionBlock(error)
            })
        }
        
        enumerateGroupsWithTypes(ALAssetsGroupAlbum, usingBlock: { (group: ALAssetsGroup!, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            
            if group == nil { // hit the end
                print("no more groups")
                if !albumFound {
                    self.addAssetsGroupAlbumWithName(albumName, resultBlock: { (group: ALAssetsGroup!) -> Void in
                        
                        addAssetBlock(group)
                        
                        }, failureBlock: { (error: NSError!) -> Void in
                           completionBlock(error)
                    })
                }
            } else {
                if let groupName = group.valueForProperty(ALAssetsGroupPropertyName) as? String {
                    if albumName.compare(groupName) == .OrderedSame {
                        print("found the group")
                        albumFound = true
                        
                        addAssetBlock(group)
                        
                        return
                    }
                }
            }
            
            }) { (error: NSError!) -> Void in
                completionBlock(error)
        }
        
    }
    
}