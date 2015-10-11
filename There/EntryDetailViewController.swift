//
//  EntryDetailViewController.swift
//  There
//
//  Created by Michael Kavouras on 10/7/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit
import ParseUI
import AVKit
import AVFoundation

class EntryDetailViewController: UIViewController {

    var entry: Entry!
    var mediaView: UIView?
    var videoPlayer: AVPlayer?
    
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var mediaContainerView: UIView!
    
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewAspectRatioConstraint: NSLayoutConstraint!
    
    
    // MARK: -
    // MARK: Life cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        contentViewWidthConstraint.constant = view.frame.size.width
        if let mediaView = mediaView {
            print(mediaContainerView.bounds)
            mediaView.frame = mediaContainerView.bounds
        }
    }
    
    
    // MARK: -
    // MARK: Setup
    
    private func setup() {
        
        timestampLabel.text = "\(entry.createdAt!.timeAgoSimple) ago"
        captionLabel.text = entry.caption ?? ""
        
        mediaContainerView.clipsToBounds = true
        
        setupMedia()
        setupNavigationItem()
    }
    
    private func setupNavigationItem() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismiss")
    }
    
    private func setupMedia() {
        
        switch entry.typeMapped {
        case .Image:
            setupImage()
        case .Video:
            setupVideo()
        case .Text:
            // not working
            imageViewAspectRatioConstraint.constant = 0
        default: break
        }
        
        view.setNeedsDisplay()
        view.layoutIfNeeded()
    }
    
    private func setupImage() {
        
        mediaView = PFImageView()
        mediaView!.contentMode = .ScaleAspectFill
        mediaView!.frame = mediaContainerView.bounds
        if let media = entry.media {
            (mediaView as! PFImageView).file = media
            (mediaView as! PFImageView).loadInBackground()
        }
        mediaContainerView.addSubview(mediaView!)
    }
    
    private func setupVideo() {
        
        if let url = entry.media!.url {
            
            let asset = AVAsset(URL: NSURL(string: url)!)
            let playerItem = AVPlayerItem(asset: asset)
            videoPlayer = AVPlayer(playerItem: playerItem)
            videoPlayer!.play()
            videoPlayer!.actionAtItemEnd = .None
            
            let layer = AVPlayerLayer(player: videoPlayer!)
            layer.frame = mediaContainerView.bounds
            layer.videoGravity = AVLayerVideoGravityResizeAspectFill
            mediaContainerView.layer.addSublayer(layer)
        }
    }
    
    
    // MARK: -
    // MARK: User actions
    
    @objc private func dismiss() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
