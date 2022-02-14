//
//  SegueHandlerType.swift
//  QiitaClientApp
//
//  Created by 高橋拓也 on 2022/02/13.
//

import UIKit

protocol SegueType {
    var rawValue: String { get }
}

extension UIViewController {
    func performSegue(segue: Segue, sender: AnyObject?) {
        performSegue(withIdentifier: segue.rawValue, sender: sender)
    }
}
