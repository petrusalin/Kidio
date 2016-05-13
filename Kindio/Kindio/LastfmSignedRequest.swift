//
//  LastfmSignedRequest.swift
//  Kindio
//
//  Created by Alin Petrus on 5/12/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit

class LastfmSignedRequest: LastfmRequest {
    
    init(credential: LastfmCredential, sessionKey: String) {
        super.init(credential: credential)
        
        self.sessionToken = sessionKey
    }

    class func signedRequestWithMethodType(methodType: LastfmMethodType, parameters: [String : AnyObject], sessionToken: String, credentials: LastfmCredential) -> LastfmSignedRequest {
        let request = LastfmSignedRequest.init(credential: credentials, sessionKey: sessionToken)
        
        request.lastfmMethod = LastfmMethod.signedMethodWithType(methodType, apiKey: request.credential.appKey, sessionKey: sessionToken)
        request.lastfmMethod!.parameters.update(parameters)
        request.prepareForExecute()
        
        return request
    }
}
