//
//  TagCollectionCell.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/08.
//

import UIKit

class TagCollectionCell: UICollectionViewCell {
    @IBOutlet weak var tagImage: UIImageView!
    @IBOutlet weak var tagIdLabel: UILabel!
    @IBOutlet weak var tagItemsCountLabel: UILabel!
    @IBOutlet weak var tagFollowersCountLabel: UILabel!
    
    func configure(qiitaTag: QiitaTag) {
        if let iconUrl = qiitaTag.iconUrl {
            tagImage.cacheImage(imageUrl: iconUrl)
        }
        tagIdLabel.text = qiitaTag.id
        tagItemsCountLabel.text = "\("articles count".localized() ?? ""): \(qiitaTag.itemsCount)"
        tagFollowersCountLabel.text = "\("followers count".localized() ?? ""): \(qiitaTag.followersCount)"
    }
}
