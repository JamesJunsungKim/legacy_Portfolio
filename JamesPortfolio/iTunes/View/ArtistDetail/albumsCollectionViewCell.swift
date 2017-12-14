//
//  SeeAllAlbumsCell.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/2/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit

class albumsCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var albumArtworkView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var trackNumberAndReleaseLabel: UILabel!
    
    func configure(with album: Album){
        let viewModel = AlbumCellViewModel(album: album)
//        let artworkURL = URL(string:album.artworkURL)
//        let albumImage = artworkURL?.fetchSingleImage()
        albumArtworkView.image = viewModel.artwork
        albumTitleLabel.text = viewModel.title
        trackNumberAndReleaseLabel.text = "\(viewModel.numberOfTrack) SONGS - \(viewModel.releaseDate)"
    }
}
