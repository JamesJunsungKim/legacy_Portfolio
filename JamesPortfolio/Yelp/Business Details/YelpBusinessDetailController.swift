//
//  YelpBusinessDetailController.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/9/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit
import Cosmos

class YelpBusinessDetailController : UITableViewController {
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var currentHoursStatusLabel: UILabel! {
        didSet {
            if currentHoursStatusLabel.text == "Open" {
                currentHoursStatusLabel.textColor = UIColor(red: 2/255.0, green: 192/255.0, blue: 97/255.0, alpha: 1.0)
            } else {
                currentHoursStatusLabel.textColor = UIColor(red: 209/255.0, green: 47/255.0, blue: 27/255.0, alpha: 1.0)
            }
        }
    }
    
    var business: YelpBusiness?
    
    lazy var dataSource: YelpReviewsDataSource = {
        return YelpReviewsDataSource(data: [])
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        if let business = business, let viewModel = YelpBusinessDetailViewModel(business: business) {
        configure(with: viewModel)
        }
        
    }
    
    func configure(with viewModel: YelpBusinessDetailViewModel) {
        ratingView.rating = viewModel.rating
        restaurantNameLabel.text = viewModel.restaurantName
        priceLabel.text = viewModel.price
        categoriesLabel.text = viewModel.categories
        hoursLabel.text = viewModel.hours
        currentHoursStatusLabel.text = viewModel.currentStatus
    }
    
    
    func setupTableView() {
        tableView.dataSource = dataSource
        tableView.delegate = self

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    
    }


    
}

