//
//  FollowViewController.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/17.
//

import UIKit

enum FollowMode: String {
    case following = "Follows"
    case followers = "Followers"
}

class FollowViewController: UIViewController {
    var followMode: FollowMode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = followMode?.rawValue
    }

    func configure(followMode mode: FollowMode) {
        followMode = mode
    }
}
