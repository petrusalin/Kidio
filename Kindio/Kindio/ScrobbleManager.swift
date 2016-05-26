//
//  ScrobbleManager.swift
//  Kindio
//
//  Created by Alin Petrus on 5/24/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit
import CoreData
import MediaPlayer
import APLfm

class ScrobbleManager: NSObject {
    private var coreDataManager: CoreDataManager
    
    init(coreDataManager : CoreDataManager) {
        self.coreDataManager = coreDataManager
        
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ScrobbleManager.onBecomeActive(_:)), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    func scrobble(mediaItem: MPMediaItem, timestamp: NSInteger) {
        if let artist = mediaItem.artist, title = mediaItem.title {
            LastfmManager.sharedInstance.scrobble(title, artist: artist, timestamp: timestamp, completion: { (error) in
                if (error != nil) {
                    if (error!.code == NSURLErrorNotConnectedToInternet) {
                        self.saveScrobble(mediaItem, timestamp: timestamp)
                    }
                    
                    print(error)
                }
            })
        }
    }
    
    func onBecomeActive(notification: NSNotification) {
        self.retryPendingScrobbles()
    }
    
    func retryPendingScrobbles() {
        if let scrobbles = self.coreDataManager.scrobbles() {
            if (scrobbles.count == 0) {
                return
            }
            
            var artists = [String]()
            var tracks = [String]()
            var  timestamps = [Int]()
            
            for scrobble in scrobbles {
                if let track = scrobble.title, artist = scrobble.artist, timestamp = scrobble.timestamp {
                    artists.append(artist)
                    tracks.append(track)
                    timestamps.append(timestamp.integerValue)
                } else {
                    return
                }
            }
            
            var dict = [String : AnyObject]()
            dict.update([LastfmKeys.Track.rawValue : tracks, LastfmKeys.Artist.rawValue : artists, LastfmKeys.Timestamp.rawValue : timestamps])

            LastfmManager.sharedInstance.executeRequestWithMethod(LastfmMethods.Track.Scrobble, parameters: dict, completion: { (response, error) in
                if (error == nil) {
                    self.deleteScrobbles(scrobbles)
                } else {
                    print("NONONO")
                }
            })
        }
    }
    
    private func saveScrobble(mediaItem: MPMediaItem, timestamp: Int) {
        self.coreDataManager.saveScrobble(mediaItem, timestamp: timestamp)
    }
    
    private func deleteScrobble(scrobble: Scrobble, save: Bool) {
        self.coreDataManager.managedObjectContext.delete(scrobble)
        
        if (save) {
            self.coreDataManager.saveContext()
        }
    }
    
    private func deleteScrobbles(scrobbles: [Scrobble]) {
        if let scrobbles = self.coreDataManager.scrobbles() {
            for scrobble in scrobbles {
                self.deleteScrobble(scrobble, save: false)
            }
        }
        
        self.coreDataManager.saveContext()
    }
}
