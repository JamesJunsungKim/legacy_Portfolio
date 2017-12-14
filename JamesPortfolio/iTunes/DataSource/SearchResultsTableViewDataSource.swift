//
//  SearchResultsTableViewDataSource.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/2/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit

class SearchResultsTableViewDataSource: NSObject, UITableViewDataSource {
    
    private var data = [Artist]()
    
    override init() {
        super.init()
    }
    func update(with artists:[Artist]) {
        self.data = artists
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        let artist = data[indexPath.row]
        cell.textLabel?.text = artist.name
        return cell
    }
    
    // MARK: - Helper
    func artist(at indexPath: IndexPath) -> Artist {
        return data[indexPath.row]
    }
}
