//
//  TextViewMode.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/21.
//

import Foundation

enum TextViewMode {
    case privacyPolicy
    case termsOfService
    var fileName: String {
        switch self {
        case .privacyPolicy: return "PrivacyPolicy"
        case .termsOfService: return "TermsOfService"
        }
    }

    var displayString: String {
        switch self {
        case .privacyPolicy: return "privacy policy".localized()!
        case .termsOfService: return "terms of service".localized()!
        }
    }
}
