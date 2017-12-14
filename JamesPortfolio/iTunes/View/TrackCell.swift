//
//  TrackCell.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/2/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit

class TrackCell : UITableViewCell {
    
    var track: Track? {
        didSet {
            guard let track = track else {return}
            let viewModel = TrackViewModel(track: track)
            trackTitleLabel.text = viewModel.title
            trackRuntimeLabel.text = viewModel.runtime
        }
    }
    var indexPath : IndexPath?
    
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var trackRuntimeLabel: UILabel!
    @IBOutlet weak var senderButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}


