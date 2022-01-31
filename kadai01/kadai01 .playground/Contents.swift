import UIKit

func isLeap(year: Int) -> Bool {
    return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
}

print(isLeap(year: 2000)) // true
print(isLeap(year: 1209)) // false
print(isLeap(year: 1980)) // true
print(isLeap(year: 1790)) // false
print(isLeap(year: 1993)) // false
