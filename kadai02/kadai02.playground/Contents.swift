import UIKit

enum Hand: Int {
    case rock = 0
    case scissors = 1
    case paper = 2
}

enum Result: String {
    case win = "win!"
    case draw = "draw"
    case lose = "lose"
}

func janken(you: Hand) -> Void {
    guard let cp = Hand(rawValue: Int.random(in: 0...2)) else {
        return
    }
    let result: Result
    print(you.rawValue)
    print(cp.rawValue)
    if you == cp {
        result = .draw
    } else if (you.rawValue == cp.rawValue - 1) || (you.rawValue == cp.rawValue + 2) {
        print("win")
        result = .win
    }else {
        result = .lose
    }
    print("cp: \(cp). You \(result.rawValue)")
}

janken(you: .rock)
janken(you: .scissors)
janken(you: .paper)
