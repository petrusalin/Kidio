//
//  LastfmUnsignedRequest.swift
//  Kindio
//
//  Created by Alin Petrus on 5/13/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit

class LastfmUnsignedRequest: LastfmRequest {
    class func unsignedRequestWithMethodType(methodType: LastfmMethodType, parameters: [String : AnyObject], credentials: LastfmCredential) -> LastfmUnsignedRequest {
        let request = LastfmUnsignedRequest.init(credential: credentials)
        
        request.lastfmMethod = LastfmMethod.unsignedMethodWithType(methodType, apiKey: request.credential.appKey)
        request.lastfmMethod!.parameters.update(parameters)
        request.prepareForExecute()
        
        return request
    }
    
    internal override func prepareForExecute() {
        self.lastfmMethod!.parameters[LastfmKeys.Format.rawValue] = "json"
    }
}
