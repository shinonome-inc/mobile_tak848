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
    
    let refreshControl = UIRefreshControl()
    var tags: [QiitaTag]?
    var page = 1
    var loading = false
    var nextTagId: String?
    
    var viewWidth: CGFloat {
        view.safeAreaLayoutGuide.layoutFrame.width
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        fetchAndSetTags(refreshAll: true)
    }

    func fetchAndSetTags(refreshAll: Bool = false) {
        if refreshAll {
            page = 1
            tags = nil
            tagsCollectionView?.reloadData()
        }
        loading = true
        setUpCollectionView()
        AF.request(TagsGetRequest(page: page))
            .responseDecodable(of: TagsGetRequest.Response.self) { response in
                switch response.result {
                case let .success(tags):
                    self.page += 1
                    if refreshAll || self.tags == nil {
                        self.tags = tags
                    } else {
                        self.tags?.append(contentsOf: tags)
                    }
                case .failure:
                    self.tags = nil
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
        if !loading {
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
        tagsCollectionView?.reloadData()
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
