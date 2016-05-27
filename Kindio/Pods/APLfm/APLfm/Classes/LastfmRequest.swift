//
//  LastfmRequest.swift
//  Kindio
//
//  Created by Alin Petrus on 5/10/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit
import AFNetworking
import CryptoSwift

/*!
 *  Structure used to hold the data used by Lastfm to identify a client
 */

public struct LastfmCredential {
    var appKey : String!
    var secret : String!
    
    public init(key : String, secret : String) {
        self.appKey = key
        self.secret = secret
    }
}

/*!
 *  Base class that defines the data and processing required by any lastfm request
 *  It should not be used directly as it does not handle things like signing requests that require it
 *  All requests use the JSON format
 */

public class LastfmRequest: NSObject {
    internal var credential : LastfmCredential!
    internal var sessionToken : String!
    internal var lastfmMethod: LastfmMethod?
    internal var baseURL : String  {
        return "http://ws.audioscrobbler.com/2.0/"
    }
    
    internal init(credential: LastfmCredential) {
        self.credential = credential
    }
    
    public func executeWithCompletionBlock(completion: (response: AnyObject?, error: NSError?) -> Void) {
        let manager = AFHTTPSessionManager()
        
        manager.POST(self.baseURL,
                     parameters: self.lastfmMethod!.parameters,
                     progress: { (progress) in },
                     success: { (dataTask, dictionary) in
                        completion(response: dictionary, error: nil)
        }) { (dataTask, error) in
            completion(response: nil, error: error)
        }
    }
    
    internal func prepareForExecute() {
        if self.lastfmMethod != nil {
            self.lastfmMethod!.parameters[LastfmKeys.Signature.rawValue] = self.signature(self.lastfmMethod!.parameters)
            self.lastfmMethod!.parameters[LastfmKeys.Format.rawValue] = "json"
        }
    }
    
    internal func signature(dictionary: [String : AnyObject]) -> String {
        let parameters = dictionary.keys
        let sortedParameters = parameters.sort () {$0 < $1}
        var concatenatedString = ""
        
        for key in sortedParameters {
            if let value =  dictionary[key] {
                let signable = Signable(data: value)
                concatenatedString = signable.concatenateToString(concatenatedString, withKey: key)
            } else {
                print(dictionary[key])
            }
        }
        
        concatenatedString += self.credential.secret.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        return concatenatedString.md5()
    }
    
    internal func updateParameters(parameters: [String : AnyObject]) {
        var dict = parameters
        
        for (key, value) in parameters {
            if let array = value as? [AnyObject] {
                dict.removeValueForKey(key)
                
                for (index, val) in array.enumerate() {
                    let adjustedKey = "\(key)[\(index)]"
                    dict[adjustedKey] = val
                }
            }
        }
        
        self.lastfmMethod!.parameters.update(dict)
    }
}

