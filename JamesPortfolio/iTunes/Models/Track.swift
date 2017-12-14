//
//  Song.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/2/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit

class Track {
    let id: Int
    let name: String
    let censoredName : String
    let trackTime: Int
    let trackNumber : Int
    let albumPrice: Double
    let trackPrice: Double
    let releaseDate: String
    let trackURL: String
    let artworkURL: String
    let artistName: String
    let albumName: String
    var albumArtwork: UIImage?
    var isDownloaded: Bool = false
    
    init(id: Int, name: String, censoredName: String, trackTime: Int, trackNumber: Int, albumPrice: Double, trackPrice: Double, releaseDate: String, trackURL: String, artworkURL: String, artistName: String, albumName: String) {
        self.id = id
        self.name = name
        self.censoredName = censoredName
        self.trackTime = trackTime
        self.trackNumber = trackNumber
        self.albumPrice = albumPrice
        self.trackPrice = trackPrice
        self.releaseDate = releaseDate
        self.trackURL = trackURL
        self.artworkURL = artworkURL
        self.artistName = artistName
        self.albumName = albumName
    }
}

extension Track {
    convenience init?(json: [String:Any]){
        struct Key {
            static let id = "trackId"
            static let name = "trackName"
            static let censoredName = "trackCensoredName"
            static let trackTime = "trackTimeMillis"
            static let trackNumber = "trackNumber"
            static let albumPrice = "collectionPrice"
            static let trackPrice = "trackPrice"
            static let releaseDate = "releaseDate"
            static let isExplicit = "trackExplicitness"
            static let trackURL = "previewUrl"
            static let artworkURL = "artworkUrl100"
            static let artistName = "artistName"
            static let albumName = "collectionName"
        }
        
        guard let idValue = json[Key.id] as? Int,
        let nameValue = json[Key.name] as? String,
        let censoredName = json[Key.censoredName] as? String,
        let trackTime = json[Key.trackTime] as? Int,
        let trackNumber = json[Key.trackNumber] as? Int,
        let albumPrice = json[Key.albumPrice] as? Double,
        let trackPrice = json[Key.trackPrice] as? Double,
        let releaseDate = json[Key.releaseDate] as? String,
        let trackURL = json[Key.trackURL] as? String,
        let artworkURL = json[Key.artworkURL] as? String,
        let albumName = json[Key.albumName] as? String,
        let artistName = json[Key.artistName] as? String else { return nil}
        
        self.init(id: idValue, name: nameValue, censoredName: censoredName, trackTime: trackTime, trackNumber: trackNumber, albumPrice: albumPrice, trackPrice: trackPrice, releaseDate: releaseDate, trackURL: trackURL, artworkURL: artworkURL, artistName: artistName, albumName: albumName)
        
    }
}















