//
//  ThemedSlider.swift
//  Kindio
//
//  Created by Alin Petrus on 5/9/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit

class ThemedSlider: UISlider {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.maximumTrackTintColor = ThemeManager.sharedInstance.activeColor
        self.minimumTrackTintColor = ThemeManager.sharedInstance.standardColor
    }

}
