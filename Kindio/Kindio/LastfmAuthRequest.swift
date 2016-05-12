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
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    override func executeWithCompletionBlock(completion: (response: AnyObject?, error: NSError?) -> Void) {
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.HTTPMethodsEncodingParametersInURI.insert("POST")
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = ["application/json"]
        
        manager.securityPolicy.allowInvalidCertificates = true
        manager.securityPolicy.validatesDomainName = false
        
        if let user = self.username, pswd = self.password {
            var dictionary = ["method" : "auth.getMobileSession",
                              "password" : pswd,
                              "username" : user,
                              "api_key" : self.key]
            dictionary["api_sig"] = self.sig(dictionary)
            dictionary["format"] = "json"
            
            manager.POST(self.baseURL,
                         parameters: dictionary,
                         progress: { (progress) in
                            
                },
                         success: { (dataTask, dictionary) in
                            print("sucess")
                            if let dict = dictionary as? [String : AnyObject] {
                                if let sessionDict = dict["session"] as? [String : AnyObject] {
                                    completion(response: sessionDict, error: nil)
                                } else {
                                    completion(response: nil, error: nil)
                                }
                            } else {
                                completion(response: nil, error: nil)
                            }
            }) { (dataTask, error) in
                print("error")
                completion(response: nil, error: error)
            }
        }
    }
}
