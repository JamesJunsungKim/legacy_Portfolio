//
//  LaunchController.swift
//  PracticeOauth
//
//  Created by James Kim on 12/4/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit
import OAuth2
import CoreLocation

struct AuthorizationString {
    static let isAskedBefore = "isAskedBefore"
    static let forLocation = "isAuthorizedForLocation"
    static let withToken = "isAuthenticationWithToken"
}

class LaunchController : UIViewController, LocationPermissionDelegate {
    
    let defaults = UserDefaults.standard
    let oauth = OAuth2ClientCredentials(settings: [
        "client_id": "EPDV1qT7tZHdbUf70xKsUQ",
        "client_secret": "PT4L21qLHurypV9MwUGcD9Ql3LUJe1YWZgCDbTFjXIQiddy16Mj3mOBZZF5VZRP1",
        "authorize_uri": "https://api.yelp.com/oauth2/token",
        "secret_in_body": true,
        "keychain": false
        ])
    
    lazy var locationManager : LocationManager = {
        return LocationManager(delegate: nil, permissionDelegate: self)
    }()
    
    var isAuthorizedForLocation: Bool {
        return defaults.bool(forKey: AuthorizationString.forLocation)
    }
    var isAuthenticationWithToken: Bool {
        return defaults.bool(forKey: AuthorizationString.withToken)
    }
    
    var locationReqestedBefore = UserDefaults.standard.bool(forKey: AuthorizationString.isAskedBefore)
    
    private var datasource = CollectionViewDataSource()
    
    var pageControlBottomAnchor: NSLayoutConstraint?
    var skipButtonTopAnchor: NSLayoutConstraint?
    var nextButtonTopAnchor: NSLayoutConstraint?
    
    // MARK: - UI
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.dataSource = datasource
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    lazy var pageControl : UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.numberOfPages = 4
        return pageControl
    }()
    
    lazy var skipButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.addTarget(self, action: #selector(skip), for: .touchUpInside)
        return button
    }()
    
    lazy var nextButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        return button
    }()
    
    // MARK : - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(dismissController), name: PermissionCell.startButtonPressedNotifiationName, object: nil)
        
        setupUI()
    }
    
    @objc func dismissController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func skip() {
        pageControl.currentPage = 2
        startAuthorizationProcess()
        nextPage()
        
    }
    
    @objc func nextPage() {
        if pageControl.currentPage == 3 {
            return
        }
        if pageControl.currentPage == 2 {
            
            moveControlConstraintsOffScreen()
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        
        let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage += 1
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        
        pageControl.currentPage = pageNumber
        
        if pageNumber == 3 {
            moveControlConstraintsOffScreen()
            startAuthorizationProcess()
            print("\(LocationManager.isAuthorized)")
        } else {
            pageControlBottomAnchor?.constant = 0
            skipButtonTopAnchor?.constant = 20
            nextButtonTopAnchor?.constant = 20
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func moveControlConstraintsOffScreen() {
        pageControlBottomAnchor?.constant = 80
        skipButtonTopAnchor?.constant = -80
        nextButtonTopAnchor?.constant = -80
    }
    
    func setupUI() {
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: "pageCell")
        collectionView.register(PermissionCell.self, forCellWithReuseIdentifier: "permissionCell")
        
        view.addSubview(collectionView)
        view.addSubview(skipButton)
        view.addSubview(nextButton)
        view.addSubview(pageControl)
        
        _ = collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, topConstant: 10, rightConstant: 0, bottomConstant: 0, leftConstant: 0, widthConstant: 0, heightConstant: 0)
        skipButtonTopAnchor = skipButton.anchor(top: view.topAnchor, right: nil, bottom: nil, left: view.leftAnchor, topConstant: 20, rightConstant: 0, bottomConstant: 0, leftConstant: 0, widthConstant: 60, heightConstant: 50)[0]
        nextButtonTopAnchor = nextButton.anchor(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: nil, topConstant: 20, rightConstant: 0, bottomConstant: 0, leftConstant: 0, widthConstant: 60, heightConstant: 50)[0]
        pageControlBottomAnchor = pageControl.anchor(top: nil, right: view.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.leftAnchor, topConstant: 0, rightConstant: 0, bottomConstant: 0, leftConstant: 0, widthConstant: 0, heightConstant: 40)[1]
    }
    
    func requestLocationPermission() {
        do {
            try locationManager.requestLocationAuthorization()
        } catch LocationError.disallowedByUser {
            let alert = UIAlertController(title: "Location request denied", message: "The request did not go through. Please go to setting to turn it on to experience all features.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        } catch let error {
            print("location authroziation error: \(error.localizedDescription)")
        }
    }
    
    func startAuthorizationProcess() {
        if !locationReqestedBefore {
            requestLocationPermission()
            requestOAuthToekn()
            defaults.set(true, forKey: AuthorizationString.isAskedBefore)
        } else {
            
        }
        
    }
    
    func requestOAuthToekn() {
        oauth.authorize { authParams, error in
            if let params = authParams {
                guard let token = params["access_token"] as? String, let expiration = params["expires_in"] as? TimeInterval else {return}
                
                let account = YelpAccount(accessToken: token, expiration: expiration, grantDate: Date())
                
                do {
                    try? account.save()
                    self.defaults.set(true, forKey: AuthorizationString.withToken)
                    
                }
            } else {
                print("Authorization was cancelled or went wrong: \(error!)")
            }
        }
    }
    
    func authorizationSuceeded() {
        self.defaults.set(true, forKey: AuthorizationString.forLocation)
    }
    
    func authorizationFailedWithStatus(_ status: CLAuthorizationStatus) {
        
    }
    

}

//MARK: - Collectionview Delegate

extension LaunchController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
}


