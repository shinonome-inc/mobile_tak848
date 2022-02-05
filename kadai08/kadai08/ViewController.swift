//
//  ViewController.swift
//  kadai08
//
//  Created by 高橋拓也 on 2022/02/05.
//

import UIKit
import Alamofire

struct QiitaArticle: Codable {
    var title: String
    var url: String
    var user: QiitaUser
}
struct QiitaUser: Codable {
    var id: String
}

class ViewController: UIViewController {
    
    var articles:[QiitaArticle]?
    @IBOutlet weak var qiitaArticlesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AF.request("https://qiita.com/api/v2/items?page=1&per_page=40")
            .responseDecodable(of: [QiitaArticle].self) { response in
                switch response.result {
                case .success(let articles):
                    self.articles = articles
                    self.qiitaArticlesTableView.delegate = self
                    self.qiitaArticlesTableView.dataSource = self
                    self.qiitaArticlesTableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPathForSelectedRow = qiitaArticlesTableView.indexPathForSelectedRow {
            qiitaArticlesTableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let unwrappedArticles: [QiitaArticle] = articles else {
            return 0
        }
        return unwrappedArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QiitaArticleCell.identifier) as? QiitaArticleCell,
              let unwrappedArticles: [QiitaArticle] = articles else {
                  return QiitaArticleCell()
              }
        cell.configure(article: unwrappedArticles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let unwrappedArticles: [QiitaArticle] = articles else {
            return
        }
        if let qiitaArticleVC = self.storyboard?.instantiateViewController(withIdentifier: QiitaArticleViewController.identifier) as? QiitaArticleViewController {
            qiitaArticleVC.articleUrl = URL(string: unwrappedArticles[indexPath.row].url)
            self.navigationController?.pushViewController(qiitaArticleVC, animated: true)
        }
    }
    
}
