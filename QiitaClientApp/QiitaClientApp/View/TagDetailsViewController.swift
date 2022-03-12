//
//  TagDetailsViewController.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/09.
//

import UIKit

class TagDetailsViewController: UIViewController {
    var tagId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = tagId ?? ""
    }

    func configure(tagId id: String) {
        tagId = id
    }
}
