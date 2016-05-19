//
//  VerticalSlider.swift
//  Kindio
//
//  Created by Alin Petrus on 5/19/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit
import HUMSlider

class VerticalSlider: HUMSlider {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.customize()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.customize()
    }
    
    // MARK: private
    
    func customize() {
        self.sectionCount = 11
        self.saturatedColor = UIColor.robinEggBlue()
        self.tickColor = UIColor.robinEggBlue()
        self.makeVertical()
    }

    func makeVertical() {
        var rotation = CGAffineTransformIdentity
        rotation = CGAffineTransformRotate(rotation, CGFloat.init(-(M_PI / 2)))
        self.transform = rotation
    }
}
