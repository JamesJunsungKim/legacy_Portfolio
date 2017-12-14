//
//  CollectionViewDataSource.swift
//  PracticeOauth
//
//  Created by James Kim on 12/4/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit

class CollectionViewDataSource:NSObject, UICollectionViewDataSource {
    
    private let pages: [Page] = {
        let firstPage = Page(title: "Listen to what you look for", description: "Using iTunes API, I set it up in a way that you can search for music and listen to sample tracks. Avplayer plays next song when the current one is finished.", imageName: "page1")
        let secondPage = Page(title: "Search for near-by restaurants", description: "Using Yelp API, show near-by restaurants depending on your current location.", imageName: "page2")
        let thirdPage = Page(title: "Apply filter to pictures", description: "Using CoreData and CoreImage, you can appy filters of your choice to chosen picture.", imageName: "page3" )
        return [firstPage, secondPage, thirdPage]
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == pages.count {
            let permissionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "permissionCell", for: indexPath) as! PermissionCell
            return permissionCell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pageCell", for: indexPath) as! PageCell
        let page = pages[indexPath.item]
        cell.page = page
        return cell
        
    }
}


