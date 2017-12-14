//
//  SearchResultsTableViewController.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/2/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit

class SearchResultsTableViewController : UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    let dataSource = SearchResultsTableViewDataSource()
    let client = ItunesAPIClient()
    let isNotFirstlaunch = "isNotLaunchedForFirstTime"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIflaunchedForFirstTime()
        
        navigationItem.title = "iTunes"
        tableView.dataSource = dataSource
        tableView.tableHeaderView = searchController.searchBar
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        
        definesPresentationContext = true
    }
    func checkIflaunchedForFirstTime() {
        if UserDefaults.standard.bool(forKey: isNotFirstlaunch) {
            present(LaunchController(), animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: isNotFirstlaunch)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showArtist" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let artist = dataSource.artist(at: indexPath)
                let artistDetailController = segue.destination as? ArtistDetailController
                
                client.lookupArtist(with: artist.id, completion: { (artist, error) in
                    artistDetailController?.artist = artist
                })
            }
        }
    }
    
    
    
}

extension SearchResultsTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
            client.searchForArtists(withTerm: searchController.searchBar.text!) { (artists, error) in
                self.dataSource.update(with: artists)
                self.tableView.reloadData()
            }
    }
}


