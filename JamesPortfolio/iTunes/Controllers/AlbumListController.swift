//
//  AlbumListController.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/2/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit

class AlbumListController: UITableViewController {
    
    let client = ItunesAPIClient()
    
    lazy var dataSource : AlbumListDataSource = {
        return AlbumListDataSource(albums: [], tableView: tableView)
    }()
    
    private struct Constants {
        static let AlbumCellHeight : CGFloat = 80
    }
    
    var artist : Artist? {
        didSet {
            guard let artist = artist else {return}
//            self.title = artist.name
            dataSource.update(with: artist.albums)
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
    }
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.AlbumCellHeight
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSelectedAlbum" {
            let albumDetailController = segue.destination as! AlbumDetailController
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let selectedAlbum = dataSource.album(at: indexPath)
            
            client.lookupAlbum(with: selectedAlbum.id, completion: { (album, error) in
                albumDetailController.album = album
            })
            
        }
    }
}
