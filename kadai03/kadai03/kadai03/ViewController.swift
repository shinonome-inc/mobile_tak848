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
    
    @IBAction func runButton(_ sender: Any) {
        if let inputString = inputYearField.text, let inputNumber = Int(inputString) {
            if inputNumber.isLeapYear {
                infoLabel.text = "\(inputString) is leap year"
            } else {
                infoLabel.text = "\(inputString) is not leap year"
            }
        } else {
            infoLabel.text = "Input correct year."
        }
    }
}

