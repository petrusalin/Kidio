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
let eqPresetSaveKey = "eqPresetSaveKey"

class PlaySession: NSObject {
    let musicCollectionManager : MusicCollectionsManager!
    let audioSession : AVAudioSession!
    let mediaPlayer : EqualizerAudioPlayer!
    private var mediaItems = [MPMediaItem]()
    private var currentMediaItemIndex = 0
    private var collection : MPMediaItemCollection?
    var sixBandEqualizer : SixBandEqualizer?
    
    var shuffle  = NSUserDefaults.standardUserDefaults().boolForKey(shuffleSaveKey) {
        willSet(newValue) {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: shuffleSaveKey)
            self.prepareMediaItems(nil)
        }
    }
    var loop = NSUserDefaults.standardUserDefaults().boolForKey(repeatSaveKey) {
        willSet(newValue) {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: repeatSaveKey)
        }
    }
    
    var eqPreset : Int {
        willSet(newValue) {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: eqPresetSaveKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    override init() {
        self.eqPreset = NSUserDefaults.standardUserDefaults().integerForKey(eqPresetSaveKey)
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
    
    // MARK : public
    
    func prepareToPlay(mediaItem: MPMediaItem, collection: MPMediaItemCollection) {
        self.mediaPlayer.audioFile = EZAudioFile.init(URL: mediaItem.assetURL)
        self.collection = collection
        
        self.prepareMediaItems(mediaItem)
    }
    
    func currentTrack() -> MPMediaItem? {
        if self.currentMediaItemIndex < self.mediaItems.count {
            return self.mediaItems[self.currentMediaItemIndex]
        }
        
        return nil
    }
    
    func selectEQPreset(preset: Int) {
        self.eqPreset = preset
        self.mediaPlayer.selectEQPreset(preset)
    }
    
    func updatedSixBandEqualizer(equalizer: SixBandEqualizer) {
        self.mediaPlayer.pause()
        self.sixBandEqualizer = equalizer
        let delegate = self.mediaPlayer.output.delegate
        self.mediaPlayer.output = ConfigurableEqualizerOutput.init(equalizer: equalizer)
        self.mediaPlayer.output.delegate = delegate
        self.mediaPlayer.play()
    }
    
    func playNextTrack() {
        if let track = self.nextTrack() {
            self.mediaPlayer.audioFile = EZAudioFile.init(URL: track.assetURL)
            self.mediaPlayer.play()
        }
    }
    
    func playPreviousTrack() {
        if let track = self.previousTrack() {
            self.mediaPlayer.audioFile = EZAudioFile.init(URL: track.assetURL)
            self.mediaPlayer.play()
        }
    }
    
    func nextTrack() -> MPMediaItem? {
        if self.currentMediaItemIndex == self.mediaItems.count - 1  {
            if self.loop {
                self.currentMediaItemIndex = 0
                
                return self.mediaItems[self.currentMediaItemIndex]
            } else {
                return nil
            }
        } else {
            self.currentMediaItemIndex += 1
            
            return self.mediaItems[self.currentMediaItemIndex]
        }
    }
    
    func previousTrack() -> MPMediaItem? {
        if (self.currentMediaItemIndex == 0) {
            if self.loop {
                self.currentMediaItemIndex = self.mediaItems.count - 1
                return self.mediaItems[self.currentMediaItemIndex]
            } else {
                return nil
            }
        } else {
            self.currentMediaItemIndex -= 1
            return self.mediaItems[self.currentMediaItemIndex]
        }
    }
    
    // MARK : private
    
    private func prepareMediaItems(startingItem: MPMediaItem?) {
        if let items = self.collection?.items {
            self.mediaItems = items
            
            if let item = startingItem {
                self.currentMediaItemIndex = items.indexOf(item)!
            }
            
            if (self.shuffle == true) {
                self.shuffleMediaItems(items)
            }
        }
    }
    
    private func shuffleMediaItems(items: [MPMediaItem]) {
        if items.count < 2 { return }
        
        for index in 0..<items.count {
            let other = Int(arc4random_uniform(UInt32(index)))
            guard index != other else { continue }
            
            swap(&self.mediaItems[index], &self.mediaItems[other])
        }
    }
    
}
