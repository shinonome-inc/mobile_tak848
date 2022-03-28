//
//  TagsViewController.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/07.
//

import Alamofire
import UIKit

struct CollectionSize {
    static let margin: CGFloat = 16
    static let cellWidth: CGFloat = 162
    static let cellHeight: CGFloat = 138
    var viewWidth: CGFloat
    
    var itemsPerRows: Int {
        let maxItemsPerRows = (viewWidth + Self.margin) / (Self.cellWidth + Self.margin)
        let minItemsPerRows = (viewWidth - Self.cellWidth) / (Self.cellWidth + Self.margin)
        let hasDecimal = (Int(minItemsPerRows) + 1) == Int(maxItemsPerRows)
        return hasDecimal ? Int(maxItemsPerRows) : Int(minItemsPerRows)
    }

    var inset: CGFloat {
        0.5 * (viewWidth + Self.margin - CGFloat(itemsPerRows) * (Self.cellWidth + Self.margin))
    }
}

class TagsViewController: UIViewController {
    @IBOutlet weak var tagsCollectionView: UICollectionView?
    var networkErrorView: NetworkErrorView?
    
    var displayingNetworkError = false
    
    let refreshControl = UIRefreshControl()
    var tags: [QiitaTag]?
    var page = 1
    let tagsPerPage = 100
    let maxPage = 100
    var loading = false
    // これ以上記事が無いorページネーションの最大ページへの到達検知フラグ
    var paginationFinished = false
    var nextTagId: String?
    
    var viewWidth: CGFloat {
        view.safeAreaLayoutGuide.layoutFrame.width
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        fetchAndSetTags(refreshAll: true)
        navigationItem.backButtonDisplayMode = .minimal
        networkErrorView = Bundle.main.loadNibNamed(NetworkErrorView.identifier, owner: self)!.first! as? NetworkErrorView
        networkErrorView?.delegate = self
    }

    func fetchAndSetTags(refreshAll: Bool = false) {
        if refreshAll {
            page = 1
            tags = nil
            tagsCollectionView?.reloadData()
            paginationFinished = false
        }
        loading = true
        setUpCollectionView()
        AF.request(TagsGetRequest(page: page, perPage: tagsPerPage))
            .responseDecodable(of: TagsGetRequest.Response.self) { response in
                switch response.result {
                case let .success(tags):
                    self.page += 1
                    if refreshAll || self.tags == nil {
                        self.tags = tags
                    } else {
                        self.tags?.append(contentsOf: tags)
                    }
                    if tags.count < self.tagsPerPage || self.page > self.maxPage {
                        self.paginationFinished = true
                    }
                    self.removeNetworkErrorSubView()
                case .failure:
                    self.tags = nil
                    self.addNetworkErrorSubView()
                }
                self.loading = false
                self.tagsCollectionView?.reloadData()
            }
    }

    func setUpCollectionView() {
        tagsCollectionView?.delegate = self
        tagsCollectionView?.dataSource = self
        tagsCollectionView?.registerCustomCell(TagCollectionCell.self)
        tagsCollectionView?.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    }

    @objc func refresh(_ sender: UIRefreshControl) {
        fetchAndSetTags(refreshAll: true)
        refreshControl.endRefreshing()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.toTagDetailsViewController.rawValue {
            if let nextVC = segue.destination as? TagDetailsViewController {
                nextVC.configure(tagId: nextTagId ?? "")
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

extension TagsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let tags = tags else {
            return 0
        }
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCustomCell(with: TagCollectionCell.self, indexPath: indexPath), let tags = tags else {
            return TagCollectionCell()
        }
        cell.configure(qiitaTag: tags[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let tags = tags else {
            return
        }
        nextTagId = tags[indexPath.row].id
        performSegue(segue: .toTagDetailsViewController, sender: nil)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !loading, !paginationFinished {
            let currentOffsetY = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
            let distanceToBottom = maximumOffset - currentOffsetY
            let nextLoadingDistance: CGFloat = 600
            if distanceToBottom < nextLoadingDistance {
                fetchAndSetTags()
            }
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if let tags = tags,
           tags.count != 0
        {
            tagsCollectionView?.reloadData()
        }
    }
}

extension TagsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let collectionSize = CollectionSize(viewWidth: viewWidth)
        let inset = collectionSize.inset
        return UIEdgeInsets(top: CollectionSize.margin, left: inset, bottom: CollectionSize.margin, right: inset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: CollectionSize.cellWidth, height: CollectionSize.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        CollectionSize.margin
    }
}

extension TagsViewController: NetworkErrorViewProtocol {
    func reloadFromErrorButton() {
        if !loading {
            fetchAndSetTags(refreshAll: true)
        }
    }
}
