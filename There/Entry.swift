//
//  Entry.swift
//  There
//
//  Created by Michael Kavouras on 10/2/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import Foundation
import Parse

class Entry : PFObject, PFSubclassing {
   
    @NSManaged var location: PFGeoPoint?
    @NSManaged var type: String
    @NSManaged var media: PFFile?
    
    class func parseClassName() -> String {
        return "Entry"
    }
    
}
