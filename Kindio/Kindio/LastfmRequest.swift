//
//  LastfmRequest.swift
//  Kindio
//
//  Created by Alin Petrus on 5/10/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit

class LastfmRequest: NSObject {
    internal var key  = "5fb7895d398515c93d6cc95056ca81ef"
    internal var secret = "b318576b5b4c266977698d0b42f86adf"
    internal var baseURL : String  {
        return "https://ws.audioscrobbler.com/2.0/"
    }
    
    func executeWithCompletionBlock(completion: (response: AnyObject?, error: NSError?) -> Void) {
        completion(response:nil, error: nil)
    }
    
    
    func sig(dictionary: [String : String]) -> String {
        let parameters = dictionary.keys
        let sortedParameters = parameters.sort () {$0 < $1}
        var concatenatedString = ""
        
        for key in sortedParameters {
            concatenatedString += key.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            if (key == "artist" || key == "track") {
                concatenatedString += dictionary[key]!
            } else {
                concatenatedString += dictionary[key]!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            }
        }
        
        concatenatedString += self.secret.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        return md5(string: concatenatedString)
    }
    
    func md5(string string: String) -> String! {
        var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
}

