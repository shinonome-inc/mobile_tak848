//
//  NetworkErrorView.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/22.
//

import UIKit

protocol NetworkErrorViewProtocol: AnyObject {
    func reloadFromErrorButton()
}

class NetworkErrorView: UIView {
    var delegate: NetworkErrorViewProtocol?
    @IBAction func onTapReloadButton(_ sender: UIButton) {
        delegate?.reloadFromErrorButton()
    }
}
