//
//  ViewController.swift
//  QiitaClientApp
//
//  Created by 高橋拓也 on 2022/02/06.
//

import Alamofire
import UIKit

protocol TopLoginViewControllerDelegate: AnyObject {
    func presentMainTabController()
    func addIndicatorSubView()
    func removeIndicatorSubView()
}

class TopLoginViewController: UIViewController {
    var grayOutView: UIView?
    var qiitaAccessToken = QiitaAccessToken()

    override func viewDidLoad() {
        super.viewDidLoad()
        grayOutView = Bundle.main.loadNibNamed(LoadingIndicatorView.identifier, owner: self)!.first! as? UIView
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.toOauthViewController.rawValue {
            if let nextNavigationController = segue.destination as? UINavigationController,
               let nextVC = nextNavigationController.topViewController as? OauthViewController
            {
                let state = UUID().uuidString
                nextVC.state = state
                nextVC.delegate = self
                nextVC.articleUrl = QiitaOauthFirstRequest(state: state).urlRequest?.url
            }
        }
    }

    @IBAction func onTapLoginButton(_ sender: UIButton) {
        if qiitaAccessToken.isExist {
            presentMainTabController()
        } else {
            performSegue(segue: .toOauthViewController, sender: nil)
        }
    }

    @IBAction func onTapWithoutLoginButton(_ sender: UIButton) {
        addIndicatorSubView()
        qiitaAccessToken.remove()
        presentMainTabController()
    }

    override func viewDidDisappear(_ animated: Bool) {
        removeIndicatorSubView()
    }
}

extension TopLoginViewController: TopLoginViewControllerDelegate {
    func presentMainTabController() {
        dismiss(animated: true)
        let mainTabBarcontroller = storyboard!.instantiateViewController(with: MainTabBarController.self)
        present(mainTabBarcontroller!, animated: true, completion: nil)
    }
    
    func addIndicatorSubView() {
        guard let grayOutView = grayOutView else {
            return
        }
        view.addSubview(grayOutView)
        grayOutView.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalToSystemSpacingAfter: grayOutView.leadingAnchor, multiplier: 0).isActive = true
        view.topAnchor.constraint(equalToSystemSpacingBelow: grayOutView.topAnchor, multiplier: 0).isActive = true
        view.trailingAnchor.constraint(equalToSystemSpacingAfter: grayOutView.trailingAnchor, multiplier: 0).isActive = true
        view.bottomAnchor.constraint(equalToSystemSpacingBelow: grayOutView.bottomAnchor, multiplier: 0).isActive = true
    }

    func removeIndicatorSubView() {
        guard let grayOutView = grayOutView else {
            return
        }
        grayOutView.removeFromSuperview()
    }
}
