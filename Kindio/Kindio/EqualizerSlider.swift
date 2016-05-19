//
//  EqualizerSlider.swift
//  Kindio
//
//  Created by Alin Petrus on 5/19/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit

class EqualizerSlider: VerticalSlider {

    override func customize() {
        super.customize()
        
        self.tintColor = UIColor.robinEggBlue()
        let sliderImage = UIImage.init(imageLiteral: "sliderBackground").resizableImageWithCapInsets(UIEdgeInsetsZero, resizingMode: .Stretch)
        self.setMaximumTrackImage(sliderImage, forState: .Normal)
        self.setMinimumTrackImage(sliderImage, forState: .Normal)
        self.setThumbImage(UIImage.init(imageLiteral: "knobEmpty"), forState: .Normal)
        self.thumbTintColor = UIColor.robinEggBlue()
        self.minimumValueImage = UIImage.init(imageLiteral: "soundLow")
        self.maximumValueImage = UIImage.init(imageLiteral: "soundHigh")
    }
    
    override func makeVertical() {
        //do nothing
    }

}
