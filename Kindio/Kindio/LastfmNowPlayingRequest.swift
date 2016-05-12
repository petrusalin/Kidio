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
    override internal var baseURL : String  {
        return "http://ws.audioscrobbler.com/2.0/"
    }
    
    init(trackName: String, artistName: String) {
        self.trackName = trackName
        self.artistName = artistName
    }
    
    override func executeWithCompletionBlock(completion: (response: AnyObject?, error: NSError?) -> Void) {
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.HTTPMethodsEncodingParametersInURI.insert("POST")
        manager.requestSerializer.stringEncoding = NSUTF8StringEncoding
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = ["application/json"]
        
        manager.securityPolicy.allowInvalidCertificates = true
        manager.securityPolicy.validatesDomainName = false
        
        if let token = LastfmManager.sharedInstance.lastfmToken(), artist = self.artistName, song = self.trackName {
            var dictionary = ["method" : "track.updateNowPlaying",
                              "api_key" : self.key,
                              "track" : song,
                              "artist" : artist,
                              "sk" : token]
            dictionary["api_sig"] = self.sig(dictionary)
            dictionary["format"] = "json"
            
            manager.POST(self.baseURL,
                         parameters: dictionary,
                         progress: { (progress) in
                            
                },
                         success: { (dataTask, dictionary) in
                            print("sucess")
            }) { (dataTask, error) in
                print("error")
                completion(response: nil, error: error)
            }
        }
    }
}
