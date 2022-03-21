//
//  MainTabBarController.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/14.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedIndex = 0
    }
}
