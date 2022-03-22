//
//  UserArticlesGetRequest.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/19.
//

import Alamofire
import Foundation

struct UserArticlesGetRequest: QiitaAPIRequest {
    public typealias Response = [QiitaArticle]
    var path: String { "/users/\(user.id)/items" }
    let method = HTTPMethod.get

    var user: QiitaUser
    let page: Int
    var perPage: Int

    var parameters: Parameters {
        [
            "per_page": String(perPage),
            "page": String(page)
        ]
    }
}
