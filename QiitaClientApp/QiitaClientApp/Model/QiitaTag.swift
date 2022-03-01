//
//  QiitaTag.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/07.
//

import Foundation

struct QiitaTag: Codable {
    var id: String
    var iconUrl: URL?
    var itemsCount: Int
    var followersCount: Int
    public enum CodingKeys: String, CodingKey {
        case id
        case iconUrl = "icon_url"
        case itemsCount = "items_count"
        case followersCount = "followers_count"
    }
}
