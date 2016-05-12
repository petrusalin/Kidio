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
    
    init(trackName: String, artistName: String) {
        self.trackName = trackName
        self.artistName = artistName
    }
}
