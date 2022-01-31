import UIKit

enum Hand: Int {
    case rock
    case scissors
    case paper
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
    if you == cp {
        result = .draw
    } else if (you == .rock && cp == .scissors) || (you == .scissors && cp == .paper) || (you == .paper && cp == .rock) {
        result = .win
    } else {
        result = .lose
    }
    print("cp: \(cp). You \(result.rawValue)")
}

janken(you: .rock)
janken(you: .scissors)
janken(you: .paper)
