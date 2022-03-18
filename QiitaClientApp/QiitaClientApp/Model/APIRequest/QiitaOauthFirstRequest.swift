//
//  QiitaOauthFirstRequest.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/18.
//

import Alamofire
import Foundation

struct QiitaOauthFirstRequest: QiitaAPIRequest {
    var path: String { "/oauth/authorize" }
    let method = HTTPMethod.get
    var clientId: String {
        ProcessInfo.processInfo.environment["QIITA_APPLICATION_CLIENT_ID"] ?? ""
    }

    var scope: [String] {
        [
            "read_qiita",
            "write_qiita"
        ]
    }

    var state: String
    var parameters: Parameters {
        [
            "client_id": clientId,
            "scope": scope.joined(separator: " "),
            "state": state
        ]
    }
}
