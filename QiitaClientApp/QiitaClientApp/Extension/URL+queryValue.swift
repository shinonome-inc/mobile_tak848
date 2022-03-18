//
//  URL+queryValue.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/17.
//

import Foundation

extension URL {
    func queryValueOf(_ queryParameterName: String) -> String? {
        guard let url = URLComponents(string: absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParameterName })?.value
    }
}
