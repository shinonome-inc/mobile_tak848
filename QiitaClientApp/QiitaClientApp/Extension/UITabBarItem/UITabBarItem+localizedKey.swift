//
//  UITabBarItem+localizedKey.swift
//  QiitaClientApp
//
//  Created by 高橋拓也 on 2022/02/14.
//

import UIKit

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
