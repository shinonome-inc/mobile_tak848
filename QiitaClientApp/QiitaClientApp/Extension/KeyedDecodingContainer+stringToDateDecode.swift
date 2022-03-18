//
//  KeyedDecodingContainer+stringToDateDecode.swift
//  QiitaClientApp
//
//  Created by 高橋拓也 on 2022/02/22.
//

import Foundation

extension KeyedDecodingContainer {
    func decode(_: Date.Type, forKey key: Key) throws -> Date {
        let value = try decodeIfPresent(String.self, forKey: key)!
        return ISO8601DateFormatter().date(from: value)!
    }
}
