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

class CurrentlyPlayingViewController: UIViewController, EZAudioPlayerDelegate {
    
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateUIForNewTrack()
        if (self.startPlaying == true) {
            self.startPlaying = false
            self.onPlayPause(self.playPauseButton)
        }
    }
    
    private func updateUIForNewTrack() {
        if let duration = mediaItem.valueForProperty(MPMediaItemPropertyPlaybackDuration) {
            self.timeSlider.maximumValue = duration.floatValue
            self.timeSlider.minimumValue = 0.0
            self.currentTimeLabel.text = self.playSession.mediaPlayer.formattedCurrentTime
            self.remainingTimeLabel.text = self.playSession.mediaPlayer.formattedDuration
        }
        
        self.navigationItem.title = self.mediaItem.title
    }
    
    func startWithPlaySession(playSession: PlaySession, mediaItem: MPMediaItem, collection: MPMediaItemCollection) {
        self.playSession = playSession
        self.mediaItem = mediaItem
        self.collection = collection
        
        self.playSession.mediaPlayer.audioFile = EZAudioFile.init(URL: self.mediaItem.assetURL)
        self.playSession.mediaPlayer.delegate = self
        self.startPlaying = true
        
        if let title = mediaItem.title , artist = mediaItem.artist {
            LastfmManager.sharedInstance.updateNowPlaying(title, artist: artist, completion: { (error) in
                
            })
        }
    }
    
    @IBAction func onTimeChanged(sender: UISlider) {
        let currentTime = Double(sender.value)
        self.playSession.mediaPlayer.currentTime = currentTime
        self.updateTimeLabelsWithCurrentTime(currentTime)
    }
    
    private func updateTimeLabelsWithCurrentTime(currentTime:Double) {
        self.currentTimeLabel.text = String.formatedDuration(currentTime)
        
        if let duration = mediaItem.valueForProperty(MPMediaItemPropertyPlaybackDuration) as? Double {
            self.remainingTimeLabel.text = String.formatedDuration(duration - currentTime)
        }
    }
    
    @IBAction func onShuffle(sender: UIButton) {
        
    }
    
    @IBAction func onRepeat(sender: UIButton) {

    }
    
    @IBAction func onPreviousTrack(sender: UIButton) {
        
    }
    
    @IBAction func onPlayPause(sender: UIButton) {
        if (self.playSession.mediaPlayer.state != .Playing) {
            self.playSession.mediaPlayer.play()
            let image = UIImage.init(named: "trackPauseIcon")
            self.playPauseButton.setImage(image, forState:.Normal)
        } else if (self.playSession.mediaPlayer.state == .Playing) {
            self.playSession.mediaPlayer.pause()
            let image = UIImage.init(named: "trackPlayIcon")
            self.playPauseButton.setImage(image, forState:.Normal)
        }
    }
    
    @IBAction func onNextTrack(sender: AnyObject) {
        
    }
    
    func audioPlayer(audioPlayer: EZAudioPlayer!, updatedPosition framePosition: Int64, inAudioFile audioFile: EZAudioFile!) {
        dispatch_async(dispatch_get_main_queue()) { 
            self.timeSlider.value = Float(audioPlayer.currentTime)
            self.currentTimeLabel.text = self.playSession.mediaPlayer.formattedCurrentTime
            self.remainingTimeLabel.text = self.playSession.mediaPlayer.formattedDuration
        }
    }
    
}
