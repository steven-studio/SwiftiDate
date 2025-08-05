//
//  PhoneCountry.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/8/5.
//

// PhoneCountry.swift
enum PhoneCountry: String, CaseIterable {
    case taiwan = "+886"
    case china = "+86"
    case hongkong = "+852"
    case macao = "+853"
    case us = "+1"
    case singapore = "+65"
    case japan = "+81"
    case australia = "+61"
    case uk = "+44"
    case italy = "+39"
    case newZealand = "+64"
    case korea = "+82"

    var regex: String {
        switch self {
        case .taiwan: return "^09[0-9]{8}$"
        case .china: return "^[1][3-9][0-9]{9}$"
        case .hongkong, .macao: return "^[0-9]{8}$"
        case .us: return "^[2-9][0-9]{9}$"
        case .singapore: return "^[689][0-9]{7}$"
        case .japan: return "^[789]0[0-9]{8}$"
        case .australia: return "^[45][0-9]{8}$"
        case .uk: return "^[1-9][0-9]{9}$"
        case .italy: return "^[0-9]{8,10}$"
        case .newZealand: return "^[278][0-9]{7,9}$"
        case .korea: return "^01[016789][0-9]{7,8}$"
        }
    }
    
    static func from(code: String) -> PhoneCountry? {
        return PhoneCountry.allCases.first(where: { $0.rawValue == code })
    }
}
