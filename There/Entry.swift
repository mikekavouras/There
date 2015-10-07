//
//  Entry.swift
//  There
//
//  Created by Michael Kavouras on 10/2/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import Foundation
import Parse

enum EntryType: String {
    case Text = "text"
    case Image = "image"
    case Video = "video"
    case Audio = "audio"
}

class Entry : PFObject, PFSubclassing {
   
    @NSManaged var location: PFGeoPoint?
    @NSManaged var type: String
    @NSManaged var media: PFFile?
    @NSManaged var caption: String
    
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
    
}
