//
//  BaseArticlesViewController.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/17.
//

import Alamofire
import UIKit

class BaseArticlesViewController: UIViewController {
    @IBOutlet weak var articlesTableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    var articles: [QiitaArticle]?
    var loading = false
    var paginationFinished = false
    var page = 1
    let articlesPerPage = 30
    let maxPage = 100
    var searchWord: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        fetchAndSetArticles(refreshAll: true)
    }
    
    func fetchAndSetArticles(refreshAll: Bool = false) {
        fatalError("Must Override")
//        // example
//        settingsBeforeFetch(refreshAll: refreshAll)
//        AF.request(ArticlesGetRequest(page: page, query: searchWord))
//            .responseDecodable(of: ArticlesGetRequest.Response.self) { response in
//                self.setArticlesFromResponse(refreshAll: refreshAll, response: response)
//            }
    }

    func settingsBeforeFetch(refreshAll: Bool) {
        if refreshAll {
            page = 1
            articles = nil
            articlesTableView.reloadData()
            paginationFinished = false
        }
        loading = true
    }

    func setArticlesFromResponse(refreshAll: Bool, response: DataResponse<ArticlesGetRequest.Response, AFError>) {
        switch response.result {
        case let .success(newArticles):
            page += 1
            if refreshAll || articles == nil {
                articles = newArticles
            } else {
                articles?.append(contentsOf: newArticles)
            }
            if newArticles.count < articlesPerPage || page > maxPage {
                paginationFinished = true
            }
        case .failure:
            articles = nil
        }
        loading = false
        articlesTableView.reloadData()
    }

    func setUpTableView() {
        articlesTableView.delegate = self
        articlesTableView.dataSource = self
        articlesTableView.registerCustomCell(NormalArticleCell.self)
        articlesTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    }

    func setUpPostedArticlesSectionHeader() {
        articlesTableView.register(headerFooterViewClass: PostedArticlesLabel.self)
    }

    @objc func refresh(_ sender: UIRefreshControl) {
        fetchAndSetArticles(refreshAll: true)
        refreshControl.endRefreshing()
    }
}

extension BaseArticlesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let articles = articles else {
            return 0
        }
        return articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCustomCell(with: NormalArticleCell.self),
              let articles = articles
        else {
            return NormalArticleCell()
        }
        cell.configure(article: articles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let articles = articles else {
            return
        }
        if let articleNavaigationController = storyboard!.instantiateViewController(with: ArticleNavigationController.self) {
            let articleViewController = articleNavaigationController.topViewController as? ArticleViewController
            articleViewController?.articleUrl = articles[indexPath.row].url
            present(articleNavaigationController, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    // ある程度下に来たら次のfetch
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !loading, !paginationFinished {
            let currentOffsetY = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
            let distanceToBottom = maximumOffset - currentOffsetY
            let nextLoadingDistance: CGFloat = 600
            if distanceToBottom < nextLoadingDistance {
                fetchAndSetArticles()
            }
        }
    }
}
