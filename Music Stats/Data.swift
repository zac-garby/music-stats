//
//  Data.swift
//  Music Stats
//
//  Created by Zac Garby on 29/03/2018.
//  Copyright © 2018 Zac Garby. All rights reserved.
//

import Foundation
import MediaPlayer

let maximumCategories = 8

struct OverviewData {
    var topGenre: String
    var topArtist: String
    var topSong: String
    var totalPlays: Int
    var totalTime: TimeInterval
    var numTracks: Int
    var avgDiscSize: Float
    var avgDuration: TimeInterval
    var avgPlays: Float
    var avgSkips: Float
    var explicitRatio: Float
}

func fetchOverview() -> OverviewData? {
    guard let songs = MPMediaQuery.songs().items else {
        return nil
    }
    
    guard let albums = MPMediaQuery.albums().collections else {
        return nil
    }
    
    guard let genres = MPMediaQuery.genres().collections else {
        return nil
    }
    
    guard let artists = MPMediaQuery.artists().collections else {
        return nil
    }
    
    var topGenre: (String, Int) = ("None", -1)
    var topArtist = ("None", -1)
    var topSong = ("None", -1)
    var totalPlays: Int = 0
    var totalTime: TimeInterval = 0
    var totalDiscSize: Int = 0
    var totalDurations: TimeInterval = 0
    var totalExplicit: Int = 0
    var totalSkips: Int = 0
    
    for song in songs {
        guard let title = song.title else {
            return nil
        }
        
        guard let artist = song.artist else {
            return nil
        }
        
        if song.playCount > topSong.1 {
            topSong = ("\(title) — \(artist)", song.playCount)
        }
        
        if song.isExplicitItem {
            totalExplicit += 1
        }
        
        totalTime += Double(song.playCount) * song.playbackDuration
        totalDurations += song.playbackDuration
        totalPlays += song.playCount
        totalSkips += song.skipCount
    }
    
    for album in albums {
        totalDiscSize += album.items[0].albumTrackCount
    }
    
    for genre in genres {
        if genre.count > topGenre.1 {
            guard let genreName = genre.items[0].genre else {
                return nil
            }
            
            topGenre = (genreName, genre.count)
        }
    }
    
    for artist in artists {
        if artist.count > topArtist.1 {
            guard let artistName = artist.items[0].artist else {
                return nil
            }
            
            topArtist = (artistName, artist.count)
        }
    }
    
    return OverviewData(
        topGenre: topGenre.0,
        topArtist: topArtist.0,
        topSong: topSong.0,
        totalPlays: totalPlays,
        totalTime: totalTime,
        numTracks: songs.count,
        avgDiscSize: Float(totalDiscSize) / Float(albums.count),
        avgDuration: totalDurations / Double(songs.count),
        avgPlays: Float(totalPlays) / Float(songs.count),
        avgSkips: Float(totalSkips) / Float(songs.count),
        explicitRatio: Float(totalExplicit) / Float(songs.count)
    )
}

func getArtistData() -> [(String, Double)]? {
    guard let songs = MPMediaQuery.songs().items else {
        return nil
    }
    
    var data: [String:Int] = [:]
    
    for song in songs {
        guard let artist = song.artist else {
            return nil
        }
        
        if data.keys.contains(artist) {
            data[artist] = data[artist]! + 1
        } else {
            data[artist] = 1
        }
    }
    
    return process(data: data)
}

func process(data dict: [String:Int]) -> [(String, Double)] {
    let total = dict.reduce(0.0) { (result, pair) in
        return result + Double(pair.value)
    }
    
    var data = dict
        .map({ (key, value) in (key, Double(value)) })
        .filter({ (_, value) in value / total > 0.02 })
        .sorted(by: { a, b in a.1 > b.1 })
    
    let newTotal = data.reduce(0.0) { (result, pair) in
        return result + Double(pair.1)
    }
    
    if newTotal != total {
        data.append(("Other\0", total - newTotal))
    }
    
    return data
}
