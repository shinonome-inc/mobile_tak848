//
//  UINib+fileCache.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/18.
//

import UIKit

extension UINib {
    static let nibCache = NSCache<NSString, UINib>()

    static func fileExists(nibName: String) -> Bool {
        Bundle.main.path(forResource: nibName, ofType: "nib") != nil
    }

    static func cachedNib(nibName: String) -> UINib {
        if let nib = nibCache.object(forKey: nibName as NSString) {
            return nib
        } else {
            let nib = UINib(nibName: nibName, bundle: nil)
            nibCache.setObject(nib, forKey: nibName as NSString)
            return nib
        }
    }
}
