//
//  OauthViewController.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/12.
//

import Alamofire
import KeychainAccess
import UIKit
import WebKit

class OauthViewController: UIViewController, WKUIDelegate {
    @IBOutlet weak var oauthWebView: WKWebView!
    
    var articleUrl: URL?
    var state: String?
    var delegate: TopLoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oauthWebView.uiDelegate = self
        oauthWebView.navigationDelegate = self
        if let url = articleUrl {
            let request = URLRequest(url: url)
            oauthWebView.load(request)
        }
    }
}

extension OauthViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var qiitaAcceessToken = QiitaAccessToken()
        if navigationAction.request.url?.scheme == qiitaAcceessToken.callbackScheme, navigationAction.request.url?.host == qiitaAcceessToken.callbackHost {
            guard let url = navigationAction.request.url,
                  let state = state,
                  let returnedState = url.queryValueOf("state"),
                  returnedState == state,
                  let returnedAccessCode = url.queryValueOf("code")
            else {
                return
            }
            delegate?.addIndicatorSubView()
            let request = AccessTokenGetRequest(code: returnedAccessCode, clientId: qiitaAcceessToken.clientId, clientSecret: qiitaAcceessToken.clientSecret)
            AF.request(request)
                .responseDecodable(of: AccessTokenGetRequest.Response.self) { response in
                    switch response.result {
                    case let .success(token):
                        qiitaAcceessToken.value = token.token
                        self.delegate?.presentMainTabController()
                    case .failure:
                        print("error")
                        self.dismiss(animated: true)
                        self.delegate?.removeIndicatorSubView()
                    }
                }
        }
        decisionHandler(.allow)
    }
}
