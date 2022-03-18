//
//  TagsGetRequest.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/18.
//

import Alamofire
import Foundation

struct TagsGetRequest: QiitaAPIRequest {
    public typealias Response = [QiitaTag]
    var path: String { "/tags" }
    var perPage: Int { 100 }
    var sort: String { "count" }
    let method = HTTPMethod.get

    let page: Int

    var parameters: Parameters {
        [
            "per_page": String(perPage),
            "page": String(page),
            "sort": sort
        ]
    }
}
