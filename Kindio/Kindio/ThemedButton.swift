//
//  ThemedButton.swift
//  Kindio
//
//  Created by Alin Petrus on 5/9/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit

class ThemedButton: UIButton {

    override var selected: Bool {
        willSet(newValue) {
            if (newValue == true) {
                self.tintColor = ThemeManager.sharedInstance.activeColor
            } else {
                self.tintColor = ThemeManager.sharedInstance.standardColor
            }
            
            self.onUpdateState()
        }
    }
    
    private func onUpdateState() {
        if let image = self.currentImage {
            self.setImage(image.imageWithRenderingMode(.AlwaysTemplate), forState: self.state)
        }
    }
}
