//
//  AccessTokenDeactivateRequest.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/18.
//

import Alamofire
import Foundation

struct AccessTokenDeactivateRequest: QiitaAPIRequest {
    var parameters: Parameters { [:] }
    
    var path: String { "/access_tokens/\(accessToken)" }
    var accessToken: String
    let method = HTTPMethod.delete
}
