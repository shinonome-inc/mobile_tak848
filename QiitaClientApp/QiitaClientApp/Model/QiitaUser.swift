//
//  QiitaUser.swift
//  QiitaClientApp
//
//  Created by 高橋拓也 on 2022/02/22.
//

import Foundation
struct QiitaUser: Codable {
    var id: String
    var profileImageUrl: URL
    public enum CodingKeys: String, CodingKey {
        case id
        case profileImageUrl = "profile_image_url"
    }
}
