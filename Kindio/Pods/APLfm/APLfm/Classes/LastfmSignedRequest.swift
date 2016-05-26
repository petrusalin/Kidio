//
//  LastfmSignedRequest.swift
//  Kindio
//
//  Created by Alin Petrus on 5/12/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit

/// Class that provides a conveninence method to get a signed request
public class LastfmSignedRequest: LastfmRequest {
    
    internal init(credential: LastfmCredential, sessionKey: String) {
        super.init(credential: credential)
        
        self.sessionToken = sessionKey
    }

    /*!
     Class method that returns a signed request. It handles encoding, signing the request and some other configuration operations
     
     - parameter method:       The Lastfm resource
     - parameter parameters:   Any required parameters except token, key, secret, format and resource
     - parameter sessionToken: Session token obtained after auth
     - parameter credentials:  The client credentials
     
     - returns: A ready to be executed LastfmRequest
     */
    public class func signedRequestWithMethodType(method: Method, parameters: [String : AnyObject], sessionToken: String, credentials: LastfmCredential) -> LastfmSignedRequest {
        assert(method.requiresSigning() == true, "Method does not required signing and will fail. Use the unsignedRequest")
        
        let request = LastfmSignedRequest.init(credential: credentials, sessionKey: sessionToken)
        
        request.lastfmMethod = LastfmMethod.signedMethod(method, apiKey: request.credential.appKey, sessionKey: sessionToken)
        request.lastfmMethod!.parameters.update(parameters)
        request.prepareForExecute()
        
        return request
    }
}
