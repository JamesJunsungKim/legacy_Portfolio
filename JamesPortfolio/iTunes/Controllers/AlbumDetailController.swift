//
//  AlbumDetailController.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/2/17.
//  Copyright © 2017 James Kim. All rights reserved.
//


import UIKit
import AVKit

class AlbumDetailController: UITableViewController {
    
    var album: Album? {
        didSet {
            if let album = album {
                configure(with: album)
                datasource.update(with: album)
                tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var artworkView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var albumGenreLabel: UILabel!
    @IBOutlet weak var albumReleaseDateLabel: UILabel!
    
    
    var datasource = AlbumDetailDataSource(tracks: [])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = datasource
        tableView.delegate = self
    }
    
    
    func configure(with album: Album) {
        let viewModel = AlbumCellViewModel(album: album)
        
        guard let url = URL(string: album.artworkURL) else {return}
        let albumImage = url.fetchSingleImage()
        artworkView.image = albumImage
        
        albumTitleLabel.text = viewModel.title
        albumGenreLabel.text = viewModel.genre
        albumReleaseDateLabel.text = viewModel.releaseDate
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTrackDetail" {
            let trackDetailController = segue.destination as! TrackDetailController
            if let button = sender as? UIButton {
                let indexPath = button.tag
                let selectedTrack = datasource.track(at: indexPath)

                trackDetailController.track = selectedTrack
                trackDetailController.dataSource.update(with: datasource.albumTrack(), at: indexPath)
            }
        }
    }
    
}

