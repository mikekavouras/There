//
//  Entry.swift
//  There
//
//  Created by Michael Kavouras on 10/2/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import Foundation
import Parse
import AssetsLibrary

enum EntryType: String {
    case Text = "text"
    case Image = "image"
    case Video = "video"
    case Audio = "audio"
    
    func icon() -> UIImage {
        switch self {
        case .Text:
            return UIImage.iconForTextType()
        case .Image:
            return UIImage.iconForImageType()
        case .Video:
            return UIImage.iconForVideoType()
        case .Audio:
            return UIImage.iconForAudioType()
            
        }
    }
}

class Entry : PFObject, PFSubclassing {
   
    @NSManaged var location: PFGeoPoint?
    @NSManaged var type: String
    @NSManaged var media: PFFile?
    @NSManaged var caption: String?
    @NSManaged var posterImage: PFFile?
    
    // for saving to camera roll
    var image: UIImage?
    var videoURL: NSURL?
    var saveLocal = false
    
    var isValid: Bool {
        return (caption != nil && caption != "") || media != nil
    }
    
    var typeMapped: EntryType {
        get { return EntryType(rawValue: self.type)! }
        set { type = newValue.rawValue }
    }
    
    class func parseClassName() -> String {
        
        return "Entry"
    }
    
    class func fetchAtLocation(location: CLLocation, completion: ([Entry]?) -> Void) {
        
        let query = PFQuery(className: self.parseClassName())
        query.limit = 30
        query.orderByDescending("createdAt")
        query.whereKey("location", nearGeoPoint: PFGeoPoint(location: location), withinKilometers: MAX_DISTANCE_FILTER / 1000.0)
        
        query.findObjectsInBackgroundWithBlock { (results: [PFObject]?, error: NSError?) -> Void in
            completion(results as? [Entry])
        }
    }
    
    func saveMediaToCameraRoll() {
        switch typeMapped {
        case .Image:
            ALAssetsLibrary().saveImage(image!, toAlbum: "There", withCompletionBlock: { (error: NSError?) -> () in
                if let _ = error {
                    print("error saving to camera roll")
                }
            })
        case .Video:
            ALAssetsLibrary().saveVideo(videoURL!, toAlbum: "There", withCompletionBlock: { (error: NSError?) -> () in
                if let _ = error {
                    print("error saving to camera roll")
                }
            })
        default: break
        }
    }
    
}
