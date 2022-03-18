//
//  LocalizationExtensions.swift
//  QiitaClientApp
//
//  Created by 高橋拓也 on 2022/02/15.
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

extension UIButton {
    @IBInspectable
    private var localizedKey: String? {
        get { fatalError("only set this value") }
        set {
            if let newValue = newValue {
                setTitle(newValue.localized(), for: .normal)
            }
        }
    }
}

extension UITabBarItem {
    @IBInspectable
    private var localizedKey: String? {
        get { fatalError("only set this value") }
        set {
            if let newValue = newValue {
                title = newValue.localized()
            }
        }
    }
}
