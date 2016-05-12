//
//  LastfmManager.swift
//  Kindio
//
//  Created by Alin Petrus on 5/10/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit

private let sharedManager = LastfmManager()


class LastfmManager: NSObject {
    private let tokenKey = "lastfmTokenKey"
    private var lastFmCredential = LastfmCredential.init(key: "5fb7895d398515c93d6cc95056ca81ef", secret: "b318576b5b4c266977698d0b42f86adf")
    
    private override init() {
        super.init()
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.HTTPMethodsEncodingParametersInURI.insert("POST")
        manager.requestSerializer.stringEncoding = NSUTF8StringEncoding
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = ["application/json"]
        
        manager.securityPolicy.allowInvalidCertificates = true
        manager.securityPolicy.validatesDomainName = false
    }
    
    class var sharedInstance: LastfmManager {
        return sharedManager
    }
    
    func saveLastfmToken(token: String) {
        NSUserDefaults.standardUserDefaults().setObject(token, forKey: self.tokenKey)
    }
    
    func lastfmToken() -> String? {
        if let token =  NSUserDefaults.standardUserDefaults().objectForKey(self.tokenKey) as? String {
            return token
        }
        
        return nil
    }
    
    func isLoggedIn() -> Bool {
        return self.lastfmToken() != nil
    }
    
    func logout() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(self.tokenKey)
    }
    
    func loginWithUsername(username: String, password: String, completion: (error: NSError?) -> Void) {
        let authRequest = LastfmAuthRequest.init(credential: self.lastFmCredential, username: username, password: password)
        
        authRequest.executeWithCompletionBlock { (response, error) in
            if let dict = response as? [String: AnyObject] {
                if let key = dict["key"] as? String {
                    self.saveLastfmToken(key)
                } else {
                    print("Could not get token")
                }
            } else {
                print(error)
            }
            
            completion(error: error)
        }
    }
    
    func updateNowPlaying(track: String, artist: String, completion: (error: NSError?) -> Void) {
        if sharedManager.isLoggedIn() == false {
            return
        }
        
        let nowPlayingRequest = LastfmNowPlayingRequest.init(credential: self.lastFmCredential, sessionKey: self.lastfmToken()!, trackName: track, artistName: artist)
        
        nowPlayingRequest.executeWithCompletionBlock { (response, error) in
            completion(error: error)
        }
    }
    
    func scrobble(track: String, artist: String, timestamp: Int, completion: (error: NSError?) -> Void) {
        if sharedManager.isLoggedIn() == false {
            return
        }
        
        let scrobbleRequest = LastfmScrobbleRequest.init(credential: self.lastFmCredential, sessionKey: self.lastfmToken()!, trackName: track, artistName: artist, timestamp: timestamp)
        
        scrobbleRequest.executeWithCompletionBlock { (response, error) in
            completion(error: error)
        }
    }
}
