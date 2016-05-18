//
//  EqualizerAudioPlayer.swift
//  Kindio
//
//  Created by Alin Petrus on 5/17/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit
import EZAudio

class EqualizerAudioPlayer: EZAudioPlayer {
    
    private func equalizerOutput() -> EqualizerOutput? {
        if let eqOutput = self.output as? EqualizerOutput {
            return eqOutput
        }
        
        return nil
    }
    
    func equalizerPresets() -> [String] {
        var presets = [String]()
        
        if let eqOutput = self.equalizerOutput() {
            for index in 0...(CFArrayGetCount(eqOutput.equalizerPresetArray) - 1) {
                let eqp = CFArrayGetValueAtIndex(eqOutput.equalizerPresetArray, index)
                let eqPreset : AUPreset =  UnsafePointer<AUPreset>(eqp).memory
                let presetName = eqPreset.presetName.takeUnretainedValue() as String
                
                presets.append(presetName)
            }
        }
        
        return presets
    }
    
    
    func selectEQPreset(preset: Int) {
        self.pause()
        if let eqOutput = self.equalizerOutput() {
            eqOutput.selectEQPreset(preset)
        }
        self.play()
    }
}
