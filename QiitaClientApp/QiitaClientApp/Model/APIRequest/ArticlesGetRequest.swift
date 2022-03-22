//
//  ArticlesGetRequest.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/18.
//

import Alamofire
import Foundation

struct ArticlesGetRequest: QiitaAPIRequest {
    public typealias Response = [QiitaArticle]
    var path: String { "/items" }
    let method = HTTPMethod.get

    let page: Int
    var perPage: Int
    let query: String?

    var parameters: Parameters {
        var parameters = [
            "per_page": String(perPage),
            "page": String(page)
        ]
        if let query = query {
            parameters.updateValue(query, forKey: "query")
        }
        return parameters
    }
}
