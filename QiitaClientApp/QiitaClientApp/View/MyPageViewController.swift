//
//  AuthUserPageViewController.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/19.
//

import Alamofire
import UIKit

class MyPageViewController: BaseUserPageViewController {
    override func fetchAndSetUserInfo() {
        guard QiitaAccessToken().isExist
        else {
            return
        }
        AF.request(AuthUserGetRequest())
            .responseDecodable(of: AuthUserGetRequest.Response.self) { response in
                switch response.result {
                case let .success(user):
                    self.user = user
                    self.setUserInfoHeader()
                case .failure:
                    print("error")
                }
            }
    }

    override func settingsBeforeFetch(refreshAll: Bool) {
        if refreshAll {
            page = 1
            articles = nil
            articlesTableView.reloadData()
            fetchAndSetUserInfo()
        }
        loading = true
    }
}
