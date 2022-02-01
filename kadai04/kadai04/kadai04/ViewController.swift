//
//  ViewController.swift
//  kadai04
//
//  Created by Kaoru Matarai on 2020/08/18.
//  Copyright © 2020 shinonome, inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let shuffleInterval: Double = 1 / 120
    let jankenInterval: Double = 1
    
    @IBOutlet weak var enemyHandImageView: UIImageView!
    @IBOutlet weak var jankenInfoLabel: UILabel!
    @IBOutlet var handButtons: [UIButton]!
    
    var timer: Timer?
    var cpHand: Hand?
    
    enum Hand: Int {
        case rock
        case scissors
        case paper
        var image: UIImage? {
            switch self {
            case .rock: return UIImage(named: "rock-hand")
            case .scissors: return UIImage(named: "scissors-hand")
            case .paper: return UIImage(named: "paper-hand")
            }
        }
    }
    
    enum Result: Int {
        case draw
        case lose
        case win
        
        var feedback: String {
            switch self {
            case .draw: return "draw"
            case .lose: return "lose"
            case .win: return "win!"
            }
        }
    }
    struct Janken {
        var myHand: Hand
        var cpHand: Hand
        var result: Result {
            return Result(rawValue: (myHand.rawValue - cpHand.rawValue + 3) % 3)!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: self.shuffleInterval, target: self, selector: #selector(self.shuffleCpHand(_:)), userInfo: nil, repeats: true)
    }
    
    @objc func shuffleCpHand(_ sender: Timer) {
        guard let cp = Hand(rawValue: Int.random(in: 0...2)), let cpImage = cp.image else {
            return
        }
        cpHand = cp
        enemyHandImageView.image = cpImage
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        for button in handButtons {
            button.isEnabled = false
        }
        timer?.invalidate()
        guard let button = sender as? UIButton,
              let myHand = Hand(rawValue: button.tag),
              let unwrappedCpHand = cpHand
        else {
            return
        }
        
        let janken = Janken(myHand: myHand, cpHand: unwrappedCpHand)
        jankenInfoLabel.text = "you \(janken.result.feedback)"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + jankenInterval) {
            for button in self.handButtons {
                button.isEnabled = true
            }
            self.jankenInfoLabel.text = "choose your hand"
            self.timer = Timer.scheduledTimer(timeInterval: self.shuffleInterval, target: self, selector: #selector(self.shuffleCpHand(_:)), userInfo: nil, repeats: true)
        }
    }
}

