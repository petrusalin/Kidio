//
//  LastfmMethod.swift
//  Kindio
//
//  Created by Alin Petrus on 5/12/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import Foundation

enum LastfmMethodType: String {
    case Authentication = "auth.getMobileSession"
    case NowPlaying = "track.updateNowPlaying"
    case Scrobble = "track.scrobble"
}

enum LastfmKeys: String {
    case Method = "method"
    case Username = "username"
    case Password = "password"
    case Format = "format"
    case APIKey = "api_key"
    case Signature = "api_sig"
    case SessionKey = "sk"
    case Track = "track"
    case Artist = "artist"
    case Album = "album"
    case Timestamp = "timestamp"
    
    static func keyRequiresUrlEncoding(key: String) -> Bool {
        if (key == Artist.rawValue || key == Track.rawValue) {
            return false
        }
        
        return true
    }
}

struct LastfmMethod {
    var type: LastfmMethodType
    var parameters = [String: AnyObject]()
    
    private init () {
        self.type = .NowPlaying
    }
    
    
    init(methodType: LastfmMethodType) {
        self.type = methodType
    }
    
    static func authMethodWithKey(apiKey: String) -> LastfmMethod {
        var method = self.init(methodType: .Authentication)
        
        method.parameters[LastfmKeys.Method.rawValue] = method.type.rawValue
        method.parameters[LastfmKeys.APIKey.rawValue] = apiKey
        
        return method
    }
    
    static func signedMethodWithType(methodType: LastfmMethodType, apiKey: String, sessionKey: String) -> LastfmMethod {
        var method = self.init(methodType: methodType)
        
        method.parameters[LastfmKeys.Method.rawValue] = method.type.rawValue
        method.parameters[LastfmKeys.APIKey.rawValue] = apiKey
        method.parameters[LastfmKeys.SessionKey.rawValue] = sessionKey
        
        return method
    }
}
