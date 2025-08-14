//
//  PhoneValidator.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/2/27.
//

import Foundation

//struct PhoneValidator {
//    static func validate(countryCode: String, phoneNumber: String) -> Bool {
//        guard let country = PhoneCountry.from(code: countryCode) else { return false }
//        return NSPredicate(format: "SELF MATCHES %@", country.regex).evaluate(with: phoneNumber)
//    }
//}
struct PhoneValidator {
    static func validate(countryCode: String, phoneNumber: String) -> Bool {
        // Get the first matching country for the dialing code
        guard let country = PhoneCountry.fromDialingCode(countryCode).first else {
            return false
        }
        
        return NSPredicate(format: "SELF MATCHES %@", country.regex)
            .evaluate(with: phoneNumber)
    }
}
