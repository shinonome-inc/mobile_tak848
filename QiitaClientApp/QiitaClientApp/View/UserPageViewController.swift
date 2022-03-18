//
//  MypageViewController.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/14.
//

import Alamofire
import UIKit

struct AuthUserGetRequest: QiitaAPIRequest {
    public typealias Response = QiitaUser
//    var path: String { "/authenticated_user" }
    var path: String { "/users/yaotti" }
    let method = HTTPMethod.get
    var parameters: Parameters { [:] }
}

struct AuthUserArticlesGetRequest: QiitaAPIRequest {
    public typealias Response = [QiitaArticle]
//    var path: String { "/authenticated_user/items" }
    var path: String { "/users/yaotti/items" }
    var perPage: Int { 30 }
    let method = HTTPMethod.get

    let page: Int

    var parameters: Parameters {
        [
            "per_page": String(perPage),
            "page": String(page)
        ]
    }
}

protocol UserPageViewControllerProtocol {
    func presentFollowViewController(followMode mode: FollowMode)
}

class UserPageViewController: BaseArticlesViewController {
    var followMode: FollowMode?
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.toFollowViewController.rawValue {
            if let nextVC = segue.destination as? FollowViewController,
               let followMode = followMode
            {
                nextVC.configure(followMode: followMode)
            }
        }
    }

    override func setUpTableView() {
        articlesTableView.delegate = self
        articlesTableView.dataSource = self
        articlesTableView.registerCustomCell(UserArticleCell.self)
        articlesTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        setUpTableViewUserInfoHeader()
        setUpPostedArticlesSectionHeader()
    }

    func setUpTableViewUserInfoHeader() {
        articlesTableView.sectionHeaderTopPadding = 0
        if let userInfoView = Bundle.main.loadNibNamed(UserInfoView.identifier, owner: self)?.first as? UIView {
            userInfoView.translatesAutoresizingMaskIntoConstraints = false
            articlesTableView.tableHeaderView = userInfoView
            userInfoView.widthAnchor.constraint(equalTo: articlesTableView.widthAnchor).isActive = true
            userInfoView.centerXAnchor.constraint(equalTo: articlesTableView.centerXAnchor).isActive = true
            userInfoView.topAnchor.constraint(equalTo: articlesTableView.topAnchor).isActive = true
        }
        if let header = articlesTableView.tableHeaderView as? UserInfoView {
            header.delegate = self
        }
    }

    func setUpPostedArticlesSectionHeader() {
        articlesTableView.register(headerFooterViewClass: PostedArticlesLabel.self)
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
        AF.request(AuthUserArticlesGetRequest(page: page))
            .responseDecodable(of: AuthUserArticlesGetRequest.Response.self) { response in
                self.setArticlesFromResponse(refreshAll: refreshAll, response: response)
            }
    }
    
    func fetchAndSetUserInfo() {
        guard QiitaAccessToken().isExist,
              let header = articlesTableView.tableHeaderView as? UserInfoView
        else {
            return
        }
        AF.request(AuthUserGetRequest())
            .responseDecodable(of: AuthUserGetRequest.Response.self) { response in
                switch response.result {
                case let .success(user):
                    header.configure(userData: user)
                case .failure:
                    print("error")
                }
            }
    }
}

extension UserPageViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCustomCell(with: UserArticleCell.self),
              let articles = articles
        else {
            return UserArticleCell()
        }
        cell.configure(article: articles[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withClass: PostedArticlesLabel.self) else {
            return PostedArticlesLabel()
        }
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let header = tableView.dequeueReusableHeaderFooterView(withClass: PostedArticlesLabel.self) else {
            return 0
        }
        return header.frame.height
    }
}

extension UserPageViewController: UserPageViewControllerProtocol {
    func presentFollowViewController(followMode mode: FollowMode) {
        followMode = mode
        performSegue(segue: .toFollowViewController, sender: nil)
    }
}
