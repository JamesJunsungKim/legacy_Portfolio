//
//  YelpSearchDataSource.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/6/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit

class YelpSearchDataSource: NSObject, UITableViewDataSource {
    
    private var data = [YelpBusiness]()
    
    override init() {
        super.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Restaurants"
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessCell", for: indexPath)
        let business = object(at: indexPath)
        cell.textLabel?.text = business.name
        return cell
    }
    // MARK: - Helpers
    func object(at indexPath: IndexPath) -> YelpBusiness {
        return data[indexPath.row]
    }
    
    func update(with data:[YelpBusiness]) {
        self.data = data
    }
    func update(_ object: YelpBusiness, at indexPath: IndexPath){
        data[indexPath.row] = object
    }
    
}


