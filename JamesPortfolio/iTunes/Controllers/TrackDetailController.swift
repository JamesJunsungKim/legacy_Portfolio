//
//  SongDetailController.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/4/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit
import AVKit

class TrackDetailController: UIViewController {
    
    var track: Track?
    var isPlaying: Bool = false
    var isPlayView: Bool = true
    var player: AVPlayer?
    var trackQueue: [Track]?
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playButtonStackView: UIStackView!
    
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var tableView: UITableView!

    lazy var dataSource : TrackListDataSource = {
        return TrackListDataSource(with: [])
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(with: track!)
        setupPlayer()
        setupTableView()
    }
    
    func setupPlayer() {
        guard let url = URL(string: track!.trackURL) else {return}
        player = AVPlayer(url: url)
        
        let _ = AVPlayerLayer(player: player)
        setupSliderBar()
        player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerdidFinished), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
    }
    
    @objc func playerdidFinished() {
        changePlayButtonImage()
        let nextTrack = trackQueue?.first
        preparePlayer(track: nextTrack!)
        
        dataSource.update(with: trackQueue!, at: 0)
        trackQueue = dataSource.retrieveTrackQueue()
        tableView.reloadData()
    }
    
    func setupSliderBar() {
        // Track player progress
        let interval = CMTime(value: 1, timescale: 2)
        player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
            let seconds = CMTimeGetSeconds(progressTime)
            let secondsString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
            let minutesString = String(format: "%01d", Int(seconds / 60))
            
            self.currentLabel.text = "\(minutesString):\(secondsString)"
            
            if let duration = self.player?.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                
                self.slider.value = Float(seconds/durationSeconds)
            }
        })
        
        // slider seek feature
        
        slider.addTarget(self, action: #selector(skipToTime), for: .valueChanged)
    }
    
    func preparePlayer(track: Track) {
        if isPlaying {
            player?.pause()
        }
        configure(with: track)
        setupSliderBar()
        let avPlayerItem = AVPlayerItem(url: URL(string:track.trackURL)!)
        player?.replaceCurrentItem(with: avPlayerItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerdidFinished), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
    }
    
    
    func setupDurationLabel() {
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let secondsString = String(format: "%02d", Int(totalSeconds.truncatingRemainder(dividingBy: 60)))
            let minutesString = String(format: "%01d", Int(totalSeconds / 60))
            self.durationLabel.text = "\(minutesString):\(secondsString)"
        }
    }
    
    
    @objc func skipToTime() {
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            
            let value = Float64(slider.value) * totalSeconds
            
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            
            player?.seek(to: seekTime)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            if player?.currentItem?.status == .readyToPlay {
                setupDurationLabel()
                player?.play()
                isPlaying = false
                changePlayButtonImage()
            }
        }
    }
    
    @IBAction func playAndPause(_ sender: Any) {
        changePlayButtonImage()
        
    }
    
    func changePlayButtonImage() {
        if isPlaying {
            player?.pause()
            playButton.setImage(UIImage(named:"play"), for: .normal)
        } else {
            player?.play()
            playButton.setImage(UIImage(named:"pause"), for: .normal)
        }
        isPlaying = !isPlaying
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func listButtonPressed(_ sender: Any) {
        if isPlayView {
            tableView.isHidden = false
            playView.isHidden = true
        } else {
            tableView.isHidden = true
            playView.isHidden = false
        }
        isPlayView = !isPlayView
    }
    
    
    func configure(with track: Track) {
        guard let artworkUrl = URL(string: track.artworkURL)else {return}
        self.track = track
        albumImageView.image = artworkUrl.fetchSingleImage()
        albumTitleLabel.text = track.albumName
        artistNameLabel.text = track.artistName
        trackNameLabel.text = track.name
    }
    

    func setupTableView() {
        tableView.dataSource = dataSource
        tableView.delegate = self
        trackQueue = dataSource.retrieveTrackQueue()
    }
    
}

// MARK: - Tableview delegate
extension TrackDetailController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        
        let selectedTrack = dataSource.track(at: indexPath)
        preparePlayer(track: selectedTrack)
        
        dataSource.update(with: trackQueue!, at: indexPath.row)
        trackQueue = dataSource.retrieveTrackQueue()
        tableView.reloadData()
        
        tableView.isHidden = true
        playView.isHidden = false
    }
}




