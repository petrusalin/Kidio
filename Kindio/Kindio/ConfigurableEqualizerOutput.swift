//
//  ConfigurableEqualizerOutput.swift
//  Kindio
//
//  Created by Alin Petrus on 5/19/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit
import EZAudio

class ConfigurableEqualizerOutput: EZOutput {
    var eqNodeInfo = EZAudioNodeInfo()
    var sixBandEqualizer : SixBandEqualizer
    
    init(equalizer: SixBandEqualizer) {
        sixBandEqualizer = equalizer
        
        super.init()
    }
    
    override func connectOutputOfSourceNode(sourceNode: AUNode, sourceNodeOutputBus: UInt32, toDestinationNode destinationNode: AUNode, destinationNodeInputBus: UInt32, inGraph graph: AUGraph) -> OSStatus {
        
        var eqDescription = AudioComponentDescription(componentType: kAudioUnitType_Effect, componentSubType: kAudioUnitSubType_NBandEQ, componentManufacturer: kAudioUnitManufacturer_Apple, componentFlags: 0, componentFlagsMask: 0)
        
        EZAudioUtilities.checkResult(AUGraphAddNode(graph, &eqDescription, &self.eqNodeInfo.node), operation: "Failure")
        EZAudioUtilities.checkResult(AUGraphConnectNodeInput(graph, sourceNode, sourceNodeOutputBus, self.eqNodeInfo.node, 0), operation: "Failure")
        EZAudioUtilities.checkResult(AUGraphConnectNodeInput(graph, self.eqNodeInfo.node, 0, destinationNode, destinationNodeInputBus), operation: "Failure")
        EZAudioUtilities.checkResult(AUGraphNodeInfo(graph,
            self.eqNodeInfo.node,
            &eqDescription,
            &self.eqNodeInfo.audioUnit), operation: "Failed")
        
        self.configure()
        
        return noErr
    }
    
    func configure() {
        var noBands = UInt32(self.sixBandEqualizer.amplifications().count)
        // Set the number of bands first
        AudioUnitSetProperty(self.eqNodeInfo.audioUnit,
                             kAUNBandEQProperty_NumberOfBands,
                             kAudioUnitScope_Global,
                             0,
                             &noBands,
                             UInt32(sizeof(UInt32)));
        
        for (index, amp) in self.sixBandEqualizer.amplifications().enumerate() {
            AudioUnitSetParameter(self.eqNodeInfo.audioUnit,
                                  kAUNBandEQParam_Frequency + UInt32(index),
                                  kAudioUnitScope_Global,
                                  0,
                                  AudioUnitParameterValue(amp.band.rawValue),
                                  0)
            AudioUnitSetParameter(self.eqNodeInfo.audioUnit,
                                  kAUNBandEQParam_BypassBand + UInt32(index),
                                  kAudioUnitScope_Global,
                                  0,
                                  AudioUnitParameterValue(0),
                                  0)
            AudioUnitSetParameter(self.eqNodeInfo.audioUnit,
                                  kAUNBandEQParam_Gain + UInt32(index),
                                  kAudioUnitScope_Global,
                                  0,
                                  AudioUnitParameterValue(amp.gain),
                                  0)
        }
        
    }
    
}
