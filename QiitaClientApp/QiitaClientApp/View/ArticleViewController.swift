//
//  ArticleViewController.swift
//  QiitaClientApp
//
//  Created by 高橋拓也 on 2022/02/22.
//

import UIKit
import WebKit

class ArticleViewController: UIViewController, WKUIDelegate {
    @IBOutlet weak var articleWebView: WKWebView!
    
    var articleUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleWebView.uiDelegate = self
        if let url: URL = articleUrl {
            let request = URLRequest(url: url)
            articleWebView.load(request)
        }
    }
}
