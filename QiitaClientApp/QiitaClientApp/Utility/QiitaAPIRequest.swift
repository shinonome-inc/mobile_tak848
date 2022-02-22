//
//  QiitaAPIRequest.swift
//  QiitaClientApp
//
//  Created by 高橋拓也 on 2022/02/22.
//

import Alamofire
import Foundation

protocol QiitaAPIRequest: URLRequestConvertible {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters { get }
}

extension QiitaAPIRequest {
    var baseURL: URL { URL(string: "https://qiita.com/api/v2")! }
    public func asURLRequest() throws -> URLRequest {
        let request = URLRequest(url: baseURL.appendingPathComponent(path))
        switch method {
        case .post, .put:
            return try JSONEncoding.default.encode(request, with: parameters)
        default:
            return try URLEncoding.queryString.encode(request, with: parameters)
        }
    }
}
