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
    private let keychain = KeychainWrapper()
    private let usernameKey = "lastfmUsernameKey"
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
    
    internal func saveLastfmToken(token: String) {
        self.keychain.mySetObject(token, forKey: kSecValueData)
        self.keychain.writeToKeychain()
    }
    
    internal func lastfmToken() -> String? {
        if let token = self.keychain.myObjectForKey(kSecValueData) as? String {
            return token
        }
        
        return nil
    }
    
    func isLoggedIn() -> Bool {
        return self.loggedInUsername() != nil
    }
    
    func loggedInUsername() -> String? {
        if let username = NSUserDefaults.standardUserDefaults().objectForKey(self.usernameKey) as? String {
            return username
        }
        
        return nil
    }
    
    internal func saveLastfmUsername(username: String) {
        NSUserDefaults.standardUserDefaults().setObject(username, forKey: self.usernameKey)
    }
    
    func logout() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(self.usernameKey)
    }
    
    // Mark : requests
    
    func loginWithUsername(username: String, password: String, completion: (error: NSError?) -> Void) {
        let authRequest = LastfmAuthRequest.init(credential: self.lastFmCredential, username: username, password: password)
        
        authRequest.executeWithCompletionBlock { (response, error) in
            if let dict = response as? [String: AnyObject] {
                if let key = dict["key"] as? String {
                    self.saveLastfmToken(key)
                    self.saveLastfmUsername(username)
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
    
    func executeRequestWithMethod(method: LastfmMethodType, parameters: [String : AnyObject], completion: (response: AnyObject?, error: NSError?) -> Void) {
        if method == .Authentication {
            assert(false, "Use the dedicated method for auth")
        }
        
        if (method.requiresSigning()) {
            if sharedManager.isLoggedIn() == false {
                completion(response: nil, error: nil)
                return
            }
            
            let request = LastfmSignedRequest.signedRequestWithMethodType(method, parameters: parameters, sessionToken: self.lastfmToken()!, credentials: self.lastFmCredential)
            
            request.executeWithCompletionBlock({ (response, error) in
                completion(response: response, error: error)
            })
        } else {
            let request = LastfmUnsignedRequest.unsignedRequestWithMethodType(method, parameters: parameters, credentials: self.lastFmCredential)
            
            request.executeWithCompletionBlock({ (response, error) in
                completion(response: response, error: error)
            })
        }
    }
    
}
