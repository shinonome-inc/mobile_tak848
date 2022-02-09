//
//  QiitaArticleViewController.swift
//  kadai08
//
//  Created by 高橋拓也 on 2022/02/06.
//

import UIKit
import WebKit

class QiitaArticleViewController: UIViewController, WKUIDelegate {
    
    static let identifier = "QiitaArticleViewController"
    var articleUrl: URL?
    @IBOutlet weak var qiitaArticleWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qiitaArticleWebView.uiDelegate = self
        if let url: URL = articleUrl {
            let request = URLRequest(url: url)
            qiitaArticleWebView.load(request)
        }
    }
    
}
