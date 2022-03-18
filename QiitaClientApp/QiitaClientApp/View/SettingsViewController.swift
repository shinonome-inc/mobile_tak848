//
//  SettingsViewController.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/14.
//

import UIKit

class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onTapLogout(_ sender: Any) {
        QiitaAccessToken().remove()
        if let tabBarController = tabBarController,
           let topLoginViewController = storyboard!.instantiateViewController(with: TopLoginViewController.self)
        {
            tabBarController.dismiss(animated: true)
            present(topLoginViewController, animated: true)
        }
    }
}
