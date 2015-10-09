//
//  MainStreamCollectionViewCell.swift
//  There
//
//  Created by Michael Kavouras on 10/7/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import NSDate_TimeAgo

class MainStreamCollectionViewCell: UICollectionViewCell {
    
    var entry: Entry! {
        didSet {
            textLabel.text = entry.caption
            timestampLabel.text = entry.createdAt?.timeAgoSimple()
            imageView.image = nil
            imageView.file = entry.typeMapped == .Video ? entry.posterImage : entry.media
            imageView.loadInBackground()
            iconImageView.image = entry.typeMapped.icon()
        }
    }

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: PFImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.groupTableViewBackgroundColor()
    }
}
