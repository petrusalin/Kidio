//
//  LastfmAuthRequest.swift
//  Kindio
//
//  Created by Alin Petrus on 5/10/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit

/// Convenience class used to obtain an auth request. Use this one instead of using the signed/unsigned classes for an auth request
public class LastfmAuthRequest: LastfmRequest {
    internal var username : String!
    internal var password : String!
    
    override internal var baseURL : String  {
        return "https://ws.audioscrobbler.com/2.0/"
    }
    
    /*!
     Designated initializer for the class
     
     - parameter credential: An instance of LastfmCredential
     - parameter username:   Lastfm user handle
     - parameter password:   Lastfm user password
     
     - returns: A request of the class ready to be executed
     */
    public init(credential: LastfmCredential, username: String, password: String) {
        self.username = username
        self.password = password
        
        super.init(credential: credential)
        
        self.lastfmMethod = LastfmMethod.authMethod(self.credential.appKey)
        self.lastfmMethod!.parameters[LastfmKeys.Password.rawValue] = password;
        self.lastfmMethod!.parameters[LastfmKeys.Username.rawValue] = username
        
        self.prepareForExecute()
    }
    
    override public func executeWithCompletionBlock(completion: (response: AnyObject?, error: NSError?) -> Void) {
        super.executeWithCompletionBlock { (response, error) in
            if (error != nil) {
                completion(response: nil, error: error)
            } else {
                if let dict = response as? [String : AnyObject] {
                    if let sessionDict = dict["session"] as? [String : AnyObject] {
                        completion(response: sessionDict, error: nil)
                    } else {
                        completion(response: nil, error: nil)
                    }
                } else {
                    completion(response: nil, error: nil)
                }
            }
        }
    }
    
}
