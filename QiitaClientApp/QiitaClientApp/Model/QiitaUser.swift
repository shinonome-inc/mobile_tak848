//
//  QiitaUser.swift
//  QiitaClientApp
//
//  Created by 高橋拓也 on 2022/02/22.
//

import Foundation

struct QiitaUser: Codable {
    var id: String
    var name: String?
    var description: String?
    var profileImageUrl: URL
    var itemsCount: Int
    var followeesCount: Int
    var followersCount: Int
    public enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case profileImageUrl = "profile_image_url"
        case itemsCount = "items_count"
        case followeesCount = "followees_count"
        case followersCount = "followers_count"
    }
}

extension QiitaUser {
    var displayName: String {
        if let userName = name, userName != "" {
            return userName
        } else {
            return id
        }
    }

    var displayId: String { "@\(id)" }
}
