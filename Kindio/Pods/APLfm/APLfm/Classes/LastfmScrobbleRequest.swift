//
//  LastfmScrobbleRequest.swift
//  Kindio
//
//  Created by Alin Petrus on 5/10/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit

public class LastfmScrobbleRequest: LastfmSignedRequest {
    private var trackName: String!
    private var artistName: String!
    private var timestamp: Int!
    
    public init(credential: LastfmCredential, sessionKey: String, trackName: String, artistName: String, timestamp: Int) {
        self.trackName = trackName
        self.artistName = artistName
        self.timestamp = timestamp
        
        super.init(credential: credential,  sessionKey: sessionKey)
        
        self.lastfmMethod = LastfmMethod.signedMethodWithType(LastfmMethodType.Scrobble, apiKey: self.credential.appKey, sessionKey: sessionKey)
        self.lastfmMethod!.parameters[LastfmKeys.Track.rawValue] = trackName
        self.lastfmMethod!.parameters[LastfmKeys.Artist.rawValue] = artistName
        self.lastfmMethod!.parameters[LastfmKeys.Timestamp.rawValue] = timestamp
        
        self.prepareForExecute()
    }
    
}
