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
    
    func thumbnailImagePreview -> UIImage {
        let asset = AVURLAsset
    }
    + (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL
    atTime:(NSTimeInterval)time
    {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetIG =
    [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetIG.appliesPreferredTrackTransform = YES;
    assetIG.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *igError = nil;
    thumbnailImageRef =
    [assetIG copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)
    actualTime:NULL
    error:&igError];
    
    if (!thumbnailImageRef)
    NSLog(@"thumbnailImageGenerationError %@", igError );
    
    UIImage *thumbnailImage = thumbnailImageRef
    ? [[UIImage alloc] initWithCGImage:thumbnailImageRef]
    : nil;
    
    return thumbnailImage;
    }
}