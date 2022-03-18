//
//  ArticleCell.swift
//  QiitaClientApp
//
//  Created by 高橋拓也 on 2022/02/22.
//

import UIKit

final class NormalArticleCell: UITableViewCell, ArticleCell {
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleDetailLabel: UILabel!
    @IBOutlet weak var articleUserImage: UIImageView!
    
    func articleDetailText(article: QiitaArticle) -> String {
        "@\(article.user.id) \("created at".localized() ?? ""): \(article.createdAt.dateString) LGTM: \(article.likesCount)"
    }
    
    var articles: [QiitaArticle]?
    
    func originalConfigure(article: QiitaArticle) {
        articleUserImage.cacheImage(imageUrl: article.user.profileImageUrl)
    }
}
