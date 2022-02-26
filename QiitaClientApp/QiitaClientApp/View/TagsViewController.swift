//
//  TagsViewController.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/07.
//

import Alamofire
import UIKit
struct TagsGetRequest: QiitaAPIRequest {
    public typealias Response = [QiitaArticle]
    var path: String { "/tags" }
    var perPage: Int { 20 }
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

class TagsViewController: UIViewController {
    var tags: [QiitaTag]?
    override func viewDidLoad() {
        print("hello")
    }
}
