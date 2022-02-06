//
//  ViewController.swift
//  kadai07
//
//  Created by 高橋拓也 on 2022/02/05.
//

import UIKit

class ViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == CustomViewController.identifier,
           let vc = segue.destination as? CustomViewController {
            vc.delegate = self
        }
    }

    @IBAction func onTapOpenButton(_ sender: UIButton) {
        performSegue(withIdentifier: CustomViewController.identifier, sender: nil)
    }
    
}

extension ViewController: CloseButtonDelegate {
    func tapCloseButton(vc: UIViewController){
        vc.dismiss(animated: false)
    }
}
