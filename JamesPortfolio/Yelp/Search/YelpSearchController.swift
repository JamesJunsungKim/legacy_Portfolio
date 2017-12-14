//
//  YelpSearchController.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/6/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit
import MapKit

class YelpSearchController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    let dataSource = YelpSearchDataSource()
    let queue = OperationQueue()
    
    lazy var locationManager: LocationManager = {
        return LocationManager(delegate: self, permissionDelegate: self)
    }()

    var coordinate: Coordinate? {
        didSet {
            guard let coordinate = coordinate else {return}
            showNearbyRestaurants(at: coordinate)
        }
    }
    var isAuthorized: Bool {
        let isAuthorizedWithYelpToken = UserDefaults.standard.bool(forKey: AuthorizationString.withToken)
        let isAuthorizedForLocation = UserDefaults.standard.bool(forKey: AuthorizationString.forLocation)
        return isAuthorizedWithYelpToken && isAuthorizedForLocation
    }
    
    lazy var client: YelpClient = {
        let yelpAccount = YelpAccount.loadFromKeychain()
        let oauthToken = yelpAccount!.accessToken
        
        return YelpClient(oauthToken: oauthToken)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableVIew()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isAuthorized {
            locationManager.requestLocation()
        } else {
            checkLocationPermission()
        }
    }
    
    func checkLocationPermission() {
        let isAuthorizedWithYelpToken_ = YelpAccount.isAuthorized
        let isAuthorizedForLocation_ = LocationManager.isAuthorized
        
        if isAuthorizedForLocation_ {
            UserDefaults.standard.set(true, forKey: AuthorizationString.forLocation)
        } else {
            UserDefaults.standard.set(false, forKey: AuthorizationString.forLocation)
        }
        if isAuthorizedWithYelpToken_ {
            UserDefaults.standard.set(true, forKey: AuthorizationString.withToken)
        } else {
            UserDefaults.standard.set(false, forKey: AuthorizationString.withToken)
        }
        
        if !UserDefaults.standard.bool(forKey: AuthorizationString.forLocation) {
            let alert = UIAlertController(title: "Location denied", message: "The location has to be used to show near-by restaurants. Please go to setting to turn it on to proceed.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showNearbyRestaurants(at coordinate: Coordinate) {
        client.search(withTerm: "", at: coordinate) { [weak self] result in
            switch result {
            case .success(let businesses):
                self?.dataSource.update(with: businesses)
                self?.tableView.reloadData()
                self?.mapView.addAnnotations(businesses)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setupSearchBar() {
        self.navigationItem.titleView = searchController.searchBar
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
    }
    
    func setupTableVIew() {
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self
    }
    
    func adjustMap(with coordinate: Coordinate){
        let coordinate2D = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let span = MKCoordinateRegionMakeWithDistance(coordinate2D, 2500, 2500).span
        
        let region = MKCoordinateRegion(center: coordinate2D, span: span)
        mapView.setRegion(region, animated: true)
    }
}

//MARK: - Search Results

extension YelpSearchController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text, let coordinate = coordinate else {return}
        
        if !searchTerm.isEmpty {
            client.search(withTerm: searchTerm, at: coordinate, completion: { [weak self] result in
                switch result {
                case .success(let businesses):
                    self?.dataSource.update(with: businesses)
                    self?.tableView.reloadData()
                    self?.mapView.removeAnnotations(self!.mapView.annotations)
                    self?.mapView.addAnnotations(businesses)
                    
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
    
}

//MARK: - Location Manager Delegate
extension YelpSearchController : LocationPermissionDelegate, LocationManagerDelegate {
    func authorizationSuceeded() {
        UserDefaults.standard.set(true, forKey: AuthorizationString.forLocation)
    }
    
    func authorizationFailedWithStatus(_ status: CLAuthorizationStatus) {
        UserDefaults.standard.set(false, forKey: AuthorizationString.forLocation)
    }
    
    func obtainedCoordinate(_ coordinate: Coordinate) {
        self.coordinate = coordinate
        adjustMap(with: coordinate)
    }
    
    func failedWithError(_ error: LocationError) {
        print(error)
    }
}
// MARK: - TableView delegate

extension YelpSearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let business = dataSource.object(at: indexPath)
        
        let detailsOperation = YelpBusinessDetailsOperation(business: business, client: self.client)
        let reviewsOperation = YelpBusinessReviewsOperation(business: business, client: self.client)
        
        reviewsOperation.addDependency(detailsOperation)
        
        reviewsOperation.completionBlock = {
            DispatchQueue.main.async {
                self.dataSource.update(business, at: indexPath)
                self.performSegue(withIdentifier: "showBusiness", sender: nil)
            }
        }
        queue.addOperation(detailsOperation)
        queue.addOperation(reviewsOperation)
    }
    
    //MARK: -Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBusiness" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let business = dataSource.object(at: indexPath)
                let detailController = segue.destination as! YelpBusinessDetailController
                detailController.business = business
                detailController.dataSource.updateData(business.reviews)
            }
        }
    }
}
















