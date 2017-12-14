//
//  ArtworkDownloader.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/3/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit

class ArtworkDownloader: Operation {
    
    let album: Album
    init(album: Album) {
        self.album = album
        super.init()
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        guard let url = URL(string: album.artworkURL) else {return}
        
        let imageData = try! Data(contentsOf: url)
        
        if self.isCancelled {
            return
        }
        
        if imageData.count > 0 {
            album.artwork = UIImage(data: imageData)
            album.artworkState = .downloaded
        } else {
            album.artworkState = .failed
        }
        
    }
}

