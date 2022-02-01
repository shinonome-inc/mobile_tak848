//
//  Int+isLeapYear.swift
//  kadai03
//
//  Created by 高橋拓也 on 2022/01/31.
//  Copyright © 2022 shinonome, inc. All rights reserved.
//

extension Int {
    var isLeapYear: Bool {
        return (self % 4 == 0 && self % 100 != 0) || self % 400 == 0
    }
}
