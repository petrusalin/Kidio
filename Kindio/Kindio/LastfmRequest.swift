//
//  LastfmRequest.swift
//  Kindio
//
//  Created by Alin Petrus on 5/10/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit

internal class LastfmRequest: NSObject {
    internal var key  = "5fb7895d398515c93d6cc95056ca81ef"
    internal var secret = "b318576b5b4c266977698d0b42f86adf"
    internal var lastfmMethod: LastfmMethod?
    internal var baseURL : String  {
        return "http://ws.audioscrobbler.com/2.0/"
    }
    
    func executeWithCompletionBlock(completion: (response: AnyObject?, error: NSError?) -> Void) {
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
            if let value = dictionary[key] as? String {
                concatenatedString += key.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                
                if (LastfmKeys.keyRequiresUrlEncoding(key)) {
                    concatenatedString += value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                } else {
                    concatenatedString += value
                }
            }
        }
        
        concatenatedString += self.secret.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        return String.md5(string: concatenatedString)
    }
}

