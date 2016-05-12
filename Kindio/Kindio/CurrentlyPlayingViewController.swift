//
//  CurrentlyPlayingViewController.swift
//  Kindio
//
//  Created by Alin Petrus on 5/4/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit
import MediaPlayer

class CurrentlyPlayingViewController: UIViewController {
    
    @IBOutlet var currentTimeLabel: UILabel!
    @IBOutlet var remainingTimeLabel: UILabel!
    @IBOutlet var timeSlider: ThemedSlider!
    @IBOutlet var shuffleButton: ThemedButton!
    @IBOutlet var repeatButton: ThemedButton!
    @IBOutlet var previousTrackButton: ThemedButton!
    @IBOutlet var playPauseButton: ThemedButton!
    @IBOutlet var nextTrackButton: ThemedButton!
    @IBOutlet var volumeContainerView: UIView!
    @IBOutlet var bottomControlsView: UIView!
    @IBOutlet var topControlsView: UIView!
    
    var playSession : PlaySession!
    var mediaItem : MPMediaItem!
    var collection : MPMediaItemCollection!
    private var volumeView : MPVolumeView!
    private var playbackTimer : CADisplayLink!
    private var startPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bottomControlsView.backgroundColor = UIColor.blackColor()
        self.topControlsView.backgroundColor = UIColor.blackColor()
        self.view.backgroundColor = UIColor.blueCharcoal()
        
        self.playSession.mediaPlayer.beginGeneratingPlaybackNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(CurrentlyPlayingViewController.onTrackChanged),  name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification, object: nil)
        
        self.volumeView = MPVolumeView.init(frame: CGRectMake(0, 0, self.volumeContainerView.frame.size.width, self.volumeContainerView.frame.size.height))
        self.volumeView.autoresizingMask = .FlexibleWidth
        
        self.volumeContainerView.addSubview(self.volumeView)
        
        if (self.playSession.mediaPlayer.shuffleMode == .Off) {
            self.shuffleButton.selected = false
        } else {
            self.shuffleButton.selected = true
        }
        
        if (self.playSession.mediaPlayer.repeatMode == .None) {
            self.repeatButton.selected = false
        } else if (self.playSession.mediaPlayer.repeatMode == .All) {
            self.repeatButton.selected = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateUIForNewTrack()
        if (self.startPlaying == true) {
            self.startPlaying = false
            self.onPlayPause(self.playPauseButton)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
         super.viewWillDisappear(animated)
        
        self.invalidatePlaybackTimer()
    }
    
    func onTrackChanged() {
        self.mediaItem = self.playSession.mediaPlayer.nowPlayingItem
        
        self.updateUIForNewTrack()
    }
    
    private func updateUIForNewTrack() {
        if let duration = mediaItem.valueForProperty(MPMediaItemPropertyPlaybackDuration) {
            self.timeSlider.maximumValue = duration.floatValue
            self.timeSlider.minimumValue = 0.0
        }
        
        self.navigationItem.title = self.mediaItem.title
    }
    
    func startWithPlaySession(playSession: PlaySession, mediaItem: MPMediaItem, collection: MPMediaItemCollection) {
        self.playSession = playSession
        self.mediaItem = mediaItem
        self.collection = collection
        
        self.playSession.mediaPlayer.setQueueWithItemCollection(collection)
        self.playSession.mediaPlayer.nowPlayingItem = mediaItem
        self.startPlaying = true
        
        if let title = mediaItem.title , artist = mediaItem.artist {
            LastfmManager.sharedInstance.updateNowPlaying(title, artist: artist, completion: { (error) in
                
            })
        }
    }
    
    private func startPlaybackTimer() {
        self.playbackTimer = CADisplayLink.init(target: self, selector: #selector(CurrentlyPlayingViewController.onPlaybackTimerFired(_:)))
            self.playbackTimer.addToRunLoop(NSRunLoop.currentRunLoop(), forMode:UITrackingRunLoopMode)
            self.playbackTimer.addToRunLoop(NSRunLoop.currentRunLoop(), forMode:NSRunLoopCommonModes)
            self.playbackTimer.frameInterval = 60
    }
    
    private func invalidatePlaybackTimer() {
        if (self.playbackTimer != nil) {
            self.playbackTimer.invalidate()
            self.playbackTimer = nil
        }
    }
    
    func onPlaybackTimerFired(timer : NSTimer) {
        let currentTime = Float(self.playSession.mediaPlayer.currentPlaybackTime)
        self.timeSlider.value = currentTime
        self.updateTimeLabelsWithCurrentTime(Double(currentTime))
    }
    
    @IBAction func onTimeChanged(sender: UISlider) {
        let currentTime = Double(sender.value)
        self.playSession.mediaPlayer.currentPlaybackTime = currentTime
        self.updateTimeLabelsWithCurrentTime(currentTime)
    }
    
    private func updateTimeLabelsWithCurrentTime(currentTime:Double) {
        self.currentTimeLabel.text = String.formatedDuration(currentTime)
        
        if let duration = mediaItem.valueForProperty(MPMediaItemPropertyPlaybackDuration) as? Double {
            self.remainingTimeLabel.text = String.formatedDuration(duration - currentTime)
        }
    }
    
    @IBAction func onShuffle(sender: UIButton) {
        if (self.playSession.mediaPlayer.shuffleMode == .Off) {
            self.playSession.mediaPlayer.shuffleMode = .Songs
            sender.selected = true
        } else if (self.playSession.mediaPlayer.shuffleMode == .Songs) {
            self.playSession.mediaPlayer.shuffleMode = .Off
            sender.selected = false
        }
    }
    
    @IBAction func onRepeat(sender: UIButton) {
        if (self.playSession.mediaPlayer.repeatMode == .None) {
            self.playSession.mediaPlayer.repeatMode = .All
            sender.selected = true
        } else if (self.playSession.mediaPlayer.repeatMode == .All) {
            self.playSession.mediaPlayer.repeatMode = .None
            sender.selected = false
        }
    }
    
    @IBAction func onPreviousTrack(sender: UIButton) {
        self.playSession.mediaPlayer.skipToPreviousItem()
    }
    
    @IBAction func onPlayPause(sender: UIButton) {
        if (self.playSession.mediaPlayer.playbackState != .Playing) {
            self.playSession.mediaPlayer.play()
            let image = UIImage.init(named: "trackPauseIcon")
            self.playPauseButton.setImage(image, forState:.Normal)
            self.startPlaybackTimer()
        } else if (self.playSession.mediaPlayer.playbackState == .Playing) {
            self.playSession.mediaPlayer.pause()
            let image = UIImage.init(named: "trackPlayIcon")
            self.playPauseButton.setImage(image, forState:.Normal)
            self.invalidatePlaybackTimer()
        }
    }
    
    @IBAction func onNextTrack(sender: AnyObject) {
        self.playSession.mediaPlayer.skipToNextItem()
    }
    
}
