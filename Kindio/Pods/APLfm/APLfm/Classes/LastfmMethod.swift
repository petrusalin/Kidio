//
//  LastfmMethod.swift
//  Kindio
//
//  Created by Alin Petrus on 5/12/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import Foundation

public protocol Method {
    func requiresSigning() -> Bool
    
    func path() -> String
}


public enum LastfmMethods {
    public enum Auth : String, Method {
        case GetSession           = "auth.getMobileSession"
        
        public func requiresSigning() -> Bool {
            return true
        }
        
        public func path() -> String {
            return self.rawValue
        }
        
    }

    public enum Album : String, Method {
        case AddTags              = "album.addTags"
        case GetInfo              = "album.getInfo"
        case GetTags              = "album.getTags"
        case GetTopTags           = "album.getTopTags"
        case RemoveTag            = "album.removeTag"
        case Search               = "album.search"
        
        public func requiresSigning() -> Bool {
            switch self {
            case .AddTags, .RemoveTag:
                return true
            default:
                return false
            }
        }
        
        public func path() -> String {
            return self.rawValue
        }
    }

    public enum Artist : String, Method {
        case AddTags              = "artist.addTags"
        case GetCorrection        = "artist.getCorrection"
        case GetInfo              = "artist.getInfo"
        case GetSimilar           = "artist.getSimilar"
        case GetTags              = "artist.getTags"
        case GetTopAlbums         = "artist.getTopAlbums"
        case GetTopTags           = "artist.getTopTags"
        case GetTopTracks         = "artist.getTopTracks"
        case RemoveTag            = "artist.removeTag"
        case Search               = "artist.search"
        
        public func requiresSigning() -> Bool {
            switch self {
            case .AddTags, .RemoveTag:
                return true
            default:
                return false
            }
        }
        
        public func path() -> String {
            return self.rawValue
        }
    }

    public enum Chart : String, Method {
        case GetTopArtists        = "chart.getTopArtists"
        case GetTopTags           = "chart.getTopTags"
        case GetTopTracks         = "chart.getTopTracks"
        
        public func requiresSigning() -> Bool {
            return false
        }
        
        public func path() -> String {
            return self.rawValue
        }
    }

    public enum Geo : String, Method {
        case GetTopArtists        = "geo.getTopArtists"
        case GetTopTracks         = "geo.getTopTracks"
        
        public func requiresSigning() -> Bool {
            return false
        }
        
        public func path() -> String {
            return self.rawValue
        }
    }

    public enum Library : String, Method {
        case GetArtists           = "library.getArtists"
        
        public func requiresSigning() -> Bool {
            return false
        }
        
        public func path() -> String {
            return self.rawValue
        }
    }

    public enum Tag : String, Method {
        case GetInfo              = "tag.getInfo"
        case GetSimilar           = "tag.getSimilar"
        case GetTopAlbums         = "tag.getTopAlbums"
        case GetTopArtists        = "tag.getTopArtists"
        case GetTopTags           = "tag.getTopTags"
        case GetTopTracks         = "tag.getTopTracks"
        case GetWeeklyCharList    = "tag.getWeeklyChartList"
        
        public func requiresSigning() -> Bool {
            return false
        }
        
        public func path() -> String {
            return self.rawValue
        }
        
    }

    public enum Track : String, Method {
        case NowPlaying           = "track.updateNowPlaying"
        case Scrobble             = "track.scrobble"
        case AddTags              = "track.addTags"
        case GetCorrection        = "track.getCorrection"
        case GetInfo              = "track.getInfo"
        case GetSimilar           = "track.getSimilar"
        case GetTags              = "track.getTags"
        case GetTopTracks         = "track.getTopTags"
        case Love                 = "track.love"
        case RemoveTag            = "track.removeTag"
        case Search               = "track.search"
        case Unlove               = "track.unlove"
        
        public func requiresSigning() -> Bool {
            switch self {
            case .NowPlaying, .Scrobble, .AddTags, .RemoveTag, .Love, .Unlove:
                return true
            default:
                return false
            }
        }
        
        public func path() -> String {
            return self.rawValue
        }
    }

    public enum User : String, Method {
        case GetArtistTracks      = "user.getArtistTracks"
        case GetFriends           = "user.getFriends"
        case GetInfo              = "user.getInfo"
        case GetLovedTracks       = "user.getLovedTracks"
        case GetPersonalTracks    = "user.getPersonalTags"
        case GetRecentTracks      = "user.getRecentTracks"
        case GetTopAlbums         = "user.getTopAlbums"
        case GetTopArtists        = "user.getTopArtists"
        case GetTopTags           = "user.getTopTags"
        case GetTopTracks         = "user.getTopTracks"
        case GetWeeklyAlbumChart  = "user.getWeeklyAlbumChart"
        case GetWeeklyArtistChart = "user.getWeeklyArtistChart"
        case GetWeeklyChartList   = "user.getWeeklyChartList"
        case GetWeeklyTrackChart  = "user.getWeeklyTrackChart"
        
        public func requiresSigning() -> Bool {
            return false
        }
        
        public func path() -> String {
            return self.rawValue
        }
    }
}

public enum LastfmKeys: String {
    case Method         = "method"
    case Username       = "username"
    case Password       = "password"
    case Format         = "format"
    case APIKey         = "api_key"
    case Signature      = "api_sig"
    case SessionKey     = "sk"
    case Track          = "track"
    case Artist         = "artist"
    case Album          = "album"
    case AlbumArtist    = "albumArtist"
    case Duration       = "duration"
    case TrackNumber    = "trackNumber"
    case Tags           = "tags"
    case Tag            = "tag"
    case TaggingType    = "taggingtype"
    case User           = "user"
    case StreamId       = "streamId"
    case ChosenByUser   = "chosenByUser"
    case MusicBrainsId  = "mbid"
    case Context        = "context"
    case Language       = "lang"
    case Autocorrect    = "autocorrect"
    case Timestamp      = "timestamp"
    case StartTimestamp = "startTimestamp"
    case EndTimeStamp   = "endTimestamp"
    case RecentTracks   = "recenttracks"
    case Limit          = "limit"
    case Page           = "page"
    case Country        = "country"
    case Location       = "location"
    case From           = "from"
    case Extended       = "extended"
    case To             = "to"
    case Period         = "period"
    
    static func keyRequiresUrlEncoding(key: String) -> Bool {
        if (key.rangeOfString(Artist.rawValue) != nil || key.rangeOfString(Track.rawValue) != nil) {
            return false
        }
        
        return true
    }
}

/*!
 *  Structure used to define the requirememts needed to be able to make a lastfm request
 *  It provides 3 convenience methods for the probably most used methods
 */
public struct LastfmMethod : Method {
    var method: Method
    internal var parameters = [String: AnyObject]()
    
    private init () {
        self.method = LastfmMethods.Track.Scrobble
    }
    
    public func path() -> String {
        return self.method.path()
    }
    
    public func requiresSigning() -> Bool {
        return self.method.requiresSigning()
    }
    
    public init(method: Method) {
        self.method = method
    }
    
    static func authMethod(apiKey: String) -> LastfmMethod {
        var lastFmMethod = self.init(method: LastfmMethods.Auth.GetSession)
        
        lastFmMethod.parameters[LastfmKeys.Method.rawValue] = lastFmMethod.path()
            
        lastFmMethod.parameters[LastfmKeys.APIKey.rawValue] = apiKey
        
        return lastFmMethod
    }
    
    static func unsignedMethod(method: Method, apiKey: String) -> LastfmMethod {
        var lastFmMethod = self.init(method: method)
        
        lastFmMethod.parameters[LastfmKeys.Method.rawValue] = lastFmMethod.path()
        lastFmMethod.parameters[LastfmKeys.APIKey.rawValue] = apiKey
        
        return lastFmMethod
    }
    
    static func signedMethod(method: Method, apiKey: String, sessionKey: String) -> LastfmMethod {
        var lastFmMethod = self.init(method: method)
        
        lastFmMethod.parameters[LastfmKeys.Method.rawValue] = lastFmMethod.path()
        lastFmMethod.parameters[LastfmKeys.APIKey.rawValue] = apiKey
        lastFmMethod.parameters[LastfmKeys.SessionKey.rawValue] = sessionKey
        
        return lastFmMethod
    }
    
}
