
//
//  PhoneNumberUtils.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/8/8.
//

struct PhoneNumberUtils {
    static func normalizedFullPhone(_ countryCode: String, _ phoneNumber: String) -> String {
        var formatted = phoneNumber.replacingOccurrences(of: " ", with: "")
        if countryCode == "+886" && formatted.hasPrefix("0") {
            formatted.removeFirst()
        }
        return "\(countryCode)\(formatted)"
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
