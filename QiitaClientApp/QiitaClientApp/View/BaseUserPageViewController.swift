//
//  MypageViewController.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/14.
//

import Alamofire
import UIKit

protocol UserPageViewControllerProtocol {
    func presentFollowViewController(followMode mode: FollowMode)
}

class BaseUserPageViewController: BaseArticlesViewController {
    var followMode: FollowMode?
    var user: QiitaUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonDisplayMode = .minimal
    }

    override func setUpTableView() {
        articlesTableView.delegate = self
        articlesTableView.dataSource = self
        articlesTableView.registerCustomCell(UserArticleCell.self)
        articlesTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        articlesTableView.sectionHeaderTopPadding = 0
        setUpUserInfoHeader()
        setUpPostedArticlesSectionHeader()
    }

    func setUpUserInfoHeader() {
        if let userInfoView = Bundle.main.loadNibNamed(UserInfoView.identifier, owner: self)?.first as? UserInfoView
        {
            userInfoView.delegate = self
            userInfoView.translatesAutoresizingMaskIntoConstraints = false
            articlesTableView.tableHeaderView = userInfoView
            userInfoView.widthAnchor.constraint(equalTo: articlesTableView.widthAnchor).isActive = true
            userInfoView.centerXAnchor.constraint(equalTo: articlesTableView.centerXAnchor).isActive = true
            userInfoView.topAnchor.constraint(equalTo: articlesTableView.topAnchor).isActive = true
        }
    }

    func setUserInfoHeader() {
        if let userInfoView = articlesTableView.tableHeaderView as? UserInfoView, let user = user {
            articlesTableView.tableHeaderView = userInfoView
            userInfoView.configure(userData: user)
            userInfoView.setNeedsLayout()
            userInfoView.layoutIfNeeded()
        }
    }

    override func fetchAndSetArticles(refreshAll: Bool = false) {
        settingsBeforeFetch(refreshAll: refreshAll)
        AF.request(AuthUserArticlesGetRequest(page: page, perPage: articlesPerPage))
            .responseDecodable(of: AuthUserArticlesGetRequest.Response.self) { response in
                self.setArticlesFromResponse(refreshAll: refreshAll, response: response)
            }
    }
    
    func fetchAndSetUserInfo() {
        fatalError("must override")
    }
}

extension BaseUserPageViewController {
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

extension BaseUserPageViewController: UserPageViewControllerProtocol {
    func presentFollowViewController(followMode mode: FollowMode) {
        if let storyboard = storyboard,
           let userPageViewController = storyboard.instantiateViewController(with: FollowViewController.self),
           let navigationController = navigationController,
           let user = user
        {
            userPageViewController.configure(targetUser: user, followMode: mode)
            navigationController.pushViewController(userPageViewController, animated: true)
        }
    }
}
