//
//  UICollectionView+registerAndDequeue.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/18.
//

import UIKit

extension UICollectionView {
    func registerCustomCell<T: UICollectionViewCell>(_ cellType: T.Type) {
        register(
            UINib(nibName: T.identifier, bundle: nil),
            forCellWithReuseIdentifier: T.identifier
        )
    }

    func dequeueReusableCustomCell<T: UICollectionViewCell>(with cellType: T.Type, indexPath: IndexPath) -> T? {
        dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T
    }
}
