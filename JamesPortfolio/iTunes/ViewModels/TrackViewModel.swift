//
//  TrackViewModel.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/3/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit

struct TrackViewModel {
    let title: String
    let runtime: String
    let trackURL: URL
    let artworkUrl: String
    let artistName : String
    
}

extension TrackViewModel {
    init(track: Track) {
        self.title = track.censoredName
        
        let timeInSeconds = track.trackTime/1000
        let minutes = timeInSeconds/60 % 60
        let seconds = timeInSeconds % 60
        
        self.runtime = "\(minutes): \(seconds)"
        self.trackURL = URL(string: track.trackURL)!
        self.artworkUrl = track.artworkURL
        self.artistName = track.artistName
        
        
    }
}

