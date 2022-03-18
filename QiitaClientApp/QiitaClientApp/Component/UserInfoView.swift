//
//  UserInfoView.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/14.
//

import UIKit

class UserInfoView: UITableViewHeaderFooterView {
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    @IBOutlet weak var userFollowingButton: UIButton!
    @IBOutlet weak var userFollowersButton: UIButton!
    
    var articles: [QiitaArticle]?
    var delegate: UserPageViewControllerProtocol?
    
    override func awakeFromNib() {
        resetContent()
    }

    func resetContent() {
        userProfileImage.image = nil
        userNameLabel.text = nil
        userIdLabel.text = nil
        userDescriptionLabel.text = ""
        userFollowingButton.setAttributedTitle(nil, for: .normal)
        userFollowersButton.setAttributedTitle(nil, for: .normal)
    }
    
    func configure(userData user: QiitaUser) {
        userIdLabel.text = "@\(user.id)"
        if let userName = user.name, userName != "" {
            userNameLabel.text = userName
        } else {
            userNameLabel.text = user.id
        }
        userDescriptionLabel.text = user.description
        userFollowingButton.setAttributedTitle(countAndUnitMutableAttributedString(count: user.followeesCount, unit: "following".localized() ?? ""), for: .normal)
        userFollowersButton.setAttributedTitle(countAndUnitMutableAttributedString(count: user.followersCount, unit: "followers".localized() ?? ""), for: .normal)
        userProfileImage.cacheImage(imageUrl: user.profileImageUrl)
    }

    func countAndUnitMutableAttributedString(count: Int, unit: String) -> NSMutableAttributedString {
        let countAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12, weight: .bold),
            .foregroundColor: UIColor.label
        ]
        let attributedCount = NSAttributedString(string: "\(String(count)) ", attributes: countAttributes)

        let unitAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12, weight: .medium),
            .foregroundColor: UIColor(named: "SecondaryGrey") ?? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        ]
        let attributedUnit = NSAttributedString(string: unit, attributes: unitAttributes)

        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedCount)
        mutableAttributedString.append(attributedUnit)
        return mutableAttributedString
    }

    @IBAction func onTapFollowingButton(_ sender: UIButton) {
        delegate?.presentFollowViewController(followMode: .following)
    }

    @IBAction func onTapFollowersButton(_ sender: UIButton) {
        delegate?.presentFollowViewController(followMode: .followers)
    }
}
