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

class PlaySession: NSObject {
    let musicCollectionManager : MusicCollectionsManager!
    let audioSession : AVAudioSession!
    let mediaPlayer : MPMusicPlayerController!
    
    override init() {
        self.musicCollectionManager = MusicCollectionsManager()
        self.audioSession = AVAudioSession.sharedInstance()
        self.mediaPlayer = MPMusicPlayerController.systemMusicPlayer()
        
        do {
            try self.audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try self.audioSession.setActive(true)
        } catch {
            print(error)
        }
    }
}
