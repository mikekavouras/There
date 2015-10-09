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

class MainStreamCollectionViewCell: UICollectionViewCell {
    
    var entry: Entry! {
        didSet {
            imageView.image = nil
            loadEntry()
        }
    }

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: PFImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        backgroundColor = UIColor.groupTableViewBackgroundColor()
    }
    
    private func loadEntry()
    {
        timestampLabel.text = entry.createdAt?.timeAgoSimple
        imageView.file = entry.typeMapped == .Video ? entry.posterImage : entry.media
        imageView.loadInBackground()
        iconImageView.image = entry.typeMapped.icon()
    }
}
