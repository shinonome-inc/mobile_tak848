//
//  AuthUserPageViewController.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/19.
//

import Alamofire
import UIKit

class MyPageViewController: BaseUserPageViewController {
    var loginRequiredErrorView: LoginRequiredErrorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginRequiredErrorView = Bundle.main.loadNibNamed(LoginRequiredErrorView.identifier, owner: self)!.first! as? LoginRequiredErrorView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !QiitaAccessToken().isExist {
            addLoginRequiredErrorSubView()
            networkErrorView = nil
        }
    }
    
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
                    self.removeNetworkErrorSubView()
                case .failure:
                    self.addNetworkErrorSubView()
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
    
    func addLoginRequiredErrorSubView() {
        guard let loginRequiredErrorView = loginRequiredErrorView else {
            return
        }
        view.addSubview(loginRequiredErrorView)
        loginRequiredErrorView.translatesAutoresizingMaskIntoConstraints = false
        loginRequiredErrorView.delegate = self
        let safeArea = view.safeAreaLayoutGuide
        safeArea.topAnchor.constraint(equalToSystemSpacingBelow: loginRequiredErrorView.topAnchor, multiplier: 0).isActive = true
        safeArea.bottomAnchor.constraint(equalToSystemSpacingBelow: loginRequiredErrorView.bottomAnchor, multiplier: 0).isActive = true
        safeArea.leadingAnchor.constraint(equalToSystemSpacingAfter: loginRequiredErrorView.leadingAnchor, multiplier: 0).isActive = true
        safeArea.trailingAnchor.constraint(equalToSystemSpacingAfter: loginRequiredErrorView.trailingAnchor, multiplier: 0).isActive = true
    }

    func removeLoginRequiredErrorSubView() {
        guard let noQueryMatchErrorView = noQueryMatchErrorView else {
            return
        }
        noQueryMatchErrorView.removeFromSuperview()
    }
}

extension MyPageViewController: LoginRequiredProtocol {
    func moveToTopOauthPage() {
        if let tabBarController = tabBarController,
           let topLoginViewController = storyboard!.instantiateViewController(with: TopLoginViewController.self)
        {
            tabBarController.dismiss(animated: true)
            present(topLoginViewController, animated: true)
            topLoginViewController.performSegue(segue: .toOauthViewController, sender: nil)
        }
    }
}
