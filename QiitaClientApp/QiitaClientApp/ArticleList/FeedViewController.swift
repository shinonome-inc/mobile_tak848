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
    @IBOutlet weak var feedTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        AF.request("https://qiita.com/api/v2/items?page=1&per_page=40")
            .responseDecodable(of: [QiitaArticle].self, decoder: decoder) { response in
                switch response.result {
                case let .success(articles):
                    self.articles = articles
                    self.feedTableView.delegate = self
                    self.feedTableView.dataSource = self
                    self.feedTableView.register(UINib(nibName: "QiitaArticleCell", bundle: nil), forCellReuseIdentifier: QiitaArticleCell.identifier)
                    self.feedTableView.reloadData()
                case let .failure(error):
                    print(error)
                }
            }
//        articles = [QiitaArticle(title: "aa", url: "bb", user: QiitaUser(id: "aaa"))]
//        feedTableView.delegate = self
//        feedTableView.dataSource = self
//        feedTableView.register(UINib(nibName: "QiitaArticleCell", bundle: nil), forCellReuseIdentifier: QiitaArticleCell.identifier)
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
//        guard let unwrappedArticles: [QiitaArticle] = articles else {
//            return
//        }
//        if let qiitaArticleVC = self.storyboard?.instantiateViewController(withIdentifier: QiitaArticleViewController.identifier) as? QiitaArticleViewController {
//            qiitaArticleVC.articleUrl = URL(string: unwrappedArticles[indexPath.row].url)
//            self.navigationController?.pushViewController(qiitaArticleVC, animated: true)
//        }
        performSegue(segue: .toArticleViewController, sender: nil)
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
