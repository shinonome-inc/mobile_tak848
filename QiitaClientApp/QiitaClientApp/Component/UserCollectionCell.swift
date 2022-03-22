//
//  UserCollectionCell.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/18.
//

import UIKit

class UserCollectionCell: UICollectionViewCell {
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var userArticlesCountLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    @IBOutlet weak var descriptionBottomSpaceConstraint: NSLayoutConstraint!
    
    func configure(userData user: QiitaUser) {
        userIdLabel.text = user.displayId
        userNameLabel.text = user.displayName
        userArticlesCountLabel.text = "Posts: \(user.itemsCount)"
        if let description = user.description, description != "" {
            userDescriptionLabel.text = description
            descriptionBottomSpaceConstraint.constant = 8
        } else {
            userDescriptionLabel.text = nil
            descriptionBottomSpaceConstraint.constant = 0
        }
        userProfileImage.cacheImage(imageUrl: user.profileImageUrl)
    }
}
