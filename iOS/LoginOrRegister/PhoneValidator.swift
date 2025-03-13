//
//  PhoneValidator.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/2/27.
//

import Foundation

struct PhoneValidator {
    /// 檢查台灣號碼
    static func isTaiwanNumber(_ phone: String) -> Bool {
        // 09 開頭 + 8 碼 (總共10)；或 9 開頭 + 8 碼 (總共9)
        let pattern = "^(09\\d{8}|9\\d{8})$"
        return phone.range(of: pattern, options: .regularExpression) != nil
    }

    /// 檢查大陸號碼
    static func isMainlandChinaNumber(_ phone: String) -> Bool {
        // 11 位數字
        let pattern = "^\\d{11}$"
        return phone.range(of: pattern, options: .regularExpression) != nil
    }
    
    // ... 如果之後還有香港、澳門、新加坡等都可以加
    // static func isHongKongNumber(_ phone: String) -> Bool { ... }
}
