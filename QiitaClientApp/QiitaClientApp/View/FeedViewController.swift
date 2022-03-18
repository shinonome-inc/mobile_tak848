//
//  FeedViewController.swift
//  QiitaClientApp
//
//  Created by 高橋拓也 on 2022/02/15.
//

import Alamofire
import UIKit

struct ArticlesGetRequest: QiitaAPIRequest {
    public typealias Response = [QiitaArticle]
    var path: String { "/items" }
    var perPage: Int { 30 }
    let method = HTTPMethod.get

    let page: Int
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

final class FeedViewController: BaseArticlesViewController {
    var searchController: UISearchController!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
    }

    override func fetchAndSetArticles(refreshAll: Bool = false) {
        settingsBeforeFetch(refreshAll: refreshAll)
        AF.request(ArticlesGetRequest(page: page, query: searchWord))
            .responseDecodable(of: ArticlesGetRequest.Response.self) { response in
                self.setArticlesFromResponse(refreshAll: refreshAll, response: response)
            }
    }

    func setUpSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
}

extension FeedViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchWord = searchBar.text
        fetchAndSetArticles(refreshAll: true)
    }

    // 文字がセットされていたらクエリなしでfetchし直す
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchWord != nil {
            searchWord = nil
            fetchAndSetArticles(refreshAll: true)
        }
    }
}
