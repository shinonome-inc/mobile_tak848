//
//  String+localize.swift
//  QiitaClientApp
//
//  Created by 高橋拓也 on 2022/02/22.
//

import Foundation

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
