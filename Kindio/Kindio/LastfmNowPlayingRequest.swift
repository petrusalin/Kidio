//
//  LastfmNowPlayingRequest.swift
//  Kindio
//
//  Created by Alin Petrus on 5/10/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit

class LastfmNowPlayingRequest: LastfmRequest {
    private var trackName: String!
    private var artistName: String!
    private var albumName: String!
    
    init(trackName: String, artistName: String) {
        self.trackName = trackName
        self.artistName = artistName
        
        super.init()
        
        if let token = LastfmManager.sharedInstance.lastfmToken() {
            self.lastfmMethod = LastfmMethod.signedMethodWithType(LastfmMethodType.NowPlaying, apiKey: self.key, sessionKey: token)
            
            self.lastfmMethod!.parameters[LastfmKeys.Track.rawValue] = trackName
            self.lastfmMethod!.parameters[LastfmKeys.Artist.rawValue] = artistName

            self.prepareForExecute()
        }
    }
}
