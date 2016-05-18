//
//  PlaySession.swift
//  Kindio
//
//  Created by Alin Petrus on 5/3/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import EZAudio

let shuffleSaveKey = "shuffleSaveKey"
let repeatSaveKey = "repeatSaveKey"

class PlaySession: NSObject {
    let musicCollectionManager : MusicCollectionsManager!
    let audioSession : AVAudioSession!
    let mediaPlayer : EqualizerAudioPlayer!
    var shuffle  = NSUserDefaults.standardUserDefaults().boolForKey(shuffleSaveKey) {
        didSet(newValue) {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: shuffleSaveKey)
        }
    }
    var loop = NSUserDefaults.standardUserDefaults().boolForKey(repeatSaveKey) {
        didSet(newValue) {
        NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: repeatSaveKey)
        }
    }
    
    override init() {
        self.musicCollectionManager = MusicCollectionsManager()
        self.audioSession = AVAudioSession.sharedInstance()
        self.mediaPlayer = EqualizerAudioPlayer.sharedAudioPlayer()
        self.mediaPlayer.output = EqualizerOutput()
        
        do {
            try self.audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try self.audioSession.setActive(true)
        } catch {
            print(error)
        }
    }
    
    
}
