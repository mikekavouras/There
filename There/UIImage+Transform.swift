//
//  UIImage+Transform.swift
//  There
//
//  Created by Michael Kavouras on 10/25/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit

extension UIImage {
    func scale(amount: CGFloat) -> UIImage? {
        let newSize = CGSize(width: self.size.width * amount, height: self.size.height * amount)
        UIGraphicsBeginImageContext(newSize)
        self.drawInRect(CGRect(origin: CGPointZero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}