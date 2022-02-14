//
//  UILabel+localizedKey.swift
//  QiitaClientApp
//
//  Created by 高橋拓也 on 2022/02/14.
//

import UIKit

extension UILabel {
    @IBInspectable
    private var localizedKey: String? {
        get { fatalError("only set this value") }
        set {
            if let newValue = newValue {
                text = newValue.localized()
            }
        }
    }
}
