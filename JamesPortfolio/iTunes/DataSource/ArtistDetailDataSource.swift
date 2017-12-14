//
//  ArtistDetailDataSource.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/2/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit

class ArtistDetailDataSource: NSObject, UITableViewDataSource {
    
    private var albums: [Album]
    private var albumsForTableView: [Album]
    private var albumsForCollectionView: [Album]
    
    let pendingOperation = PendingOperation()
    
    let tableView: UITableView
    var collectionView: UICollectionView?
    
    init(albums: [Album], tableView: UITableView){
        self.albums = albums
        self.tableView = tableView
        self.albumsForCollectionView = [Album]()
        self.albumsForTableView = [Album]()
        
        super.init()
    }
    
    
    // MARK: - TalbeView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumsForTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LatestReleaseCell", for: indexPath) as! LatestReleaseCell
            let album = albumsForTableView[indexPath.row]
            cell.configure(with: album)
            
            if album.artworkState == .placeholder {
                downloadArtworkForAlbumTableView(album, atIndexPath: indexPath)
            }
        
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumsCell", for: indexPath) as! AlbumsCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SeeAllAlbumsCell", for: indexPath)
            return cell
        }
    }
    
    
    
    
    // MARK: - TableView Helper
    
    func update(with albums: [Album]){
        self.albums = albums
        let sortedAlbums = albums.sorted{ $0.releaseDate > $1.releaseDate }
        
        if sortedAlbums.count < 3 {
            albumsForTableView = sortedAlbums
        } else {
            for i in 0...2 {
                albumsForTableView.append(sortedAlbums[i])
            }
        }
        
        if albums.count < 6 {
            albumsForCollectionView = albums
        } else {
            for i in 0...5{
                albumsForCollectionView.append(albums[i])
            }
        }
    }
    
    func latestAlbum() -> Album{
        return albumsForTableView[0]
    }
    
}

// MARK: - UItableView delegate

extension ArtistDetailDataSource: UITableViewDelegate {
    
    private struct Constants {
        static let LatestCellHeight : CGFloat = 120
        static let SeeAllAlbumsHeight: CGFloat = 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return Constants.LatestCellHeight
        } else if indexPath.row == 1 {
            let count = albumsForCollectionView.count
            if count < 3 {
                return 240
            } else if count < 5 {
                return 460
            } else {
                return 720
            }
        } else {
            return Constants.SeeAllAlbumsHeight
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            if let cell = cell as? AlbumsCell {
                cell.collectionView.dataSource = self
                cell.collectionView.delegate = self
                cell.collectionView.reloadData()
                cell.collectionView.isScrollEnabled = false
            }
        }
    }
    
}

// MARK: - UicollectionView Delegate, Datsource

extension ArtistDetailDataSource: UICollectionViewDataSource ,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumsForCollectionView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumsCollectionViewCell", for: indexPath) as! albumsCollectionViewCell
            let album = albumsForCollectionView[indexPath.item]
            
            cell.configure(with: album)
            if let url = URL(string: album.artworkURL) {
                cell.albumArtworkView.image = url.fetchSingleImage()
            }
            cell.tag = indexPath.item
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumsCollectionViewCell", for: indexPath) as! albumsCollectionViewCell
            let album = albumsForCollectionView[indexPath.item]
            
            cell.configure(with: album)
            cell.tag = indexPath.item
            
            if album.artworkState == .placeholder {
                downloadArtworkForAlbumCollectionView(album, collectionView: collectionView, atIndexPath: indexPath)
            }
            
            return cell
        }
    }
    
    // MARK: - CollectionView Helper
    
    func album(at indexPath: Int) -> Album {
        return albumsForCollectionView[indexPath]
    }
    
    func downloadArtworkForAlbumCollectionView(_ album: Album, collectionView: UICollectionView, atIndexPath indexPath: IndexPath) {
        if let _ = pendingOperation.downloadsInProgress[indexPath] {
            return
        }
        
        let downloader = ArtworkDownloader(album: album)
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
                self.pendingOperation.downloadsInProgress.removeValue(forKey: indexPath)
                collectionView.reloadItems(at: [indexPath])
            }
        }
        
        pendingOperation.downloadsInProgress[indexPath] = downloader
        pendingOperation.downloadQueue.addOperation(downloader)
        
    }
    
    func downloadArtworkForAlbumTableView(_ album: Album, atIndexPath indexPath: IndexPath) {
        if let _ = pendingOperation.downloadsInProgress[indexPath] {
            return
        }
        
        let downloader = ArtworkDownloader(album: album)
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
                self.pendingOperation.downloadsInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        pendingOperation.downloadsInProgress[indexPath] = downloader
        pendingOperation.downloadQueue.addOperation(downloader)
        
    }
}






