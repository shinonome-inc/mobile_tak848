//
//  BaseArticleCell.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/15.
//

import UIKit

protocol ArticleCell {
    var articleTitleLabel: UILabel! { get set }
    var articleDetailLabel: UILabel! { get set }
    
    var articles: [QiitaArticle]? { get set }
    func articleDetailText(article: QiitaArticle) -> String
    func configure(article: QiitaArticle)
    func originalConfigure(article: QiitaArticle)
}

extension ArticleCell {
    func configure(article: QiitaArticle) {
        articleTitleLabel.text = article.title
        articleDetailLabel.text = articleDetailText(article: article)
        originalConfigure(article: article)
    }
    func originalConfigure(article: QiitaArticle) {}
}
