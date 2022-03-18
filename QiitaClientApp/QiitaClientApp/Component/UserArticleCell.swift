//
//  UserArticleCell.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/15.
//

import UIKit

final class UserArticleCell: UITableViewCell, ArticleCell {
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleDetailLabel: UILabel!
    
    var articles: [QiitaArticle]?
    
    func articleDetailText(article: QiitaArticle) -> String {
        "\("created at".localized() ?? ""): \(article.createdAt.dateString) LGTM: \(article.likesCount)"
    }
}
