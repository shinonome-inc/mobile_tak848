//
//  UIImageView+cacheImage.swift
//  QiitaClientApp
//
//  Created by 高橋拓也 on 2022/02/22.
//

import UIKit

extension UIImageView {
    static let imageCache = NSCache<AnyObject, AnyObject>()
    func cacheImage(imageUrl: URL) {
        let imageUrlString = imageUrl.absoluteString
        if let imageFromCache = UIImageView.imageCache.object(forKey: imageUrlString as AnyObject) as? UIImage {
            image = imageFromCache
            return
        }
        URLSession.shared.dataTask(with: imageUrl) { data, _, error in
            if error != nil {
                return
            }
            DispatchQueue.main.async {
                guard let imageToCache = UIImage(data: data!) else {
                    return
                }
                self.image = imageToCache
                UIImageView.imageCache.setObject(imageToCache, forKey: imageUrlString as AnyObject)
            }
        }.resume()
    }
}
