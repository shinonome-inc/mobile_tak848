//
//  QiitaAccessToken.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/17.
//

import Alamofire
import Foundation
import KeychainAccess

struct QiitaAccessToken {
    var userDefaultsLoggedInKey: String { "isLoggedIn" }
    var keychainAccessTokenKey: String { "qiitaAccessToken" }
    var clientId: String { ProcessInfo.processInfo.environment["QIITA_APPLICATION_CLIENT_ID"] ?? "" }
    var clientSecret: String { ProcessInfo.processInfo.environment["QIITA_APPLICATION_CLIENT_SECRET"] ?? "" }
    var callbackScheme: String { ProcessInfo.processInfo.environment["APPLICATION_URL_SCHEME"] ?? "" }
    var callbackHost: String { ProcessInfo.processInfo.environment["APPLICATION_QIITA_CALLBACK_HOST"] ?? "" }
    var isExist: Bool {
        get {
            UserDefaults.standard.bool(forKey: userDefaultsLoggedInKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userDefaultsLoggedInKey)
        }
    }

    var value: String {
        get {
            Keychain()[keychainAccessTokenKey] ?? ""
        }
        set {
            isExist = true
            Keychain()[keychainAccessTokenKey] = newValue
        }
    }

    func remove() {
        let deleteValue = value
        UserDefaults.standard.set(false, forKey: userDefaultsLoggedInKey)
        guard deleteValue != "" else {
            return
        }
        AF.request(AccessTokenDeactivateRequest(accessToken: deleteValue))
            .responseString { response in
                switch response.response?.statusCode {
                case 204?:
                    Keychain()[self.keychainAccessTokenKey] = nil
                default:
                    print("Tokenの無効化に失敗しました")
                }
            }
    }
}

struct AccessTokenDeactivateRequest: QiitaAPIRequest {
    var parameters: Parameters { [:] }
    
    var path: String { "/access_tokens/\(accessToken)" }
    var accessToken: String
    let method = HTTPMethod.delete
}
