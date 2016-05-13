//
//  LastfmMethod.swift
//  Kindio
//
//  Created by Alin Petrus on 5/12/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import Foundation

enum LastfmMethodType: String {
    case Authentication           = "auth.getMobileSession"

    case NowPlaying               = "track.updateNowPlaying"
    case Scrobble                 = "track.scrobble"

    case AlbumAddTags             = "album.addTags"
    case AlbumGetInfo             = "album.getInfo"
    case AlbumGetTags             = "album.getTags"
    case AlbumGetTopTags          = "album.getTopTags"
    case AlbumRemoveTag           = "album.removeTag"
    case AlbumSearch              = "album.search"

    case ArtistAddTags            = "artist.addTags"
    case ArtistGetCorrection      = "artist.getCorrection"
    case ArtistGetInfo            = "artist.getInfo"
    case ArtistGetSimilar         = "artist.getSimilar"
    case ArtistGetTags            = "artist.getTags"
    case ArtistGetTopAlbums       = "artist.getTopAlbums"
    case ArtistGetTopTags         = "artist.getTopTags"
    case ArtistGetTopTracks       = "artist.getTopTracks"
    case ArtistRemoveTag          = "artist.removeTag"
    case ArtistSearch             = "artist.search"

    case ChartGetTopArtists       = "chart.getTopArtists"
    case ChartGetTopTags          = "chart.getTopTags"
    case ChartGetTopTracks        = "chart.getTopTracks"

    case GeoGetTopArtists         = "geo.getTopArtists"
    case GeoGetTopTracks          = "geo.getTopTracks"

    case LibaryGetArtists         = "library.getArtists"

    case TagGetInfo               = "tag.getInfo"
    case TagGetSimilar            = "tag.getSimilar"
    case TagGetTopAlbums          = "tag.getTopAlbums"
    case TagGetTopArtists         = "tag.getTopArtists"
    case TagGetTopTags            = "tag.getTopTags"
    case TagGetTopTracks          = "tag.getTopTracks"
    case TagGetWeeklyCharList     = "tag.getWeeklyChartList"

    case TrackAddTags             = "track.addTags"
    case TrackGetCorrection       = "track.getCorrection"
    case TrackGetInfo             = "track.getInfo"
    case TrackGetSimilar          = "track.getSimilar"
    case TrackGetTags             = "track.getTags"
    case TrackGetTopTracks        = "track.getTopTags"
    case TrackLove                = "track.love"
    case TrackRemoveTag           = "track.removeTag"
    case TrackSearch              = "track.search"
    case TrackUnlove              = "track.unlove"

    case UserGetArtistTracks      = "user.getArtistTracks"
    case UserGetFriends           = "user.getFriends"
    case UserGetInfo              = "user.getInfo"
    case UserGetLovedTracks       = "user.getLovedTracks"
    case UserGetPersonalTracks    = "user.getPersonalTags"
    case UserGetRecentTracks      = "user.getRecentTracks"
    case UserGetTopAlbums         = "user.getTopAlbums"
    case UserGetTopArtists        = "user.getTopArtists"
    case UserGetTopTags           = "user.getTopTags"
    case UserGetTopTracks         = "user.getTopTracks"
    case UserGetWeeklyAlbumChart  = "user.getWeeklyAlbumChart"
    case UserGetWeeklyArtistChart = "user.getWeeklyArtistChart"
    case UserGetWeeklyChartList   = "user.getWeeklyChartList"
    case UserGetWeeklyTrackChart  = "user.getWeeklyTrackChart"
    
    func requiresSigning() -> Bool {
        switch self {
        case .Authentication, .NowPlaying, .Scrobble, .AlbumAddTags, .AlbumRemoveTag, .ArtistAddTags, .ArtistRemoveTag, .TrackAddTags, .TrackRemoveTag, .TrackLove, .TrackUnlove:
            return true
        default:
            return false
        }
    }
}

enum LastfmKeys: String {
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
    
    static func unsignedMethodWithType(methodType: LastfmMethodType, apiKey: String) -> LastfmMethod {
        var method = self.init(methodType: methodType)
        
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
