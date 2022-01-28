//
//  ViewController.swift
//  kadai07
//
//  Created by 吉田周平 on 2021/02/04.
//

import UIKit
//↓Alamofireをimportしてください

//↑Alamofireをimportしてください

class ArticlesViewController: UIViewController {
    
    @IBOutlet var articleTableView: UITableView!
    var errorView: ErrorView!
    //↓追加で変数を定義してください
    
    //↑追加で変数を定義してください

    override func viewDidLoad() {
        super.viewDidLoad()
        articleTableView.delegate = self
        articleTableView.dataSource = self
        //↓QiitaAPIのリクエストやdelegateの設定を行なってください
        
        //↑QiitaAPIのリクエストやdelegateの設定を行なってください
    }
}

extension ArticlesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //↓クリックした際にもQiitaAPIのリクエストを実装してください
        
        //↑クリックした際にもQiitaAPIのリクエストを実装してください
    }
}

extension ArticlesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //↓取得してきた記事の件数に変更してください
        return 1
        //↑取得してきた記事の件数に変更してください
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? TableViewCellController else {
                return UITableViewCell()
        }
        
        //↓関数で定義したTableViewのCellの設定を実行してください
        
        //↑関数で定義したTableViewのCellの設定を実行してください
        
        return cell
    }
}

//↓作成したErrorView用のdelegateの中身となる関数を設定してください

//↑作成したErrorView用のdelegateの中身となる関数を設定してください
