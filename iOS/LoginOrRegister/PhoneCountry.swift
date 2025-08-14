//
//  PhoneCountry.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/8/5.
//

// PhoneCountry.swift
//enum PhoneCountry: String, CaseIterable {
//    case taiwan = "+886"
//    case china = "+86"
//    case hongkong = "+852"
//    case macao = "+853"
//    case us = "+1"
//    case singapore = "+65"
//    case japan = "+81"
//    case australia = "+61"
//    case uk = "+44"
//    case italy = "+39"
//    case newZealand = "+64"
//    case korea = "+82"
//
//    var regex: String {
//        switch self {
//        case .taiwan: return "^09[0-9]{8}$"
//        case .china: return "^[1][3-9][0-9]{9}$"
//        case .hongkong, .macao: return "^[0-9]{8}$"
//        case .us: return "^[2-9][0-9]{9}$"
//        case .singapore: return "^[689][0-9]{7}$"
//        case .japan: return "^[789]0[0-9]{8}$"
//        case .australia: return "^[45][0-9]{8}$"
//        case .uk: return "^[1-9][0-9]{9}$"
//        case .italy: return "^[0-9]{8,10}$"
//        case .newZealand: return "^[278][0-9]{7,9}$"
//        case .korea: return "^01[016789][0-9]{7,8}$"
//        }
//    }
//
//    static func from(code: String) -> PhoneCountry? {
//        return PhoneCountry.allCases.first(where: { $0.rawValue == code })
//    }
//}
enum PhoneCountry: CaseIterable {
    case us, canada, taiwan, china, hongkong, macao, singapore, japan
    case australia, uk, italy, newZealand, korea, india, germany, france
    case brazil, southAfrica, russia, kazakhstan, uae, indonesia, malaysia
    case philippines, thailand, vietnam, pakistan, bangladesh, egypt, turkey
    case argentina, mexico, spain, portugal, saudiArabia
    
    var dialingCode: String {
        switch self {
        case .us, .canada:
            return "+1"
        case .taiwan:
            return "+886"
        case .china:
            return "+86"
        case .hongkong:
            return "+852"
        case .macao:
            return "+853"
        case .singapore:
            return "+65"
        case .japan:
            return "+81"
        case .australia:
            return "+61"
        case .uk:
            return "+44"
        case .italy:
            return "+39"
        case .newZealand:
            return "+64"
        case .korea:
            return "+82"
        case .india:
            return "+91"
        case .germany:
            return "+49"
        case .france:
            return "+33"
        case .brazil:
            return "+55"
        case .southAfrica:
            return "+27"
        case .russia, .kazakhstan:
            return "+7"
        case .uae:
            return "+971"
        case .indonesia:
            return "+62"
        case .malaysia:
            return "+60"
        case .philippines:
            return "+63"
        case .thailand:
            return "+66"
        case .vietnam:
            return "+84"
        case .pakistan:
            return "+92"
        case .bangladesh:
            return "+880"
        case .egypt:
            return "+20"
        case .turkey:
            return "+90"
        case .argentina:
            return "+54"
        case .mexico:
            return "+52"
        case .spain:
            return "+34"
        case .portugal:
            return "+351"
        case .saudiArabia:
            return "+966"
        }
    }
    
    var regex: String {
        switch self {
        case .taiwan: return "^09[0-9]{8}$"
        case .china: return "^[1][3-9][0-9]{9}$"
        case .hongkong, .macao: return "^[0-9]{8}$"
        case .us, .canada: return "^[2-9][0-9]{9}$"
        case .singapore: return "^[689][0-9]{7}$"
        case .japan: return "^[789]0[0-9]{8}$"
        case .australia: return "^[45][0-9]{8}$"
        case .uk: return "^[1-9][0-9]{9}$"
        case .italy: return "^[0-9]{8,10}$"
        case .newZealand: return "^[278][0-9]{7,9}$"
        case .korea: return "^01[016789][0-9]{7,8}$"
        case .india: return "^[6-9][0-9]{9}$"
        case .germany, .france, .brazil, .southAfrica, .russia, .kazakhstan,
             .uae, .indonesia, .malaysia, .philippines, .thailand, .vietnam,
             .pakistan, .bangladesh, .egypt, .turkey, .argentina, .mexico,
             .spain, .portugal, .saudiArabia:
            return "^[0-9]{6,12}$"
        }
    }
    
    static func fromDialingCode(_ code: String) -> [PhoneCountry] {
        return PhoneCountry.allCases.filter { $0.dialingCode == code }
    }
}
