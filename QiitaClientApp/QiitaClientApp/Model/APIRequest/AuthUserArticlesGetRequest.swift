//
//  AuthUserArticlesGetRequest.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/18.
//

import Alamofire
import Foundation

struct AuthUserArticlesGetRequest: QiitaAPIRequest {
    public typealias Response = [QiitaArticle]
    var path: String { "/authenticated_user/items" }
    let method = HTTPMethod.get

    let page: Int
    var perPage: Int

    var parameters: Parameters {
        [
            "per_page": String(perPage),
            "page": String(page)
        ]
    }
}
