//
//  NSURL+ImageGenerator.swift
//  There
//
//  Created by Michael Kavouras on 10/8/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit
import AVFoundation

extension NSURL {
    
    func thumbnailImagePreview() -> UIImage? {
        let asset = AVURLAsset(URL: self)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels
        
        do {
            let time: CMTime = CMTime(seconds: 0.0, preferredTimescale:1)
            let imageRef = try imageGenerator.copyCGImageAtTime(time, actualTime: nil)
            return UIImage(CGImage: imageRef)
        } catch {
            return nil
        }
    }
}