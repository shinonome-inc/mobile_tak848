//
//  TextViewController.swift
//  QiitaClientApp
//
//  Created by Takuya Takahashi on 2022/03/21.
//

import UIKit

class TextNavigationController: UINavigationController {}

class TextViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    var textViewMode: TextViewMode?
    let textViewInset: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.textContainerInset = UIEdgeInsets(top: textViewInset, left: textViewInset, bottom: textViewInset, right: textViewInset)
        textView.sizeToFit()
        textView.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        guard let mode = textViewMode,
              let fileURL = Bundle.main.url(forResource: mode.fileName, withExtension: "txt"),
              let fileContents = try? String(contentsOf: fileURL)
        else {
            return
        }
        textView.text = fileContents.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func configure(textViewMode mode: TextViewMode) {
        textViewMode = mode
        title = mode.displayString
    }
}
