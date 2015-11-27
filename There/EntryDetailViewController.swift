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
    var mediaView: PFImageView?
    var videoPlayer: AVPlayer?
    var peeking = false {
        didSet {
            if toolbar != nil {
                toolbar.hidden = peeking
            }
        }
    }
    
    @IBOutlet weak var toolbar: UIToolbar!
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
            mediaView.frame = mediaContainerView.bounds
        }
    }
    
    deinit {
//        videoPlayer?.currentItem?.removeObserver(self, forKeyPath: "playbackBufferFull")
    }
    
    
    // MARK: -
    // MARK: Setup
    
    private func setup() {
        
        timestampLabel.text = "\(entry.createdAt!.timeAgoSimple) ago"
        captionLabel.text = entry.caption ?? ""
        
        mediaContainerView.clipsToBounds = true
        
        setupMedia()
        setupNavigationItem()
        
        if peeking {
            toolbar.hidden = true
        }
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
            imageViewAspectRatioConstraint.constant = 0 // not working
        default: break
        }
        
        view.setNeedsDisplay()
        view.layoutIfNeeded()
    }
    
    private func setupImage() {
        
        mediaView = PFImageView()
        mediaView!.contentMode = .ScaleAspectFill
        
        if let media = entry.media {
            mediaView!.file = media
            mediaView!.loadInBackground()
        }
        mediaContainerView.addSubview(mediaView!)
    }
    
    private func setupVideo() {
        
        
        if let media = entry.media,
            posterImage = entry.posterImage,
            urlString = media.url,
            url = NSURL(string: urlString) {
                
                // display the poster image
                mediaView = PFImageView()
                mediaView!.contentMode = .ScaleAspectFill
                mediaView!.file = posterImage
                mediaView!.loadInBackground()
                mediaView!.frame = mediaContainerView.bounds
                mediaContainerView.addSubview(mediaView!)
    //                
                // create the video player
                let asset = AVAsset(URL: url)
                let playerItem = AVPlayerItem(asset: asset)
                videoPlayer = AVPlayer(playerItem: playerItem)

                videoPlayer!.actionAtItemEnd = .None
                videoPlayer!.play()
                
    //            videoPlayer?.currentItem?.addObserver(self, forKeyPath: "playbackBufferFull", options: .New, context: nil)

                
                // add the video to the UI
                let layer = AVPlayerLayer(player: videoPlayer!)
                layer.frame = mediaContainerView.bounds
                layer.videoGravity = AVLayerVideoGravityResizeAspectFill
                mediaContainerView.layer.addSublayer(layer)
        }
    }
    
    
    // MARK: -
    // MARK: KVO
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if let item = videoPlayer!.currentItem {
            if let object = object {
                if item == object as! NSObject {
                    if keyPath == "playbackBufferFull" {
                        videoPlayer!.play()
                    }
                }
            }
        }
        
        super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    }
    
    
    // MARK: -
    // MARK: User actions
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
