//
//  LastfmUnsignedRequest.swift
//  Kindio
//
//  Created by Alin Petrus on 5/13/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit

/// Class that provides a conveninence method to get an unsigned request
public class LastfmUnsignedRequest: LastfmRequest {
    
    /*!
     Class method that returns an unsigned request. It handles encoding and some other configuration operations
     
     - parameter method:       The Lastfm resource
     - parameter parameters:   Any required parameters except key, secret, format and resource
     - parameter credentials:  The client credentials
     
     - returns: A ready to be executed LastfmRequest
     */
    public class func unsignedRequestWithMethodType(method: Method, parameters: [String : AnyObject], credentials: LastfmCredential) -> LastfmUnsignedRequest {
        let request = LastfmUnsignedRequest.init(credential: credentials)
        
        request.lastfmMethod = LastfmMethod.unsignedMethod(method, apiKey: request.credential.appKey)
        request.updateParameters(parameters)
        request.prepareForExecute()
        
        return request
    }
    
    internal override func prepareForExecute() {
        self.lastfmMethod!.parameters[LastfmKeys.Format.rawValue] = "json"
    }
}
