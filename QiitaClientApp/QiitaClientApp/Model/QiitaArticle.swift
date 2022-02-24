//
//  QiitaArticle.swift
//  QiitaClientApp
//
//  Created by 高橋拓也 on 2022/02/22.
//

import Foundation

struct QiitaArticle: Codable {
    var title: String
    var url: URL
    var user: QiitaUser
    var createdAt: Date
    var likesCount: Int
    public enum CodingKeys: String, CodingKey {
        case title
        case url
        case user
        case createdAt = "created_at"
        case likesCount = "likes_count"
    }
}
