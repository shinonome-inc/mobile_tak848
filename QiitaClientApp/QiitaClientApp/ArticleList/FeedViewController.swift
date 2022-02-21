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
    var url: URL
    var user: QiitaUser
    var createdAt: Date
    var likesCount: Int
    public enum CodingKeys: String, CodingKey {
        case title
        case url
        case user
        case createdAt = "created_at"
        case likesCount = "likes_count"
    }
}

extension KeyedDecodingContainer {
    func decode(_: Date.Type, forKey key: Key) throws -> Date {
        let value = try decodeIfPresent(String.self, forKey: key)!
        return ISO8601DateFormatter().date(from: value)!
    }
}

struct QiitaUser: Codable {
    var id: String
    var profileImageUrl: URL
    public enum CodingKeys: String, CodingKey {
        case id
        case profileImageUrl = "profile_image_url"
    }
}

protocol WebAPIRequest: URLRequestConvertible {
    // APIリクエストごとに変わったり変わらなかったりする
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters { get }

    // 認証が不要な場合はnil
    var accessToken: String? { get }
}

extension WebAPIRequest {
    var baseURL: URL { URL(string: "https://qiita.com/api/v2")! }
    public func asURLRequest() throws -> URLRequest {
        let request = URLRequest(url: baseURL.appendingPathComponent(path))
        switch method {
        case .post, .put:
            return try JSONEncoding.default.encode(request, with: parameters)
        default:
            return try URLEncoding.queryString.encode(request, with: parameters)
        }
    }
}

struct ArticlesGetRequest: WebAPIRequest {
    public typealias Response = [QiitaArticle]
    let accessToken: String?

    var path: String { "/items" }
    let method = HTTPMethod.get

    let page: Int
    let query: String?

    var parameters: Parameters {
        var parameters = ["per_page": "20", "page": String(page)]
        if let query = query {
            parameters.updateValue(query, forKey: "query")
        }
        return parameters
    }

    init(accessToken: String, page: Int, query: String? = nil) {
        self.accessToken = accessToken
        self.page = page
        self.query = query
    }
}

struct UserGetRequest: WebAPIRequest {
    var parameters: Parameters { [:] }
    
    public typealias Response = QiitaUser
    let accessToken: String?

    var path: String { "/authenticated_user" }
    let method = HTTPMethod.get

    init(accessToken: String) {
        self.accessToken = accessToken
    }
}

class FeedViewController: UIViewController {
    var articles: [QiitaArticle]?
    var searchController: UISearchController!
    var page = 1
    @IBOutlet weak var feedTableView: UITableView!
    let refreshControl = UIRefreshControl()
    var loading = false
    var searchWord: String?
    var articleUrl: URL?
    
    func fetchQiitaArticleList(reload: Bool = false) {
        if reload {
            page = 1
        }
        loading = true
        let rrrr = ArticlesGetRequest(accessToken: "93748143a1e64ab5838a865f8c60cbb755e65a60", page: page, query: searchWord)
        AF.request(rrrr)
            .responseDecodable(of: ArticlesGetRequest.Response.self) { response in
                switch response.result {
                case let .success(articles):
                    print(self.page)
                    self.page += 1
                    if reload || self.articles == nil {
                        self.articles = articles
                    } else {
                        self.articles?.append(contentsOf: articles)
                    }
                case let .failure(error):
                    print(error)
                    self.articles = nil
                }
                self.loading = false
                self.feedTableView.reloadData()
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.register(UINib(nibName: "QiitaArticleCell", bundle: nil), forCellReuseIdentifier: QiitaArticleCell.identifier)
        feedTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        setupSearchBar()
        fetchQiitaArticleList()
    }

    @objc func refresh(_ sender: UIRefreshControl) {
        fetchQiitaArticleList(reload: true)
        refreshControl.endRefreshing()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPathForSelectedRow = feedTableView.indexPathForSelectedRow {
            feedTableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.toArticleViewController.rawValue {
            if let nextVC3 = segue.destination as? UINavigationController,
               let nextVC2 = nextVC3.topViewController as? ArticleViewController,
               let articleUrl = articleUrl
            {
                nextVC2.articleUrl = articleUrl
                if let indexPathForSelectedRow = feedTableView.indexPathForSelectedRow {
                    feedTableView.deselectRow(at: indexPathForSelectedRow, animated: true)
                }
            }
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
            qiitaArticleVC.articleUrl = articles[indexPath.row].url
            print(articles[indexPath.row].url)
            articleUrl = articles[indexPath.row].url
            print(qiitaArticleVC.articleUrl ?? "")
            performSegue(segue: .toArticleViewController, sender: nil)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        let distanceToBottom = maximumOffset - currentOffsetY
        if distanceToBottom < 600, !loading {
            fetchQiitaArticleList()
        }
    }
}

protocol QiitaRequest {
    var baseURL: URL { get }
    var path: String { get }
}

extension QiitaRequest {
    var baseURL: URL {
        URL(string: "https://qiita.com/api/v2")!
    }
}

extension FeedViewController {
    func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
}

extension FeedViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchWord = searchBar.text
        fetchQiitaArticleList(reload: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchWord != nil {
            searchWord = nil
            fetchQiitaArticleList(reload: true)
        }
    }
}

extension Date {
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: self)
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
        articleUserIdLabel.text = "@\(article.user.id) 投稿日: \(article.createdAt.dateString) LGTM: \(article.likesCount)"
        articleUserImage.cacheImage(imageUrl: article.user.profileImageUrl)
    }
}

extension UIImageView {
    static let imageCache = NSCache<AnyObject, AnyObject>()

    func cacheImage(imageUrl: URL) {
        let imageUrlString = imageUrl.absoluteString
        if let imageFromCache = UIImageView.imageCache.object(forKey: imageUrlString as AnyObject) as? UIImage {
            image = imageFromCache
            return
        }
        URLSession.shared.dataTask(with: imageUrl) { data, _, error in
            if error != nil {
                return
            }
            DispatchQueue.main.async {
                guard let imageToCache = UIImage(data: data!) else {
                    return
                }
                self.image = imageToCache
                UIImageView.imageCache.setObject(imageToCache, forKey: imageUrlString as AnyObject)
            }
        }.resume()
    }
}

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
