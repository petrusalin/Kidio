//
//  LastfmNowPlayingRequest.swift
//  Kindio
//
//  Created by Alin Petrus on 5/10/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit

class LastfmNowPlayingRequest: LastfmSignedRequest {
    private var trackName: String!
    private var artistName: String!
    private var albumName: String!
    
    init(credential: LastfmCredential, sessionKey: String, trackName: String, artistName: String) {
        self.trackName = trackName
        self.artistName = artistName
        
        super.init(credential: credential, sessionKey: sessionKey)
        
        self.lastfmMethod = LastfmMethod.signedMethodWithType(LastfmMethodType.NowPlaying, apiKey: self.credential.appKey, sessionKey: sessionKey)
        
        self.lastfmMethod!.parameters[LastfmKeys.Track.rawValue] = trackName
        self.lastfmMethod!.parameters[LastfmKeys.Artist.rawValue] = artistName
        
        self.prepareForExecute()
    }
}
