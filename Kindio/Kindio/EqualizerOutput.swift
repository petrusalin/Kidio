//
//  EqualizerOutput.swift
//  Kindio
//
//  Created by Alin Petrus on 5/17/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import EZAudio

class EqualizerOutput: EZOutput {
    var eqNodeInfo = EZAudioNodeInfo()
    var equalizerPresetArray : CFMutableArray?
    
    override func connectOutputOfSourceNode(sourceNode: AUNode, sourceNodeOutputBus: UInt32, toDestinationNode destinationNode: AUNode, destinationNodeInputBus: UInt32, inGraph graph: AUGraph) -> OSStatus {
        
        var eqDescription = AudioComponentDescription(componentType: kAudioUnitType_Effect, componentSubType: kAudioUnitSubType_AUiPodEQ, componentManufacturer: kAudioUnitManufacturer_Apple, componentFlags: 0, componentFlagsMask: 0)
        
        EZAudioUtilities.checkResult(AUGraphAddNode(graph, &eqDescription, &self.eqNodeInfo.node), operation: "Failure")
        EZAudioUtilities.checkResult(AUGraphConnectNodeInput(graph, sourceNode, sourceNodeOutputBus, self.eqNodeInfo.node, 0), operation: "Failure")
        EZAudioUtilities.checkResult(AUGraphConnectNodeInput(graph, self.eqNodeInfo.node, 0, destinationNode, destinationNodeInputBus), operation: "Failure")
        
        var size = UInt32(sizeof(CFMutableArray))
        EZAudioUtilities.checkResult(AUGraphNodeInfo(graph,
            self.eqNodeInfo.node,
            &eqDescription,
            &self.eqNodeInfo.audioUnit), operation: "Failed")
        EZAudioUtilities.checkResult( AudioUnitGetProperty(self.eqNodeInfo.audioUnit, kAudioUnitProperty_FactoryPresets, kAudioUnitScope_Global, 0, &self.equalizerPresetArray, &size), operation: "Could not get presets")
        
        return noErr
    }
    
    func selectEQPreset(preset: Int) {
        let eqPreset = CFArrayGetValueAtIndex(self.equalizerPresetArray, preset)
        let size  = UInt32(sizeof(AUPreset))
        
        EZAudioUtilities.checkResult(AudioUnitSetProperty(self.eqNodeInfo.audioUnit, kAudioUnitProperty_PresentPreset, kAudioUnitScope_Global, 0, eqPreset, size), operation: "Failed to set preset")
    }
}
