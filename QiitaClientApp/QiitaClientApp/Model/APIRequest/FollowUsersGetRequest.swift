//
//  FollowUsersGetRequest.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/18.
//

import Alamofire
import Foundation
struct FollowUsersGetRequest: QiitaAPIRequest {
    public typealias Response = [QiitaUser]
    var path: String { "/users/\(targetUser.id)/\(followModePath)" }
    let method = HTTPMethod.get

    let page: Int
    var perPage: Int
    var targetUser: QiitaUser
    var followMode: FollowMode
    
    private var followModePath: String {
        switch followMode {
        case .following: return "followees"
        case .followers: return "followers"
        }
    }

    var parameters: Parameters {
        [
            "per_page": String(perPage),
            "page": String(page)
        ]
    }
}
