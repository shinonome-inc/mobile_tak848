import UIKit

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

print(isLeap(year: 2000)) // true
print(isLeap(year: 1209)) // false
print(isLeap(year: 1980)) // true
print(isLeap(year: 1790)) // false
print(isLeap(year: 1993)) // false
