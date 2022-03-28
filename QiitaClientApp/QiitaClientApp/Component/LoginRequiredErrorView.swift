//
//  LoginRequiredErrorView.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/22.
//

import UIKit

protocol LoginRequiredProtocol: AnyObject {
    func moveToTopOauthPage()
}

class LoginRequiredErrorView: UIView {
    var delegate: LoginRequiredProtocol?
    
    @IBAction func onLoginButtonClicked(_ sender: UIButton) {
        delegate?.moveToTopOauthPage()
    }
}
