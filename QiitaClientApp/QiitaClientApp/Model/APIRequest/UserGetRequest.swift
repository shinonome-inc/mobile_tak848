//
//  UserGetRequest.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/19.
//

import Alamofire
import Foundation

struct UserGetRequest: QiitaAPIRequest {
    public typealias Response = QiitaUser
    var path: String { "/users/\(user.id)" }
    var user: QiitaUser
    let method = HTTPMethod.get
    var parameters: Parameters { [:] }
}
