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
    var followeesCount: Int
    var followersCount: Int
    public enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case profileImageUrl = "profile_image_url"
        case followeesCount = "followees_count"
        case followersCount = "followers_count"
    }
}
