//
//  QiitaArticleCell.swift
//  kadai08
//
//  Created by 高橋拓也 on 2022/02/05.
//

import UIKit

class QiitaArticleCell: UITableViewCell {
    
    static let identifier = "QiitaArticleCell"
    
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleUserIdLabel: UILabel!
    
    func configure(article: QiitaArticle) {
        articleTitleLabel.text = article.title
        articleUserIdLabel.text = article.user.id
    }
    
}
