import UIKit

enum Hand: Int {
    case rock
    case scissors
    case paper
}

enum Result {
    case win
    case draw
    case lose
    
    var feedback: String {
        switch self {
        case .win: return "win!"
        case .draw: return "draw"
        case .lose: return "lose"
        }
    }
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
    print("cp: \(cp). You \(result.feedback)")
}

janken(you: .rock)
janken(you: .scissors)
janken(you: .paper)
