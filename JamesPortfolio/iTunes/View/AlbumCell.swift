//
//  AlbumCell.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/2/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit

class AlbumCell : UITableViewCell {
    
    @IBOutlet weak var albumArtworkView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var albumGenreLabel: UILabel!
    @IBOutlet weak var albumReleaseLabel: UILabel!
    
    func configure(with viewModel: AlbumCellViewModel) {
        albumArtworkView.image = viewModel.artwork
        albumTitleLabel.text = viewModel.title
        albumGenreLabel.text = viewModel.genre
        albumReleaseLabel.text = viewModel.releaseDate
    }
    
}
