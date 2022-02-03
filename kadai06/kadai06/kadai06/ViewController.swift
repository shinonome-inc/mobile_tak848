//
//  ViewController.swift
//  kadai06
//
//  Created by Kaoru Matarai on 2020/08/18.
//  Copyright © 2020 shinonome, inc. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AF.request("https://qiita.com/api/v2/items?page=1&per_page=20")
            .responseString { response in
                switch response.result {
                case .success(let value):
                    print(value)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
}

