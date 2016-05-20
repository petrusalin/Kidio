//
//  CurrentlyPlayingViewController.swift
//  Kindio
//
//  Created by Alin Petrus on 5/4/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit
import MediaPlayer
import APLfm
import EZAudio

class CurrentlyPlayingViewController: UIViewController, EZAudioPlayerDelegate, EZOutputDelegate {
    
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
    @IBOutlet var plotView: EZAudioPlotGL!
    
    private var isPlottingAudio = false
    var playSession : PlaySession!
    
    var mediaItem : MPMediaItem! {
        didSet {
            self.mediaItemScrobbled = false
            self.mediaItemStartTimestamp = Int(NSDate.init().timeIntervalSince1970)
        }
    }
    
    var collection : MPMediaItemCollection!
    private var volumeView : MPVolumeView!
    private var startPlaying = false
    private var mediaItemScrobbled = false
    private var mediaItemStartTimestamp = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bottomControlsView.backgroundColor = UIColor.blackColor()
        self.topControlsView.backgroundColor = UIColor.blackColor()
        self.view.backgroundColor = UIColor.blueCharcoal()
        
        self.volumeView = MPVolumeView.init(frame: CGRectMake(0, 0, self.volumeContainerView.frame.size.width, self.volumeContainerView.frame.size.height))
        self.volumeView.autoresizingMask = .FlexibleWidth
        
        self.volumeContainerView.addSubview(self.volumeView)
        
        self.plotView.backgroundColor = UIColor.blueCharcoal()
        self.plotView.color = UIColor.redLust()
        self.plotView.plotType = .Buffer
        self.plotView.shouldFill = true
        self.plotView.shouldMirror = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.plotView.clear()
        self.plotView.resumeDrawing()
        self.isPlottingAudio = true
        
        self.playSession.mediaPlayer.output.delegate = self
        
        self.updateUIForNewTrack()
        
        if (self.startPlaying == true) {
            self.startPlaying = false
            if (self.playSession.mediaPlayer.state != .Playing) {
                self.onPlayPause(self.playPauseButton)
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.plotView.clear()
        self.plotView.pauseDrawing()
        self.isPlottingAudio = false
    }
    
    private func updateUIForNewTrack() {
        if let duration = self.mediaItem.valueForProperty(MPMediaItemPropertyPlaybackDuration) {
            self.timeSlider.maximumValue = duration.floatValue
            self.timeSlider.minimumValue = 0.0
            self.currentTimeLabel.text = self.playSession.mediaPlayer.formattedCurrentTime
            self.remainingTimeLabel.text = self.playSession.mediaPlayer.formattedDuration
            self.shuffleButton.selected = self.playSession.shuffle
            self.repeatButton.selected = self.playSession.loop
        }
        
        self.navigationItem.title = self.mediaItem.title
    }
    
    func startWithPlaySession(playSession: PlaySession, mediaItem: MPMediaItem, collection: MPMediaItemCollection) {
        self.playSession = playSession
        self.mediaItem = mediaItem
        self.collection = collection
        
        self.playSession.prepareToPlay(mediaItem, collection: collection)
        self.playSession.mediaPlayer.delegate = self
        self.startPlaying = true
        
        if let title = mediaItem.title , artist = mediaItem.artist {
            LastfmManager.sharedInstance.updateNowPlaying(title, artist: artist, completion: { (error) in
                
            })
        }
    }
    
    @IBAction func onTimeChanged(sender: UISlider) {
        let currentTime = Double(sender.value)
        self.playSession.mediaPlayer.pause()
        self.playSession.mediaPlayer.currentTime = currentTime
        self.updateTimeLabelsWithCurrentTime(currentTime)
        self.playSession.mediaPlayer.play()
    }
    
    private func updateTimeLabelsWithCurrentTime(currentTime:Double) {
        self.currentTimeLabel.text = String.formatedDuration(currentTime)
        
        if let duration = mediaItem.valueForProperty(MPMediaItemPropertyPlaybackDuration) as? Double {
            self.remainingTimeLabel.text = String.formatedDuration(duration - currentTime)
        }
    }
    
    @IBAction func onShuffle(sender: UIButton) {
        self.playSession.shuffle = !self.playSession.shuffle
        self.shuffleButton.selected = self.playSession.shuffle
    }
    
    @IBAction func onRepeat(sender: UIButton) {
        self.playSession.loop = !self.playSession.loop
        self.repeatButton.selected = self.playSession.loop
    }
    
    @IBAction func onPreviousTrack(sender: UIButton) {
        self.playSession.playPreviousTrack()
        self.mediaItem = self.playSession.currentTrack()
        self.updateUIForNewTrack()
    }
    
    @IBAction func onPlayPause(sender: UIButton) {
        if (self.playSession.mediaPlayer.state == .Playing) {
            self.playSession.mediaPlayer.pause()
            let image = UIImage.init(named: "trackPlayIcon")
            self.playPauseButton.setImage(image, forState:.Normal)
        } else {
            self.playSession.mediaPlayer.play()
            let image = UIImage.init(named: "trackPauseIcon")
            self.playPauseButton.setImage(image, forState:.Normal)
        }
    }
    
    @IBAction func onNextTrack(sender: AnyObject) {
        self.playSession.playNextTrack()
        self.mediaItem = self.playSession.currentTrack()
        self.updateUIForNewTrack()
    }
    
    func audioPlayer(audioPlayer: EZAudioPlayer!, updatedPosition framePosition: Int64, inAudioFile audioFile: EZAudioFile!) {
        dispatch_async(dispatch_get_main_queue()) {
            self.timeSlider.value = Float(audioPlayer.currentTime)
            self.currentTimeLabel.text = self.playSession.mediaPlayer.formattedCurrentTime
            self.remainingTimeLabel.text = self.playSession.mediaPlayer.formattedDuration
        }
    }
    
    func audioPlayer(audioPlayer: EZAudioPlayer!, reachedEndOfAudioFile audioFile: EZAudioFile!) {
        self.playSession.playNextTrack()
    }
    
    func output(output: EZOutput!, playedAudio buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        if self.isPlottingAudio {
            dispatch_async(dispatch_get_main_queue()) {
                self.plotView.updateBuffer(buffer[0], withBufferSize: bufferSize)
            }
        }
    }
}
