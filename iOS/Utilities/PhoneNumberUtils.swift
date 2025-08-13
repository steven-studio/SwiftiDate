
//
//  PhoneNumberUtils.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/8/8.
//

import Foundation

struct PhoneNumberUtils {
    
    /// Normalizes a phone number into full international format: ⁠ +<countryCode><number> ⁠
    /// - Parameters:
    ///   - countryCode: Example: "+886", "+91", "+1"
    ///   - phoneNumber: Local number entered by the user
    /// - Returns: Normalized full phone number string
    static func normalizedFullPhone(_ countryCode: String, _ phoneNumber: String) -> String {
        var formatted = phoneNumber
        
        // 1️⃣ Remove spaces, hyphens, parentheses, dots
        let unwantedChars = CharacterSet(charactersIn: " -().")
        formatted = formatted.components(separatedBy: unwantedChars).joined()
        
        // 2️⃣ Remove any non-digit characters
        formatted = formatted.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        // 3️⃣ Handle special cases where local numbers start with zero
        // Taiwan (+886), Italy (+39), UK (+44), Japan (+81) etc.
        if startsWithTrunkZero(countryCode) && formatted.hasPrefix("0") {
            formatted.removeFirst()
        }
        
        // 4️⃣ Build final normalized number
        return "\(countryCode)\(formatted)"
    }
    
    /// Checks if the given country code usually has trunk zeros in local format
    private static func startsWithTrunkZero(_ countryCode: String) -> Bool {
        let codesWithLeadingZero = ["+886", "+39", "+44", "+81", "+82", "+90", "+91", "+212", "+216"]
        return codesWithLeadingZero.contains(countryCode)
    }
    
    /// Validates if a phone number looks valid (basic check, not full E.164)
    static func isValidPhoneNumber(_ number: String) -> Bool {
        let digitsOnly = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return digitsOnly.count >= 6 && digitsOnly.count <= 15
    }
}

func friendlyMessage(_ error: AuthError) -> String {
    switch error {
    case .invalidPhoneFormat:        return "電話格式不正確，請再確認一次。"
    case .smsNotSent:                return "驗證碼傳送失敗，請稍後再試。"
    case .invalidOTP:                return "驗證碼錯誤，請重新輸入。"
    case .sessionExpired:            return "驗證逾時，請重新發送驗證碼。"
    case .credentialAlreadyInUse:    return "此電話號碼已被使用。"
    case .network:                   return "網路連線異常，請稍後再試。"
    case .rateLimited:               return "請求太頻繁，稍候再試。"
    case .unknown(let msg):          return "發生未預期錯誤：\(msg)"
    }
}
