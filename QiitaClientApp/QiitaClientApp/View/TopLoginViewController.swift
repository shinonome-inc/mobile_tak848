//
//  ViewController.swift
//  QiitaClientApp
//
//  Created by 高橋拓也 on 2022/02/06.
//

import UIKit

class TopLoginViewController: UIViewController {
    @IBAction func onTapLoginButton(_ sender: UIButton) {
        performSegue(segue: .toMainTabController, sender: nil)
    }

    @IBAction func onTapWithoutLoginButton(_ sender: UIButton) {
        performSegue(segue: .toMainTabController, sender: nil)
    }
}
