//
//  LastfmNowPlayingRequest.swift
//  Kindio
//
//  Created by Alin Petrus on 5/10/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit

/// Helper class used to get a now playing request that is ready to be executed

public class LastfmNowPlayingRequest: LastfmSignedRequest {
    private var trackName: String!
    private var artistName: String!
    private var albumName: String!
    
    public init(credential: LastfmCredential, sessionKey: String, trackName: String, artistName: String) {
        self.trackName = trackName
        self.artistName = artistName
        
        super.init(credential: credential, sessionKey: sessionKey)
        
        self.lastfmMethod = LastfmMethod.signedMethod(LastfmMethods.Track.NowPlaying, apiKey: self.credential.appKey, sessionKey: sessionKey)
        
        self.lastfmMethod!.parameters[LastfmKeys.Track.rawValue] = trackName
        self.lastfmMethod!.parameters[LastfmKeys.Artist.rawValue] = artistName
        
        self.prepareForExecute()
    }
}
