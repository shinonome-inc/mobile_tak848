//
//  TagArticlesGetRequest.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/18.
//

import Alamofire
import Foundation

struct TagArticlesGetRequest: QiitaAPIRequest {
    public typealias Response = [QiitaArticle]
    var path: String { "/tags/\(tagId)/items" }
    let method = HTTPMethod.get

    var tagId: String
    let page: Int
    var perPage: Int
    
    var parameters: Parameters {
        [
            "per_page": String(perPage),
            "page": String(page)
        ]
    }
}
