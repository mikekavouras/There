//
//  EntryDetailViewController.swift
//  There
//
//  Created by Michael Kavouras on 10/7/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit
import ParseUI

class EntryDetailViewController: UIViewController {

    var entry: Entry!
    @IBOutlet weak var imageView: PFImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewAspectRatioConstraint: NSLayoutConstraint!
    
    // MARK: -
    // MARK: Life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        imageView.layer.masksToBounds = true
        if let media = entry.media {
            imageView.file = media
            imageView.loadInBackground()
        } else {
            imageViewAspectRatioConstraint.constant = 0
        }
        
        timestampLabel.text = "\(entry.createdAt!.timeAgoSimple) ago"
        captionLabel.text = entry.caption
    }
    
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        
        contentViewWidthConstraint.constant = view.frame.size.width
    }
    
    // MARK: -
    // MARK: User actions
    
    @IBAction func closeButtonTapped(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
