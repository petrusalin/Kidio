//
//  SixBandEqualizerManager.swift
//  Kindio
//
//  Created by Alin Petrus on 5/19/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit

class SixBandEqualizerManager: NSObject {
    var sixBandEqualizer : SixBandEqualizer?
    var sliders : [EqualizerSlider!]
    var playSession : PlaySession
    
    required init(sliders: [EqualizerSlider!], playSession: PlaySession) {
        self.sliders = sliders
        self.playSession = playSession
        
        super.init()
        
        
        if let eq = self.playSession.sixBandEqualizer {
            self.sixBandEqualizer = eq
            print("Woot")
        } else {
            self.sixBandEqualizer = SixBandEqualizer()
            print("Nooo")
        }
        
        self.establishConnections()
        self.setInitialSliderValues()
        
        assert(sixBandEqualizer!.amplifications().count == sliders.count, "Need an equal number of sliders and amps")
    }
    
    // MARK : private
    
    func establishConnections() {
        for index in 0..<self.sliders.count {
            let slider =  self.sliders[index]
            let amplification = self.sixBandEqualizer!.amplifications()[index]
            slider.tag = amplification.band.rawValue
            slider.addTarget(self, action: #selector(self.onGainChanged(_:)), forControlEvents: .ValueChanged)
        }
    }
    
    func setInitialSliderValues() {
        for index in 0..<self.sliders.count {
            let slider =  self.sliders[index]
            let amplification = self.sixBandEqualizer!.amplifications()[index]
            print(amplification)
            
            slider.minimumValue = EQAmplification.minGain
            slider.maximumValue = EQAmplification.maxGain
            print(slider.value)
            slider.value = amplification.gain
        }
    }
    
    // MARK : actions
    func onGainChanged(slider: EqualizerSlider) {
        print(slider.value)
        print(EqualizerBand(rawValue: slider.tag)!)
        self.sixBandEqualizer!.setAmplification(slider.value, band: EqualizerBand(rawValue: slider.tag)!)
        self.playSession.updatedSixBandEqualizer(self.sixBandEqualizer!)
    }

}
