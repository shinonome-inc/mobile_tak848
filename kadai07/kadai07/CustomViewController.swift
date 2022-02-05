//
//  CustomViewController.swift
//  kadai07
//
//  Created by 高橋拓也 on 2022/02/05.
//

import UIKit

class CustomViewController: UIViewController {
    
    static let identifier = "showCustomView"
    var delegate: CloseButtonDelegate?
    
    @IBAction func onTapCloseButton(_ sender: UIButton) {
        delegate?.tapCloseButton(vc: self)
    }
    
}
