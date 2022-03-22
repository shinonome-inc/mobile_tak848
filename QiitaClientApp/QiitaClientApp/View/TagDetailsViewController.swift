//
//  TagDetailsViewController.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/09.
//

import Alamofire
import UIKit

class TagDetailsViewController: BaseArticlesViewController {
    var tagId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = tagId ?? ""
    }

    override func setUpTableView() {
        super.setUpTableView()
        setUpPostedArticlesSectionHeader()
        articlesTableView.sectionHeaderTopPadding = 0
    }

    override func fetchAndSetArticles(refreshAll: Bool = false) {
        settingsBeforeFetch(refreshAll: refreshAll)
        guard let tagId = tagId else {
            return
        }
        AF.request(TagArticlesGetRequest(tagId: tagId, page: page, perPage: articlesPerPage))
            .responseDecodable(of: TagArticlesGetRequest.Response.self) { response in
                self.setArticlesFromResponse(refreshAll: refreshAll, response: response)
            }
    }

    func configure(tagId id: String) {
        tagId = id
    }
}

extension TagDetailsViewController {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withClass: PostedArticlesLabel.self) else {
            return PostedArticlesLabel()
        }
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let header = tableView.dequeueReusableHeaderFooterView(withClass: PostedArticlesLabel.self) else {
            return 0
        }
        return header.frame.height
    }
}
