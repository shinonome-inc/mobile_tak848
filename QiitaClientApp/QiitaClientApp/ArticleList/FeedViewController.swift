//
//  FeedViewController.swift
//  QiitaClientApp
//
//  Created by 高橋拓也 on 2022/02/15.
//

import Alamofire
import UIKit

struct QiitaArticle: Codable {
    var title: String
    var url: String
    var user: QiitaUser
}

struct QiitaUser: Codable {
    var id: String
    var profileImageUrl: String
}

class FeedViewController: UIViewController {
    var articles: [QiitaArticle]?
    var searchController: UISearchController!
    var page = 0
    @IBOutlet weak var feedTableView: UITableView!
    let refreshControl = UIRefreshControl()
    let headers: HTTPHeaders = [
        "Authorization": "Bearer 93748143a1e64ab5838a865f8c60cbb755e65a60"
    ]
    var loading = false
    var searchWord: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        setupSearchBar()
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        page += 1
        loading = true
        AF.request("https://qiita.com/api/v2/items?page=\(page)&per_page=40", headers: headers)
            .responseDecodable(of: [QiitaArticle].self, decoder: decoder) { response in
                switch response.result {
                case let .success(articles):
                    self.articles = articles
                    self.feedTableView.delegate = self
                    self.feedTableView.dataSource = self
                    self.feedTableView.register(UINib(nibName: "QiitaArticleCell", bundle: nil), forCellReuseIdentifier: QiitaArticleCell.identifier)
                    self.feedTableView.reloadData()
                    self.loading = false
                case let .failure(error):
                    print(error)
                }
            }
    }

    @objc func refresh(_ sender: UIRefreshControl) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        page = 1
        loading = true
        AF.request("https://qiita.com/api/v2/items?page=\(page)&per_page=4", headers: headers)
            .responseDecodable(of: [QiitaArticle].self, decoder: decoder) { response in
                switch response.result {
                case let .success(articles):
                    self.articles = articles
                    self.feedTableView.delegate = self
                    self.feedTableView.dataSource = self
                    self.feedTableView.register(UINib(nibName: "QiitaArticleCell", bundle: nil), forCellReuseIdentifier: QiitaArticleCell.identifier)
                    self.feedTableView.reloadData()
                    self.loading = false
                case let .failure(error):
                    print(error)
                }
            }
        refreshControl.endRefreshing()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPathForSelectedRow = feedTableView.indexPathForSelectedRow {
            feedTableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("hello")
        if segue.identifier == Segue.toArticleViewController.rawValue {
            print("hello")
            guard let nextVC3 = segue.destination as? UINavigationController,
                  let nextVC2 = nextVC3.topViewController as? ArticleViewController
            else {
                return
            }
            print("hello")
            nextVC2.articleUrl = URL(string: "https://qiita.com")
//            if let nextVC = nextVC {
//                print("hello")
//                nextVC.articleUrl = URL(string: "https://qiita.com")
//            }
        }
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QiitaArticleCell.identifier) as? QiitaArticleCell,
              let unwrappedArticles: [QiitaArticle] = articles
        else {
            return QiitaArticleCell()
        }
        cell.configure(article: unwrappedArticles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let articles: [QiitaArticle] = articles else {
            return
        }
        if let qiitaArticleVC = storyboard?.instantiateViewController(withIdentifier: ArticleViewController.identifier) as? ArticleViewController {
            print(articles[indexPath.row])
            qiitaArticleVC.articleUrl = URL(string: articles[indexPath.row].url)
            print(articles[indexPath.row].url)
            print(qiitaArticleVC.articleUrl ?? "")
//            sleep(2)
            performSegue(segue: .toArticleViewController, sender: nil)
//            navigationController?.pushViewController(qiitaArticleVC, animated: true)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        let distanceToBottom = maximumOffset - currentOffsetY
        print(distanceToBottom)
        if distanceToBottom < 600, !loading {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            page += 1
            loading = true
            AF.request("https://qiita.com/api/v2/items?page=\(page)&per_page=40", headers: headers)
                .responseDecodable(of: [QiitaArticle].self, decoder: decoder) { response in
                    switch response.result {
                    case let .success(articles):
                        self.articles?.append(contentsOf: articles)
                        self.feedTableView.delegate = self
                        self.feedTableView.dataSource = self
                        self.feedTableView.register(UINib(nibName: "QiitaArticleCell", bundle: nil), forCellReuseIdentifier: QiitaArticleCell.identifier)
                        self.feedTableView.reloadData()
                        self.loading = false
                    case let .failure(error):
                        print(error)
                    }
                }
        }
    }
}

extension FeedViewController {
    func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
//        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
}

// extension FeedViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
////        // SearchBarに入力したテキストを使って表示データをフィルタリングする。
////        let text = searchController.searchBar.text ?? ""
////        if text.isEmpty {
////            filteredTitles = titles
////        } else {
////            filteredTitles = titles.filter { $0.contains(text) }
////        }
//        print(searchController.searchBar.text ?? "")
//        feedTableView.reloadData()
//    }
// }

extension FeedViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        page = 1
        loading = true
        AF.request("https://qiita.com/api/v2/items?page=\(page)&per_page=40&query=\(searchBar.text!)", headers: headers)
            .responseDecodable(of: [QiitaArticle].self, decoder: decoder) { response in
                switch response.result {
                case let .success(articles):
                    self.articles = articles
                    self.feedTableView.delegate = self
                    self.feedTableView.dataSource = self
                    self.feedTableView.register(UINib(nibName: "QiitaArticleCell", bundle: nil), forCellReuseIdentifier: QiitaArticleCell.identifier)
                    self.feedTableView.reloadData()
                    self.loading = false
                case let .failure(error):
                    print(error)
                }
            }
    }
}

class QiitaArticleCell: UITableViewCell {
    var articles: [QiitaArticle]?
    static let identifier = "QiitaArticleCell"
    
    @IBOutlet weak var articleUserImage: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleUserIdLabel: UILabel!
    
    func configure(article: QiitaArticle) {
        articleTitleLabel.text = article.title
        articleUserIdLabel.text = article.user.id
        articleUserImage.loadImageAsynchronously(url: URL(string: article.user.profileImageUrl))
    }
}

extension UIImageView {
    func loadImageAsynchronously(url: URL?, defaultUIImage: UIImage? = nil) {
        if url == nil {
            image = defaultUIImage
            return
        }

        DispatchQueue.global().async {
            do {
                let imageData: Data? = try Data(contentsOf: url!)
                DispatchQueue.main.async {
                    if let data = imageData {
                        self.image = UIImage(data: data)
                    } else {
                        self.image = defaultUIImage
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.image = defaultUIImage
                }
            }
        }
    }
}

// extension UINavigationBar {
//    @IBInspectable
//    private var titleFontx: UIFont? {
//        get {
//            fatalError("only set this value")
//        }
//        set {
//            if let newValue = newValue {
//                titleTextAttributes = [
//                    .font: newValue
//                ]
//            }
//        }
//    }
// }
import WebKit
class ArticleViewController: UIViewController, WKUIDelegate {
    static let identifier = "ArticleViewController"
    var articleUrl: URL?
    @IBOutlet weak var qiitaArticleWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qiitaArticleWebView.uiDelegate = self
        print(articleUrl ?? "")
        if let url: URL = articleUrl {
            let request = URLRequest(url: url)
            qiitaArticleWebView.load(request)
        }
    }
}
