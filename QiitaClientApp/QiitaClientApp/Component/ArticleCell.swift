//
//  ArticleCell.swift
//  QiitaClientApp
//
//  Created by 高橋拓也 on 2022/02/22.
//

import UIKit

class ArticleCell: UITableViewCell {
    @IBOutlet weak var articleUserImage: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleUserIdLabel: UILabel!
    
    var articles: [QiitaArticle]?
    
    func configure(article: QiitaArticle) {
        articleTitleLabel.text = article.title
        articleUserIdLabel.text = "@\(article.user.id) \("created at".localized() ?? ""): \(article.createdAt.dateString) LGTM: \(article.likesCount)"
        articleUserImage.cacheImage(imageUrl: article.user.profileImageUrl)
    }
}
