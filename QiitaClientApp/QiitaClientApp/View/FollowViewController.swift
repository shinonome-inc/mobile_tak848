//
//  FollowViewController.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/17.
//

import Alamofire
import UIKit

protocol FollowViewControllerDelegate: AnyObject {
    func pushUserPageViewController(user: QiitaUser)
}

class FollowViewController: UIViewController {
    @IBOutlet weak var usersCollectionView: UICollectionView!
    var networkErrorView: NetworkErrorView?
    
    var displayingNetworkError = false
    
    let refreshControl = UIRefreshControl()
    var targetUser: QiitaUser?
    var users: [QiitaUser]?
    var followMode: FollowMode?
    var page = 1
    let usersPerPage = 30
    let maxPage = 100
    var loading = false
    // これ以上記事が無いorページネーションの最大ページへの到達検知フラグ
    var paginationFinished = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonDisplayMode = .minimal
        title = followMode?.rawValue
        if let targetUser = targetUser, let followMode = followMode {
            navigationItem.backButtonTitle = "\(targetUser.displayName) - \(followMode.rawValue)"
        }
        setUpCollectionView()
        fetchAndSetUsers(refreshAll: true)
        networkErrorView = Bundle.main.loadNibNamed(NetworkErrorView.identifier, owner: self)!.first! as? NetworkErrorView
        networkErrorView?.delegate = self
    }

    func configure(targetUser user: QiitaUser, followMode mode: FollowMode) {
        targetUser = user
        followMode = mode
    }

    func setUpCollectionView() {
        usersCollectionView.delegate = self
        usersCollectionView.dataSource = self
        usersCollectionView.registerCustomCell(UserCollectionCell.self)
        usersCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        let compositionalLayout = UICollectionViewCompositionalLayout { (_: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let inset: CGFloat = 16
            let minimumUserCollectionCellHeight: CGFloat = 68
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(minimumUserCollectionCellHeight))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: inset, bottom: .zero, trailing: inset)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = inset
            section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: .zero, bottom: inset, trailing: .zero)
            return section
        }
        usersCollectionView.collectionViewLayout = compositionalLayout
    }

    func fetchAndSetUsers(refreshAll: Bool = false) {
        guard let targetUser = targetUser,
              let followMode = followMode
        else {
            return
        }
        if refreshAll {
            page = 1
            users = nil
            usersCollectionView.reloadData()
            paginationFinished = false
        }
        loading = true
        setUpCollectionView()
        AF.request(FollowUsersGetRequest(page: page, perPage: usersPerPage, targetUser: targetUser, followMode: followMode))
            .responseDecodable(of: FollowUsersGetRequest.Response.self) { response in
                switch response.result {
                case let .success(users):
                    self.page += 1
                    if refreshAll || self.users == nil {
                        self.users = users
                    } else {
                        self.users?.append(contentsOf: users)
                    }
                    if users.count < self.usersPerPage || self.page > self.maxPage {
                        self.paginationFinished = true
                    }
                    self.removeNetworkErrorSubView()
                case .failure:
                    self.users = nil
                    self.addNetworkErrorSubView()
                }
                self.loading = false
                self.usersCollectionView.reloadData()
                self.usersCollectionView.collectionViewLayout.invalidateLayout()
                self.usersCollectionView.layoutIfNeeded()
            }
    }

    @objc func refresh(_ sender: UIRefreshControl) {
        fetchAndSetUsers(refreshAll: true)
        refreshControl.endRefreshing()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !loading, !paginationFinished {
            let currentOffsetY = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
            let distanceToBottom = maximumOffset - currentOffsetY
            let nextLoadingDistance: CGFloat = 600
            if distanceToBottom < nextLoadingDistance {
                fetchAndSetUsers()
            }
        }
    }

    func addNetworkErrorSubView() {
        guard let networkErrorView = networkErrorView, !displayingNetworkError else {
            return
        }
        displayingNetworkError = true
        view.addSubview(networkErrorView)
        networkErrorView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        safeArea.topAnchor.constraint(equalToSystemSpacingBelow: networkErrorView.topAnchor, multiplier: 0).isActive = true
        safeArea.leadingAnchor.constraint(equalToSystemSpacingAfter: networkErrorView.leadingAnchor, multiplier: 0).isActive = true
        safeArea.trailingAnchor.constraint(equalToSystemSpacingAfter: networkErrorView.trailingAnchor, multiplier: 0).isActive = true
        safeArea.bottomAnchor.constraint(equalToSystemSpacingBelow: networkErrorView.bottomAnchor, multiplier: 0).isActive = true
    }

    func removeNetworkErrorSubView() {
        guard let networkErrorView = networkErrorView, displayingNetworkError else {
            return
        }
        networkErrorView.removeFromSuperview()
        displayingNetworkError = false
    }
}

extension FollowViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let users = users else {
            return 0
        }
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCustomCell(with: UserCollectionCell.self, indexPath: indexPath), let users = users else {
            return UserCollectionCell()
        }
        cell.configure(userData: users[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let storyboard = storyboard,
           let userPageViewController = storyboard.instantiateViewController(with: UserPageViewController.self),
           let navigationController = navigationController,
           let users = users
        {
            userPageViewController.configure(user: users[indexPath.row])
            navigationController.pushViewController(userPageViewController, animated: true)
        }
    }
}

extension FollowViewController: NetworkErrorViewProtocol {
    func reloadFromErrorButton() {
        if !loading {
            fetchAndSetUsers(refreshAll: true)
        }
    }
}
