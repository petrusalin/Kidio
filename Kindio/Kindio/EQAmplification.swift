//
//  EQAmplification.swift
//  Kindio
//
//  Created by Alin Petrus on 5/19/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import Foundation

enum EqualizerBand: Int {
    case Band32 = 32
    case Band250 = 250
    case Band500 = 500
    case Band1000 = 1000
    case Band2000 = 2000
    case Band16000 = 16000
    
    static let allValues = [Band32, Band250, Band500, Band1000, Band2000, Band16000]
}

struct EQAmplification {
    static let minGain : Float = -96.0
    static let maxGain : Float = 24.0
    
    var band: EqualizerBand
    var gain: Float {
        didSet(newValue) {
            if (gain > EQAmplification.maxGain) {
                gain = EQAmplification.maxGain
            } else if (gain < EQAmplification.minGain) {
                gain = EQAmplification.minGain
            }
        }
    }
    
    init(band: EqualizerBand, gain: Float) {
        self.band = band
        self.gain = gain
    }
}

class SixBandEqualizer {
    private var amps: Dictionary<EqualizerBand, EQAmplification> = [EqualizerBand : EQAmplification]()
    
    init() {
        for band in EqualizerBand.allValues {
            amps[band] = EQAmplification.init(band: band, gain: 0)
        }
    }
    
    func amplifications() -> [EQAmplification] {
        return Array(self.amps.values)
    }
    
    func setAmplificationConfiguration(amps: [EqualizerBand : EQAmplification]) {
        for band in EqualizerBand.allValues {
            self.amps[band] = EQAmplification.init(band: band, gain: 0)
        }
    }
    
    func setAmplification(amp: EQAmplification) {
        amps[amp.band] = amp
    }
    
    func setAmplification(amp: Float, band:EqualizerBand) {
        var amplification = self.amps[band]
        amplification!.gain = amp
    }
}