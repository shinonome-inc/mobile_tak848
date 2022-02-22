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
    var perPage: Int { 20 }
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

class FeedViewController: UIViewController {
    @IBOutlet weak var feedTableView: UITableView!
    var searchController: UISearchController!
    let refreshControl = UIRefreshControl()
    
    var articles: [QiitaArticle]?
    var loading = false
    var page = 1
    var searchWord: String?
    var articleUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        setUpTableview()
        fetchAndSetArticles()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.toArticleViewController.rawValue {
            // URLをセットして選択を解除する
            if let nextNavigationController = segue.destination as? UINavigationController,
               let nextVC = nextNavigationController.topViewController as? ArticleViewController,
               let articleUrl = articleUrl
            {
                nextVC.articleUrl = articleUrl
                if let indexPathForSelectedRow = feedTableView.indexPathForSelectedRow {
                    feedTableView.deselectRow(at: indexPathForSelectedRow, animated: true)
                }
            }
        }
    }
    
    func fetchAndSetArticles(refreshAll: Bool = false) {
        if refreshAll {
            page = 1
            articles = nil
            feedTableView.reloadData()
        }
        loading = true
        AF.request(ArticlesGetRequest(page: page, query: searchWord))
            .responseDecodable(of: ArticlesGetRequest.Response.self) { response in
                switch response.result {
                case let .success(articles):
                    self.page += 1
                    if refreshAll || self.articles == nil {
                        self.articles = articles
                    } else {
                        self.articles?.append(contentsOf: articles)
                    }
                case .failure:
                    self.articles = nil
                }
                self.loading = false
                self.feedTableView.reloadData()
            }
    }

    func setUpSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    func setUpTableview() {
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.registerCustomCell(ArticleCell.self)
        feedTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    }

    @objc func refresh(_ sender: UIRefreshControl) {
        fetchAndSetArticles(refreshAll: true)
        refreshControl.endRefreshing()
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let unwrappedArticles: [QiitaArticle] = articles else {
            return 0
        }
        return unwrappedArticles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCustomCell(with: ArticleCell.self),
              let articles = articles
        else {
            return ArticleCell()
        }
        cell.configure(article: articles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let articles = articles else {
            return
        }
        if let qiitaArticleVC = storyboard?.instantiateViewController(withIdentifier: ArticleViewController.identifier) as? ArticleViewController {
            qiitaArticleVC.articleUrl = articles[indexPath.row].url
            articleUrl = articles[indexPath.row].url
            performSegue(segue: .toArticleViewController, sender: nil)
        }
    }

    // ある程度下に来たら次のfetch
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !loading {
            let currentOffsetY = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
            let distanceToBottom = maximumOffset - currentOffsetY
            if distanceToBottom < 600, !loading {
                fetchAndSetArticles()
            }
        }
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
