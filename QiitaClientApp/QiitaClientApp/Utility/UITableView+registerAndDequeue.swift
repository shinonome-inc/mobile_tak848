//
//  RegisterCustomCellExtensions.swift
//  QiitaClientApp
//
//  Created by 高橋拓也 on 2022/02/22.
//

import UIKit

extension UITableView {
    func registerCustomCell<T: UITableViewCell>(_ cellType: T.Type) {
        register(
            UINib(nibName: T.identifier, bundle: nil),
            forCellReuseIdentifier: T.identifier
        )
    }

    func dequeueReusableCustomCell<T: UITableViewCell>(with cellType: T.Type) -> T? {
        dequeueReusableCell(withIdentifier: T.identifier) as? T
    }
}

extension UICollectionView {
    func registerCustomCell<T: UICollectionViewCell>(_ cellType: T.Type) {
        register(
            UINib(nibName: T.identifier, bundle: nil),
            forCellWithReuseIdentifier: T.identifier
        )
    }

    func dequeueReusableCustomCell<T: UICollectionViewCell>(with cellType: T.Type,
                                                            indexPath: IndexPath) -> T?
    {
        dequeueReusableCell(withReuseIdentifier: T.identifier,
                            for: indexPath) as? T
    }
}
