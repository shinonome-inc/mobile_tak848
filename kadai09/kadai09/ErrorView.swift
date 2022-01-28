//
//  CustomView.swift
//  kadai07
//
//  Created by 吉田周平 on 2021/02/04.
//

import UIKit

class ErrorView: UIView {
    
    //↓delegateの処理先を受け取るための変数を定義してください
    
    //↑delegateの処理先を受け取るための変数を定義してください
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    init() {
        super.init(frame: .zero)
            
        let view = UINib(nibName: "ErrorView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        addSubview(view)
    }
    
    @IBAction func reloadButton(_ sender: Any) {
        //↓delegateの処理先をアンラップし、関数を実行してください
        
        //↑delegateの処理先をアンラップし、関数を実行してください
    }
}

//↓delegateの型となるprotocolを宣言してください

//↑delegateの型となるprotocolを宣言してください
