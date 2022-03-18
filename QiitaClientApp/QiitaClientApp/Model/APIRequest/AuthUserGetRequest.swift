//
//  AuthUserGetRequest.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/18.
//

import Alamofire
import Foundation

struct AuthUserGetRequest: QiitaAPIRequest {
    public typealias Response = QiitaUser
    var path: String { "/authenticated_user" }
    let method = HTTPMethod.get
    var parameters: Parameters { [:] }
}
