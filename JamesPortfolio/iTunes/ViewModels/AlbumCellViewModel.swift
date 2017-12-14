//
//  AlbumCellViewModel.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/2/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit

struct AlbumCellViewModel {
    let artwork: UIImage
    let title: String
    let releaseDate: String
    let genre: String
    let numberOfTrack: Int
}

extension AlbumCellViewModel {
    init(album: Album) {
        self.artwork = album.artworkState == .downloaded ? album.artwork! : #imageLiteral(resourceName: "AlbumPlaceholder")
        self.title = album.censoredName
        self.genre = album.primaryGenre.name
        self.numberOfTrack = album.numberOfTracks
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy"
        
        self.releaseDate = formatter.string(from: album.releaseDate)
    }
}

