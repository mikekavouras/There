//
//  Device.swift
//  There
//
//  Created by Michael Kavouras on 10/6/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit


extension UIDevice {
    
    public class func hasCamera() -> Bool
    {
        return UIImagePickerController.isSourceTypeAvailable(.Camera)
    }
}