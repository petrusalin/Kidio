//
//  EQAmplification.swift
//  Kindio
//
//  Created by Alin Petrus on 5/19/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import Foundation

struct EQAmplification {
    var band: Int
    var gain: Int {
        didSet(newValue) {
            if (gain > 24) {
                gain = 24
            } else if (gain < -96) {
                gain = -96
            }
        }
    }
    
    init(band: Int, gain: Int) {
        self.band = band
        self.gain = gain
    }
}