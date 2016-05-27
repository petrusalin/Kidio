//
//  RequestSigning.swift
//  Pods
//
//  Created by Alin Petrus on 5/24/16.
//
//

import Foundation

protocol RequestSigning {
    func concatenateToString(destinationString: String, withKey key: String) -> String
}

internal enum Signable : RequestSigning {
    case Str(Swift.String)
    case Int(Swift.Int)
    case Array([AnyObject])
    case Null
    
    init(data: AnyObject) {
        switch data {
        case let v as [AnyObject]:
            self = .Array(v)
        case let v as Swift.String:
            self = .Str(v)
        case let v as Swift.Int:
            self = .Int(v)
        default:
            self = .Null
        }
    }
    
    func concatenateToString(destinationString: String, withKey key: String) -> String {
        switch self {
        case .Int (let value):
            return value.concatenateToString(destinationString, withKey: key)
        case .Str (let string):
            return string.concatenateToString(destinationString, withKey: key)
        case .Array (let array):
            return array.concatenateToString(destinationString, withKey: key)
            
        case .Null:
            return destinationString
        }
    }
}

extension String : RequestSigning {
    func concatenateToString(destinationString: String, withKey key: String) -> String {
        var string = destinationString
        string += key
        
        if (LastfmKeys.keyRequiresUrlEncoding(key)) {
            string += self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        } else {
            string += self
        }
        
        return string
    }
    
}

extension Int : RequestSigning {
    func concatenateToString(destinationString: String, withKey key: String) -> String {
        var string = destinationString
        string += key
        string += String(self)
        
        return string
    }
}

extension Array : RequestSigning {
    func concatenateToString(destinationString: String, withKey key: String) -> String {
        var string = destinationString
        var dict = [String : RequestSigning]()
        
        for (index, val) in self.enumerate() {
            if let value = val as? RequestSigning {
                let adjustedKey = "\(key)[\(index)]"
                dict[adjustedKey] = value
            }
        }
        
        let parameters = dict.keys
        let sortedParameters = parameters.sort () {$0 < $1}
        
        for key in sortedParameters {
            let value = dict[key]
            
            string = value!.concatenateToString(string, withKey: key)
        }
        
        return string
    }
}