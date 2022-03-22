//
//  SettingsTableData.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/21.
//

import Foundation

enum SettingsTableSection: Int, CaseIterable {
    case appInformation
    case others
    var cellCount: Int {
        switch self {
        case .appInformation:
            return SettingsAppInfoCell.allCases.count
        case .others:
            return SettingsOthersCell.allCases.count
        }
    }
}

enum SettingsAppInfoCell: Int, CaseIterable {
    case privacyPolicy
    case termsOfService
    case appVersion
    var titleString: String {
        switch self {
        case .privacyPolicy:
            return "privacy policy".localized()!
        case .termsOfService:
            return "terms of service".localized()!
        case .appVersion:
            return "app version".localized()!
        }
    }
}

enum SettingsOthersCell: Int, CaseIterable {
    case logoutOrLogin
    var titleString: String {
        switch self {
        case .logoutOrLogin:
            if QiitaAccessToken().isExist {
                return "do logout".localized()!
            } else {
                return "do login".localized()!
            }
        }
    }
}
