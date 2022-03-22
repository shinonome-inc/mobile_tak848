//
//  SettingsViewController.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/14.
//

import UIKit
import WebKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        settingsTableView.reloadData()
    }

    func moveToTopPage() {
        if let tabBarController = tabBarController,
           let topLoginViewController = storyboard!.instantiateViewController(with: TopLoginViewController.self)
        {
            tabBarController.dismiss(animated: true)
            present(topLoginViewController, animated: true)
            topLoginViewController.performSegue(segue: .toOauthViewController, sender: nil)
        }
    }

    func discardTokenAndMoveToTopOauthPage() {
        QiitaAccessToken().remove()
        if let tabBarController = tabBarController,
           let topLoginViewController = storyboard!.instantiateViewController(with: TopLoginViewController.self)
        {
            WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: Date(timeIntervalSince1970: 0), completionHandler: {})
            tabBarController.dismiss(animated: true)
            present(topLoginViewController, animated: true)
        }
    }
    
    @IBAction func onTapLogout(_ sender: Any) {}
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SettingsTableSection(rawValue: section)?.cellCount ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        SettingsTableSection.allCases.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "app information".localized()
        } else if section == 1 {
            return "others".localized()
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.tintColor = UIColor(named: "PrimaryBlack")
        var content = UIListContentConfiguration.valueCell()
        content.textProperties.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        content.secondaryTextProperties.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        let tableSection = SettingsTableSection(rawValue: indexPath.section)
        switch tableSection {
        case .appInformation:
            let appInfoCell = SettingsAppInfoCell(rawValue: indexPath.row)
            content.text = appInfoCell?.titleString
            let disclosureImage = #imageLiteral(resourceName: "Arrow").withRenderingMode(.alwaysTemplate)
            let disclosureImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: disclosureImage.size.width, height: disclosureImage.size.height))
            disclosureImageView.image = disclosureImage
            switch appInfoCell {
            case .privacyPolicy:
                cell.accessoryType = .disclosureIndicator
                cell.accessoryView = disclosureImageView
            case .termsOfService:
                cell.accessoryType = .disclosureIndicator
                cell.accessoryView = disclosureImageView
            case .appVersion:
                let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
                content.secondaryText = "v\(version!)"
                cell.selectionStyle = .none
                content.secondaryTextProperties.color = UIColor(named: "PrimaryBlack") ?? #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            case .none:
                return UITableViewCell()
            }
        case .others:
            let othersCell = SettingsOthersCell(rawValue: indexPath.row)
            content.text = othersCell?.titleString
            switch othersCell {
            case .logoutOrLogin:
                break
            case .none:
                return UITableViewCell()
            }
        case .none:
            return UITableViewCell()
        }
        
        cell.contentConfiguration = content
        return cell
    }

    // swiftlint:disable cyclomatic_complexity
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tableSection = SettingsTableSection(rawValue: indexPath.section)
        switch tableSection {
        case .appInformation:
            let appInfoCell = SettingsAppInfoCell(rawValue: indexPath.row)
            guard let storyboard = storyboard,
                  let textNavigationController = storyboard.instantiateViewController(with: TextNavigationController.self),
                  let textViewController = textNavigationController.topViewController as? TextViewController
            else {
                return
            }
            switch appInfoCell {
            case .privacyPolicy:
                textViewController.configure(textViewMode: .privacyPolicy)
                present(textNavigationController, animated: true)
            case .termsOfService:
                textViewController.configure(textViewMode: .termsOfService)
                present(textNavigationController, animated: true)
            case .appVersion:
                break
            case .none:
                break
            }
        case .others:
            let othersCell = SettingsOthersCell(rawValue: indexPath.row)
            switch othersCell {
            case .logoutOrLogin:
                if QiitaAccessToken().isExist {
                    discardTokenAndMoveToTopOauthPage()
                } else {
                    moveToTopPage()
                }
            case .none:
                break
            }
        case .none:
            break
        }
    }
}
