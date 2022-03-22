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
    var networkErrorView: NetworkErrorView?
    var noQueryMatchErrorView: NoQueryMatchErrorView?
    
    var displayingNetworkError = false
    
    let refreshControl = UIRefreshControl()
    var articles: [QiitaArticle]?
    var loading = false
    // これ以上記事が無いorページネーションの最大ページへの到達検知フラグ
    var paginationFinished = false
    var page = 1
    let articlesPerPage = 30
    let maxPage = 100
    var searchWord: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkErrorView = Bundle.main.loadNibNamed(NetworkErrorView.identifier, owner: self)!.first! as? NetworkErrorView
        noQueryMatchErrorView = Bundle.main.loadNibNamed(NoQueryMatchErrorView.identifier, owner: self)!.first! as? NoQueryMatchErrorView
        setUpTableView()
        fetchAndSetArticles(refreshAll: true)
        networkErrorView?.delegate = self
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

    final func setArticlesFromResponse(refreshAll: Bool, response: DataResponse<ArticlesGetRequest.Response, AFError>) {
        switch response.result {
        case let .success(newArticles):
            if page == 1 && newArticles.count == 0 && searchWord != nil {
                addNoQueryMatchErrorSubView()
            }
            page += 1
            if refreshAll || articles == nil {
                articles = newArticles
            } else {
                articles?.append(contentsOf: newArticles)
            }
            if newArticles.count < articlesPerPage || page > maxPage {
                paginationFinished = true
            }
            removeNetworkErrorSubView()
        case .failure:
            addNetworkErrorSubView()
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
    
    func addNetworkErrorSubView() {
        guard let networkErrorView = networkErrorView, !displayingNetworkError else {
            return
        }
        if searchWord == nil {
            navigationItem.searchController?.searchBar.isHidden = true
        }
        displayingNetworkError = true
        view.addSubview(networkErrorView)
        networkErrorView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        safeArea.topAnchor.constraint(equalToSystemSpacingBelow: networkErrorView.topAnchor, multiplier: 0).isActive = true
        safeArea.leadingAnchor.constraint(equalToSystemSpacingAfter: networkErrorView.leadingAnchor, multiplier: 0).isActive = true
        safeArea.trailingAnchor.constraint(equalToSystemSpacingAfter: networkErrorView.trailingAnchor, multiplier: 0).isActive = true
        safeArea.bottomAnchor.constraint(equalToSystemSpacingBelow: networkErrorView.bottomAnchor, multiplier: 0).isActive = true
    }

    func removeNetworkErrorSubView() {
        guard let networkErrorView = networkErrorView, displayingNetworkError else {
            return
        }
        networkErrorView.removeFromSuperview()
        displayingNetworkError = false
        navigationItem.searchController?.searchBar.isHidden = false
    }

    func addNoQueryMatchErrorSubView() {
        guard let noQueryMatchErrorView = noQueryMatchErrorView else {
            return
        }
        view.addSubview(noQueryMatchErrorView)
        noQueryMatchErrorView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        safeArea.topAnchor.constraint(equalToSystemSpacingBelow: noQueryMatchErrorView.topAnchor, multiplier: 0).isActive = true
        safeArea.bottomAnchor.constraint(equalToSystemSpacingBelow: noQueryMatchErrorView.bottomAnchor, multiplier: 0).isActive = true
        safeArea.leadingAnchor.constraint(equalToSystemSpacingAfter: noQueryMatchErrorView.leadingAnchor, multiplier: 0).isActive = true
        safeArea.trailingAnchor.constraint(equalToSystemSpacingAfter: noQueryMatchErrorView.trailingAnchor, multiplier: 0).isActive = true
    }

    func removeNoQueryMatchErrorSubView() {
        guard let noQueryMatchErrorView = noQueryMatchErrorView else {
            return
        }
        noQueryMatchErrorView.removeFromSuperview()
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

extension BaseArticlesViewController: NetworkErrorViewProtocol {
    func reloadFromErrorButton() {
        if !loading {
            fetchAndSetArticles(refreshAll: true)
        }
    }
}
