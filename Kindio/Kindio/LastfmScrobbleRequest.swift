//
//  LastfmScrobbleRequest.swift
//  Kindio
//
//  Created by Alin Petrus on 5/10/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit

class LastfmScrobbleRequest: LastfmRequest {
    private var trackName: String!
    private var artistName: String!
    private var timestamp: Int!
    
    init(trackName: String, artistName: String, timestamp: Int) {
        self.trackName = trackName
        self.artistName = artistName
        self.timestamp = timestamp
        
        super.init()
        
        if let token = LastfmManager.sharedInstance.lastfmToken() {
            self.lastfmMethod = LastfmMethod.signedMethodWithType(LastfmMethodType.Scrobble, apiKey: self.key, sessionKey: token)
            self.lastfmMethod!.parameters[LastfmKeys.Track.rawValue] = trackName
            self.lastfmMethod!.parameters[LastfmKeys.Artist.rawValue] = artistName
            self.lastfmMethod!.parameters[LastfmKeys.Timestamp.rawValue] = timestamp
            
            self.prepareForExecute()
        }
    }
    
}
