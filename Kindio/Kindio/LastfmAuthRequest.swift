//
//  LastfmAuthRequest.swift
//  Kindio
//
//  Created by Alin Petrus on 5/10/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit


class LastfmAuthRequest: LastfmRequest {
    var username : String!
    var password : String!
    
    override internal var baseURL : String  {
        return "https://ws.audioscrobbler.com/2.0/"
    }
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
        
        super.init()
        
        self.lastfmMethod = LastfmMethod.authMethodWithKey(self.key)
        self.lastfmMethod!.parameters[LastfmKeys.Password.rawValue] = password;
        self.lastfmMethod!.parameters[LastfmKeys.Username.rawValue] = username
        
        self.prepareForExecute()
    }
    
    override func executeWithCompletionBlock(completion: (response: AnyObject?, error: NSError?) -> Void) {
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
