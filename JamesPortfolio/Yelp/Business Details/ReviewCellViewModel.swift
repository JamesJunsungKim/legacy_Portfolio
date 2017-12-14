//
//  ReviewCellViewModel.swift
//  JamesPortfolio
//
//  Created by James Kim on 12/9/17.
//  Copyright © 2017 James Kim. All rights reserved.
//

import UIKit

struct ReviewCellViewModel {
    let review: String
    let userImage: UIImage
}

extension ReviewCellViewModel {
    init(review: YelpReview) {
        self.review = review.text
        self.userImage = review.user.image ?? #imageLiteral(resourceName: "AlbumPlaceholder")
    }
}


