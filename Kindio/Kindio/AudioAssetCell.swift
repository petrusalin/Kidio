//
//  AudioAssetCell.swift
//  Kindio
//
//  Created by Alin Petrus on 5/3/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit

class AudioAssetCell: UITableViewCell {

    @IBOutlet var assetImageView: UIImageView!
    @IBOutlet var assetTitleLabel: UILabel!
    @IBOutlet var assetSubtitleLabel: UILabel!
    @IBOutlet var extraLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = UIColor.blueCharcoal()
        self.backgroundColor = UIColor.blueCharcoal()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.assetImageView.image = nil
        self.assetTitleLabel.text = ""
        self.assetSubtitleLabel.text = ""
        self.extraLabel.text = ""
    }
    
}
