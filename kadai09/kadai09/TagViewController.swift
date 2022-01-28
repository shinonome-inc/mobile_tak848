//
//  TagViewController.swift
//  kadai07
//
//  Created by Sakai Syunya on 2022/01/13.
//

import UIKit
//↓Alamofireをimportしてください

//↑Alamofireをimportしてください

class TagViewController: UIViewController {

    @IBOutlet var tagCollectionView: UICollectionView!
    var viewWidth: CGFloat {
        return view.frame.width
    }
    let margin: CGFloat = 16
    let cellWidth: CGFloat = 162
    let cellHeight: CGFloat = 138
    //↓追加で変数を定義してください
    
    //↑追加で変数を定義してください
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        //↓QiitaAPIのリクエストやdelegateの設定を行なってください
        
        //↑QiitaAPIのリクエストやdelegateの設定を行なってください
    }
    
    //↓この部分の実装に関しては、課題資料の方に載っているYoutubeのリンクから飛べる動画を確認してください
    func calcItemsPerRows() -> Int {
        let maxItemsPerRows = (viewWidth + margin) / (cellWidth + margin)
        let minItemsPerRows = (viewWidth - cellWidth) / (cellWidth + margin)
        let hasDecimal = (Int(minItemsPerRows + 1) == Int(maxItemsPerRows))
        let itemsperRows = hasDecimal ? Int(maxItemsPerRows) : Int(minItemsPerRows)
        return itemsperRows
    }
            
    func calcLeftAndRightInsets(itemsPerRows: Int) -> CGFloat {
        let inset = 0.5 * (viewWidth + margin - CGFloat(itemsPerRows) * (cellWidth + margin))
        return inset
    }
    //↑この部分の実装に関しては、課題資料の方に載っているYoutubeのリンクから飛べる動画を確認してください
}

extension TagViewController: UICollectionViewDelegateFlowLayout {
    
    //↓この部分の実装に関しては、課題資料の方に載っているYoutubeのリンクから飛べる動画を確認してください
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let itemsPerRow = calcItemsPerRows()
        let inset = calcLeftAndRightInsets(itemsPerRows: itemsPerRow)
            return UIEdgeInsets(top: 16, left: inset, bottom: 16, right: inset)
        }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    //↑この部分の実装に関しては、課題資料の方に載っているYoutubeのリンクから飛べる動画を確認してください
}

extension TagViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //↓取得してきたタグの件数に変更してください
        return 4
        //↑取得してきたタグの件数に変更してください
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as? CollectionViewCellController else {
            return UICollectionViewCell()
        }
        //↓関数で定義したCollectionViewのCellの設定を実行してください
        
        //↑関数で定義したCollectionViewのCellの設定を実行してください
        cell.contentView.layer.borderColor = (UIColor {_ in return #colorLiteral(red: 0.9022639394, green: 0.9022851586, blue: 0.9022737145, alpha: 1)}).cgColor
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layoutIfNeeded()
        return cell
    }
}

//↓作成したErrorView用のdelegateの中身となる関数を設定してください

//↑作成したErrorView用のdelegateの中身となる関数を設定してください
