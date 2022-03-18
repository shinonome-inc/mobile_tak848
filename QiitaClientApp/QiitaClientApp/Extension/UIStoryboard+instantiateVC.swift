//
//  UIStoryboard+instantiateVC.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/18.
//

import UIKit

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>(with viewControllerType: T.Type) -> T? {
        instantiateViewController(withIdentifier: T.identifier) as? T
    }
}
