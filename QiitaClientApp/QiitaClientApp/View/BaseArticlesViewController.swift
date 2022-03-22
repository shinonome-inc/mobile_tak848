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
    var networkErrorView: UIView?
    var noQueryMatchErrorView: UIView?
    
    let refreshControl = UIRefreshControl()
    var articles: [QiitaArticle]?
    var loading = false
    var page = 1
    var searchWord: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkErrorView = Bundle.main.loadNibNamed(NetworkErrorView.identifier, owner: self)!.first! as? UIView
        noQueryMatchErrorView = Bundle.main.loadNibNamed(NoQueryMatchErrorView.identifier, owner: self)!.first! as? UIView
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
        }
        loading = true
    }

    func setArticlesFromResponse(refreshAll: Bool, response: DataResponse<ArticlesGetRequest.Response, AFError>) {
//        addNetworkErrorSubView()
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
            
//            addNetworkErrorSubView()
        case .failure:
            articles = nil
//            addNetworkErrorSubView()
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

    @objc func refresh(_ sender: UIRefreshControl) {
        fetchAndSetArticles(refreshAll: true)
        refreshControl.endRefreshing()
    }
    
    func addNetworkErrorSubView() {
        guard let networkErrorView = networkErrorView else {
            return
        }
        view.addSubview(networkErrorView)
        networkErrorView.translatesAutoresizingMaskIntoConstraints = false
        
        view.leadingAnchor.constraint(equalToSystemSpacingAfter: networkErrorView.leadingAnchor, multiplier: 0).isActive = true
//        view.topAnchor.constraint(equalToSystemSpacingBelow: networkErrorView.topAnchor, multiplier: 0).isActive = true
        let ccc = view.safeAreaLayoutGuide.topAnchor.constraint(equalToSystemSpacingBelow: networkErrorView.topAnchor, multiplier: 0)
        ccc.priority = UILayoutPriority(800)
        ccc.isActive = true
        let ddd = navigationController?.navigationBar.topItem?.searchController?.searchBar.topAnchor.constraint(equalToSystemSpacingBelow: networkErrorView.topAnchor, multiplier: 0)

        ddd?.priority = UILayoutPriority(900)
//        ddd?.isActive = true
        let eee = navigationController?.navigationBar.backItem?.searchController?.searchBar.topAnchor.constraint(equalToSystemSpacingBelow: networkErrorView.topAnchor, multiplier: 0)
        eee?.priority = UILayoutPriority(870)
//        eee?.isActive = true
        
//        navigationController?.navigationBar.bottomAnchor.constraint(equalToSystemSpacingBelow: networkErrorView.topAnchor, multiplier: 0).isActive = true
//        articlesTableView.topAnchor.constraint(equalToSystemSpacingBelow: networkErrorView.topAnchor, multiplier: 0).isActive = true
        view.trailingAnchor.constraint(equalToSystemSpacingAfter: networkErrorView.trailingAnchor, multiplier: 0).isActive = true
//        view.bottomAnchor.constraint(equalToSystemSpacingBelow: networkErrorView.bottomAnchor, multiplier: 0).isActive = true
        articlesTableView.bottomAnchor.constraint(equalToSystemSpacingBelow: networkErrorView.bottomAnchor, multiplier: 0).isActive = true
    }

    func removeNetworkErrorSubView() {
        guard let networkErrorView = networkErrorView else {
            return
        }
        networkErrorView.removeFromSuperview()
    }

    func addNoQueryMatchErrorSubView() {
        guard let noQueryMatchErrorView = noQueryMatchErrorView else {
            return
        }
        view.addSubview(noQueryMatchErrorView)
        noQueryMatchErrorView.translatesAutoresizingMaskIntoConstraints = false
        view.safeAreaLayoutGuide.topAnchor.constraint(equalToSystemSpacingBelow: noQueryMatchErrorView.topAnchor, multiplier: 0).isActive = true
        view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: noQueryMatchErrorView.bottomAnchor, multiplier: 0).isActive = true
        view.safeAreaLayoutGuide.leadingAnchor.constraint(equalToSystemSpacingAfter: noQueryMatchErrorView.leadingAnchor, multiplier: 0).isActive = true
//        view.safeAreaLayoutGuide.leadingAnchor.constraint(equalToSystemSpacingBelow: noQueryMatchErrorView.leadingAnchor, multiplier: 0).isActive = true
        view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: noQueryMatchErrorView.trailingAnchor, multiplier: 0).isActive = true
//        view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingBelow: noQueryMatchErrorView.trailingAnchor, multiplier: 0).isActive = true
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
        if !loading {
            let currentOffsetY = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
            let distanceToBottom = maximumOffset - currentOffsetY
            let nextLoadingDistance: CGFloat = 600
            if distanceToBottom < nextLoadingDistance {
                fetchAndSetArticles()
//                addNetworkErrorSubView()
            }
            if currentOffsetY > 2 {
                addNetworkErrorSubView()
            }
            print(currentOffsetY)
        }
    }
}
