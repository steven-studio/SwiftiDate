//
//  Profile.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/8/13.
//

// Profile.swift
import Foundation
import FirebaseFirestore

/// 供 Swipe 卡片 / 列表使用的公開資料模型
struct Profile: Identifiable, Codable {
    let id: String

    // —— 卡片一定會用到（盡量完整）——
    var name: String?
    var age: Int?
    var zodiac: String?          // Firestore: "selectedZodiac" or "zodiac"
    var location: String?        // Firestore: "selectedHometown" or "location"
    var height: Int?             // Firestore: "selectedHeight" or "height"
    var photos: [String]         // Firestore: "photos"（預設空陣列）
    var aboutMe: String?
    var lastLogin: Date?

    // —— 可能會當成標籤顯示（保持可選即可）——
    var bloodType: String?       // Firestore: "selectedBloodType"
    var degree: String?          // "selectedDegree"
    var dietPreference: String?  // "selectedDietPreference"
    var drinkOption: String?     // "selectedDrinkOption"
    var fitnessOption: String?   // "selectedFitnessOption"
    var industry: String?        // "selectedIndustry"
    var job: String?             // "selectedJob"
    var languages: [String]?     // "selectedLanguages"
    var lookingFor: String?      // "selectedLookingFor"
    var pet: String?             // "selectedPet"
    var school: String?          // "selectedSchool"
    var smokingOption: String?   // "selectedSmokingOption"
    var vacationOption: String?  // "selectedVacationOption"
    
    init(id: String,
         name: String? = nil,
         age: Int? = nil,
         zodiac: String? = nil,
         location: String? = nil,
         height: Int? = nil,
         photos: [String] = []) {
        self.id = id
        self.name = name
        self.age = age
        self.zodiac = zodiac
        self.location = location
        self.height = height
        self.photos = photos
    }

    // MARK: - Firestore 方便建構器（用在列表抓人時）
    init(id: String, data: [String: Any]) {
        self.id = id

        // 基本欄位
        self.name       = data["name"] as? String
        self.age        = data["age"] as? Int
        self.aboutMe    = data["aboutMe"] as? String

        // 對應「selected*」或舊欄位名
        self.zodiac     = (data["selectedZodiac"] as? String) ?? (data["zodiac"] as? String)
        self.location   = (data["selectedHometown"] as? String) ?? (data["location"] as? String)
        self.height     = (data["selectedHeight"] as? Int) ?? (data["height"] as? Int)

        // 照片陣列
        self.photos     = (data["photos"] as? [String]) ?? []

        // 時間戳記
        if let ts = data["lastLoginTimestamp"] as? Timestamp {
            self.lastLogin = ts.dateValue()
        } else {
            self.lastLogin = nil
        }

        // 其他選項（照你的 Firestore 命名）
        self.bloodType       = data["selectedBloodType"] as? String
        self.degree          = data["selectedDegree"] as? String
        self.dietPreference  = data["selectedDietPreference"] as? String
        self.drinkOption     = data["selectedDrinkOption"] as? String
        self.fitnessOption   = data["selectedFitnessOption"] as? String
        self.industry        = data["selectedIndustry"] as? String
        self.job             = data["selectedJob"] as? String
        self.languages       = data["selectedLanguages"] as? [String]
        self.lookingFor      = data["selectedLookingFor"] as? String
        self.pet             = data["selectedPet"] as? String
        self.school          = data["selectedSchool"] as? String
        self.smokingOption   = data["selectedSmokingOption"] as? String
        self.vacationOption  = data["selectedVacationOption"] as? String
    }
}

// MARK: - 偏好/生活方式（可公開或半公開，看規則）
struct Preferences: Codable {
    // 交友意圖
    var lookingFor: String?           // selectedLookingFor

    // 生活習慣
    var diet: String?                 // selectedDietPreference
    var drink: String?                // selectedDrinkOption
    var smoke: String?                // selectedSmokingOption
    var fitness: String?              // selectedFitnessOption
    var pet: String?                  // selectedPet
    var vacationStyle: String?        // selectedVacationOption

    // 其他個人屬性
    var bloodType: String?            // selectedBloodType
    var hometown: String?             // selectedHometown
    var meetWillingness: String?      // selectedMeetWillingness（目前空字串也可）
}

// MARK: - App 設定（通知、發現條件…這些多半不公開）
struct AppSettings: Codable {
    // 你原本 UserSettings 裡可以放進來的 app 行為設定
    var discoveryGender: String?      // 你原本的 globalSelectedGender 等
    var discoveryAgeMin: Int?
    var discoveryAgeMax: Int?
    var notificationEnabled: Bool?
    // 之後有需要再加
}

// MARK: - 別人（列表/滑卡用，唯讀、輕量）
struct RemoteUser: Codable, Identifiable {
    let id: String
    let profile: Profile
    var distanceKm: Double?
    var isLikedByMe: Bool?
}

// MARK: - 自己（可寫入；聚合公開 Profile + 偏好 + 設定 + 訂閱等）
struct CurrentUser: Codable, Identifiable {
    let id: String
    var profile: Profile
    var preferences: Preferences
    var settings: AppSettings

    // 私密資訊不應放在公開文件（Firestore 會拆子集合）
    var email: String?
    var phone: String?

    var blockedUserIDs: Set<String>
    var subscription: Subscription?   // 你既有的訂閱型別（可之後補）
}

// 你的 Subscription 可維持原先設計
struct Subscription: Codable {
    var plan: String
    var validUntil: Date
}
