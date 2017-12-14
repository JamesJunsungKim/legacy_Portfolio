//
//  ArtistDetailController.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/2/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit

class ArtistDetailController : UITableViewController  {
    
    let client = ItunesAPIClient()
    
    var artist : Artist? {
        didSet {
            self.title = artist?.name
            dataSource.update(with: artist!.albums)
            tableView.reloadData()
        }
    }
    
    lazy var dataSource: ArtistDetailDataSource = {
       return ArtistDetailDataSource(albums: [], tableView: self.tableView)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
    }
    
    

    // MARK: - Navigation
    
    struct reuseIdenrtifier {
        static let showDetailAlbum = "showDetailAlbum"
        static let showAllAlbums = "showAllAlbums"
        static let showDetailLatestAlbum = "showDetailLatestAlbum"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == reuseIdenrtifier.showDetailLatestAlbum {
            let latestAlbum = dataSource.latestAlbum()
            let albumDetailController = segue.destination as! AlbumDetailController
            
            client.lookupAlbum(with: latestAlbum.id, completion: { (album, error) in
                albumDetailController.album = album
            })
            
        } else if segue.identifier == reuseIdenrtifier.showAllAlbums {
            let albumListController = segue.destination as! AlbumListController
            client.lookupArtist(with: artist!.id, completion: { (artist, error) in
                albumListController.artist = artist
            })
        } else if segue.identifier == reuseIdenrtifier.showDetailAlbum {
            let albumDetailController = segue.destination as! AlbumDetailController
            if let cell = sender as? albumsCollectionViewCell {
                let indexPath = cell.tag
                let selectedAlbum = dataSource.album(at: indexPath)
                
                client.lookupAlbum(with: selectedAlbum.id, completion: { (album, error) in
                    albumDetailController.album = album
                })
            }
        }
    }
}
