//
//  NSObjectProtocol+className.swift
//  QiitaClientApp
//
//  Created by 高橋拓也 on 2022/02/22.
//

import Foundation

extension NSObjectProtocol {
    static var className: String { String(describing: self) }
    static var identifier: String { className }
}
