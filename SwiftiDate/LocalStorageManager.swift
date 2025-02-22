//
//  LocalStorageManager.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/16.
//

import Foundation

class LocalStorageManager {
    static let shared = LocalStorageManager()
    private init() {}
    
    private let defaults = UserDefaults.standard
    
    func saveUserSettings(_ userSettings: UserSettings) {
        defaults.set(userSettings.globalPhoneNumber, forKey: "phoneNumber")
        defaults.set(userSettings.globalUserName, forKey: "userName")
        defaults.set(userSettings.globalUserGender.rawValue, forKey: "userGender")
        defaults.set(userSettings.globalIsUserVerified, forKey: "isUserVerified")
        // ... 其它欄位
        defaults.set(userSettings.globalTurboCount, forKey: "turboCount")
        defaults.set(userSettings.globalCrushCount, forKey: "crushCount")
        defaults.set(userSettings.globalPraiseCount, forKey: "praiseCount")
        defaults.set(userSettings.globalLikesMeCount, forKey: "likesMeCount")
        defaults.set(userSettings.globalLikeCount, forKey: "likeCount")
        defaults.set(userSettings.isSupremeUser, forKey: "isSupremeUser")
        defaults.synchronize()
        print("Debug - User data has been saved to UserDefaults.")
    }
    
    func loadUserSettings(into userSettings: UserSettings) {
        userSettings.globalPhoneNumber = defaults.string(forKey: "phoneNumber") ?? "未設定"
        userSettings.globalUserName = defaults.string(forKey: "userName") ?? "未設定"
        
        if let genderValue = defaults.string(forKey: "userGender"),
           let gender = Gender(rawValue: genderValue) {
            userSettings.globalUserGender = gender
        }
        userSettings.globalIsUserVerified = defaults.bool(forKey: "isUserVerified")
        // ... 其它欄位
        userSettings.globalTurboCount = defaults.integer(forKey: "turboCount")
        userSettings.globalCrushCount = defaults.integer(forKey: "crushCount")
        userSettings.globalPraiseCount = defaults.integer(forKey: "praiseCount")
        
        userSettings.globalLikesMeCount = defaults.integer(forKey: "likesMeCount")
        userSettings.globalLikeCount = defaults.integer(forKey: "likeCount")
        
        userSettings.isSupremeUser = defaults.bool(forKey: "isSupremeUser")
    }
    
    /// 清除所有 UserDefaults 資料
    func clearAll() {
        if let appDomain = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: appDomain)
        }
        defaults.synchronize()
    }
    
    func saveVerificationID(_ id: String) {
        defaults.set(id, forKey: "FirebaseVerificationID")
        // defaults.synchronize() // iOS 12+ 通常不再需要手動呼叫
    }
}
