//
//  ViewController.swift
//  kadai03
//
//  Created by Kaoru Matarai on 2020/08/18.
//  Copyright © 2020 shinonome, inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var inputYearField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func isLeap(year: Int) -> Bool {
        if year % 400 == 0 {
            return true
        } else if year % 100 == 0 {
            return false
        } else if year % 4 == 0 {
            return true
        } else {
            return false
        }
    }
    
    @IBAction func runButton(_ sender: Any) {
        if let inputString = inputYearField.text, let inputYear = Int(inputString) {
            if isLeap(year: inputYear){
                infoLabel.text = "\(inputYear) is leap year"
            } else {
                infoLabel.text = "\(inputYear) is not leap year"
            }
        } else {
            infoLabel.text = "Input correct year."
        }
    }
}

