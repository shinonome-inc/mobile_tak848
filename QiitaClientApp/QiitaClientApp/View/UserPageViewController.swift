//
//  UserPageViewController.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/19.
//

import Alamofire
import UIKit

class UserPageViewController: BaseUserPageViewController {
    func configure(user: QiitaUser) {
        self.user = user
        title = user.displayName
        navigationItem.backButtonTitle = "\(user.displayName) \(user.displayId)"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUserInfoHeader()
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

    override func fetchAndSetArticles(refreshAll: Bool = false) {
        settingsBeforeFetch(refreshAll: refreshAll)
        AF.request(UserArticlesGetRequest(user: user!, page: page, perPage: articlesPerPage))
            .responseDecodable(of: AuthUserArticlesGetRequest.Response.self) { response in
                self.setArticlesFromResponse(refreshAll: refreshAll, response: response)
            }
    }

    override func fetchAndSetUserInfo() {
        guard QiitaAccessToken().isExist,
              let header = articlesTableView.tableHeaderView as? UserInfoView,
              let user = user
        else {
            return
        }
        AF.request(UserGetRequest(user: user))
            .responseDecodable(of: UserGetRequest.Response.self) { response in
                switch response.result {
                case let .success(user):
                    header.configure(userData: user)
                    self.user = user
                    self.setUserInfoHeader()
                    self.removeNetworkErrorSubView()
                case .failure:
                    self.addNetworkErrorSubView()
                }
            }
    }
}
