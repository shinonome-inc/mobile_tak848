//
//  LocalizationExtensions.swift
//  QiitaClientApp
//
//  Created by 高橋拓也 on 2022/02/15.
//

import UIKit

extension String {
    private static let localizedEmptyKey = "##not exists##"
    func localized() -> String? {
        let string = NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: String.localizedEmptyKey, comment: "")
        if string == String.localizedEmptyKey {
            fatalError("not exists localized key")
        }
        return string
    }
}

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
