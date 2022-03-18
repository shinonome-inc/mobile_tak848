//
//  AccessTokenGetRequest.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/18.
//

import Alamofire
import Foundation

struct AccessTokenGetRequest: QiitaAPIRequest {
    public typealias Response = QiitaToken
    var path: String { "/access_tokens" }
    let method = HTTPMethod.post

    let code: String
    var clientId: String
    var clientSecret: String

    var parameters: Parameters {
        [
            "client_id": String(clientId),
            "client_secret": String(clientSecret),
            "code": String(code)
        ]
    }
}
