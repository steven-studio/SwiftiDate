//
//  GlobalVariables.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/12/23.
//

import Foundation
import SwiftUI
import Firebase
import Mixpanel

// MARK: - Gender Enum
enum Gender: String {
    case male = "male"
    case female = "female"
    case other = "other"
    case none = "none" // ✅ 代表使用者不想滑任何人
}

enum Country: String, CaseIterable {
    case taiwan       = "taiwan"
    case china        = "china"
    case usa          = "usa"
    case hongKong     = "hongkong"
    case macao        = "macao"
    case singapore    = "singapore"
    case indonesia    = "indonesia"
    case japan        = "japan"
    case australia    = "australia"
    case britain      = "britain"
    case italy        = "italy"
    case newZealand   = "newzealand"
    case korea        = "korea"
    // ...如有需要，可自行加更多國家

    // 如果想要對應 phone code 或其他資訊，
    // 也可以寫成 computed property
    var phoneCode: String {
        switch self {
        case .taiwan:       return "+886"
        case .china:        return "+86"
        case .usa:          return "+1"
        case .hongKong:     return "+852"
        case .macao:        return "+853"
        case .singapore:    return "+65"
        case .indonesia:    return "+62"
        case .japan:        return "+81"
        case .australia:    return "+61"
        case .britain:      return "+44"
        case .italy:        return "+39"
        case .newZealand:   return "+64"
        case .korea:        return "+82"
        }
    }
    
    init?(phoneCode: String) {
        switch phoneCode {
        case "+886": self = .taiwan
        case "+86":  self = .china
        case "+1":   self = .usa
        case "+852": self = .hongKong
        case "+853": self = .macao
        case "+65":  self = .singapore
        case "+62":  self = .indonesia
        case "+81":  self = .japan
        case "+61":  self = .australia
        case "+44":  self = .britain
        case "+39":  self = .italy
        case "+64":  self = .newZealand
        case "+82":  self = .korea
        default:
            return nil
        }
    }
}

// Global variables for shared app settings and user states
class UserSettings: ObservableObject {
    static let shared = UserSettings()
    
    // MARK: - 1. UserDefaults Key 常數集中管理
    private let kUserID                = "kUserID"
    private let kUserName              = "kUserName"
    private let kUserBirthday          = "kUserBirthday"
    private let kUserGender            = "kUserGender"
    private let kSelectedGender        = "kSelectedGender"
    private let kIsUserVerified        = "kIsUserVerified"
    private let kPhoneNumber           = "kPhoneNumber"
    private let kCountry               = "kCountry"
    private let kCountryCode           = "kCountryCode"
    private let kProfilePhotoVerified  = "kProfilePhotoVerified"
    private let kAboutMe               = "kAboutMe"
    
    private let kIsSupremeUser         = "kIsSupremeUser"
    private let kIsPremiumUser         = "kIsPremiumUser"
    private let kGlobalLikesCount      = "kGlobalLikesCount"
    private let kGlobalLikesMeCount    = "kGlobalLikesMeCount"
    private let kGlobalLikeCount       = "kGlobalLikeCount"
    private let kGlobalCrushCount      = "kGlobalCrushCount"
    private let kGlobalPraiseCount     = "kGlobalPraiseCount"
    
    private let kGlobalTurboCount      = "kGlobalTurboCount"
    private let kSelectedTurboOption   = "kSelectedTurboOption"
    private let kPhotos                = "kPhotos"
    private let kSelectedTab           = "kSelectedTab"
    private let kLoadedPhotosString    = "kLoadedPhotosString"
    
    private let kGlobalLatitude        = "kGlobalLatitude"
    private let kGlobalLongitude       = "kGlobalLongitude"
    private let kGlobalSubadminArea    = "kGlobalSubadminArea"
    private let kGlobalCountry         = "kGlobalCountry"
    
    // 🔥 為支援新配對後自動跳到詳細聊天頁，這裡再新增三個 Key
    private let kNewMatchedChatID      = "kNewMatchedChatID"
    private let kNewMatchedChatName    = "kNewMatchedChatName"
    private let kNewMatchedPhone       = "kNewMatchedPhone"

    // MARK: - 2. 屬性定義
    
    // 用來控制是否顯示 existing user popup
    @Published var showExistingUserPopup: Bool = true
    
    // 使用者 ID
    @Published var globalUserID: String {
        didSet { UserDefaults.standard.set(globalUserID, forKey: kUserID) }
    }

    // 使用者暱稱
    @Published var globalUserName: String {
        didSet { UserDefaults.standard.set(globalUserName, forKey: kUserName) }
    }

    // 生日
    @Published var globalUserBirthday: String {
        didSet { UserDefaults.standard.set(globalUserBirthday, forKey: kUserBirthday) }
    }

    // 性別 (使用 enum)
    @Published var globalUserGender: Gender {
        didSet { UserDefaults.standard.set(globalUserGender.rawValue, forKey: kUserGender) }
    }

    // 使用者選擇要配對的性別
    @Published var globalSelectedGender: String {
        didSet { UserDefaults.standard.set(globalSelectedGender, forKey: kSelectedGender) }
    }

    // 是否驗證過
    @Published var globalIsUserVerified: Bool {
        didSet { UserDefaults.standard.set(globalIsUserVerified, forKey: kIsUserVerified) }
    }

    // 電話號碼
    @Published var globalPhoneNumber: String {
        didSet { UserDefaults.standard.set(globalPhoneNumber, forKey: kPhoneNumber) }
    }

    // 國家 (以字串管理)
    @Published var globalCountry: String {
        didSet { UserDefaults.standard.set(globalCountry, forKey: kCountry) }
    }

    // 國碼
    @Published var globalCountryCode: String {
        didSet {
            UserDefaults.standard.set(globalCountryCode, forKey: kCountryCode)
            // 也可在此更新 globalCountry
            switch globalCountryCode {
            case "+886": globalCountry = "taiwan"
            case "+86":  globalCountry = "china"
            case "+852": globalCountry = "hongkong"
            case "+853": globalCountry = "macao"
            case "+1":   globalCountry = "usa"
            case "+65":  globalCountry = "singapore"
            case "+62":  globalCountry = "indonesia"
            case "+81":  globalCountry = "japan"
            case "+61":  globalCountry = "australia"
            case "+44":  globalCountry = "uk"
            case "+39":  globalCountry = "italy"
            case "+64":  globalCountry = "newzealand"
            case "+82":  globalCountry = "korea"
            default:     globalCountry = "unknown"
            }
        }
    }

    // 大頭貼是否審核過
    @Published var isProfilePhotoVerified: Bool {
        didSet { UserDefaults.standard.set(isProfilePhotoVerified, forKey: kProfilePhotoVerified) }
    }
    
    // 個人簡介
    @Published var aboutMe: String {
        didSet { UserDefaults.standard.set(aboutMe, forKey: kAboutMe) }
    }

    // 訂閱相關
    @Published var isSupremeUser: Bool {
        didSet { UserDefaults.standard.set(isSupremeUser, forKey: kIsSupremeUser) }
    }
    @Published var isPremiumUser: Bool {
        didSet { UserDefaults.standard.set(isPremiumUser, forKey: kIsPremiumUser) }
    }

    // 統計計數
    @Published var globalLikesCount: Int {
        didSet { UserDefaults.standard.set(globalLikesCount, forKey: kGlobalLikesCount) }
    }
    @Published var globalLikesMeCount: Int {
        didSet { UserDefaults.standard.set(globalLikesMeCount, forKey: kGlobalLikesMeCount) }
    }
    @Published var globalLikeCount: Int {
        didSet { UserDefaults.standard.set(globalLikeCount, forKey: kGlobalLikeCount) }
    }
    @Published var globalCrushCount: Int {
        didSet { UserDefaults.standard.set(globalCrushCount, forKey: kGlobalCrushCount) }
    }
    @Published var globalPraiseCount: Int {
        didSet { UserDefaults.standard.set(globalPraiseCount, forKey: kGlobalPraiseCount) }
    }

    // Turbo 相關
    @Published var globalTurboCount: Int {
        didSet { UserDefaults.standard.set(globalTurboCount, forKey: kGlobalTurboCount) }
    }
    @Published var selectedTurboOption: String {
        didSet { UserDefaults.standard.set(selectedTurboOption, forKey: kSelectedTurboOption) }
    }

    // 照片陣列 (需做 encode/decode)
    @Published var photos: [String] {
        didSet {
            // 將陣列 encode 後儲存
            let data = try? JSONEncoder().encode(photos)
            UserDefaults.standard.set(data, forKey: kPhotos)
        }
    }

    // 其他
    @Published var selectedTab: Int {
        didSet { UserDefaults.standard.set(selectedTab, forKey: kSelectedTab) }
    }
    @Published var loadedPhotosString: String {
        didSet { UserDefaults.standard.set(loadedPhotosString, forKey: kLoadedPhotosString) }
    }

    // 地理資訊
    @Published var globalLatitude: Double {
        didSet { UserDefaults.standard.set(globalLatitude, forKey: kGlobalLatitude) }
    }
    @Published var globalLongitude: Double {
        didSet { UserDefaults.standard.set(globalLongitude, forKey: kGlobalLongitude) }
    }
    @Published var globalSubadministrativeArea: String {
        didSet { UserDefaults.standard.set(globalSubadministrativeArea, forKey: kGlobalSubadminArea) }
    }
    
    // MARK: - 新配對
    @Published var newMatchedChatID: String? {
        didSet {
            // 若 newMatchedChatID 有值，就 set，否則 remove
            if let chatID = newMatchedChatID {
                UserDefaults.standard.set(chatID, forKey: kNewMatchedChatID)
            } else {
                UserDefaults.standard.removeObject(forKey: kNewMatchedChatID)
            }
        }
    }
    @Published var newMatchedChatName: String? {
        didSet {
            if let name = newMatchedChatName {
                UserDefaults.standard.set(name, forKey: kNewMatchedChatName)
            } else {
                UserDefaults.standard.removeObject(forKey: kNewMatchedChatName)
            }
        }
    }
    @Published var newMatchedPhone: String? {
        didSet {
            if let phone = newMatchedPhone {
                UserDefaults.standard.set(phone, forKey: kNewMatchedPhone)
            } else {
                UserDefaults.standard.removeObject(forKey: kNewMatchedPhone)
            }
        }
    }

    // MARK: - 3. Init: 從 UserDefaults 載入
    init() {
        let defaults = UserDefaults.standard
        
        // 若沒存過就給個預設值
        self.globalUserID        = defaults.string(forKey: kUserID)         ?? "userID_1"
        self.globalUserName      = defaults.string(forKey: kUserName)       ?? "玩玩"
        self.globalUserBirthday  = defaults.string(forKey: kUserBirthday)   ?? "1999/07/02"
        
        if let genderStr = defaults.string(forKey: kUserGender),
           let gender = Gender(rawValue: genderStr) {
            self.globalUserGender = gender
        } else {
            self.globalUserGender = .male
        }
        
        self.globalSelectedGender = defaults.string(forKey: kSelectedGender) ?? "女生"
        self.globalIsUserVerified = defaults.bool(forKey: kIsUserVerified)
        self.globalPhoneNumber    = defaults.string(forKey: kPhoneNumber)    ?? ""
        
        self.globalCountry        = defaults.string(forKey: kCountry)        ?? "taiwan"
        self.globalCountryCode    = defaults.string(forKey: kCountryCode)    ?? "+886"
        
        self.isProfilePhotoVerified = defaults.bool(forKey: kProfilePhotoVerified)
        self.aboutMe               = defaults.string(forKey: kAboutMe)       ?? "default about me"
        
        self.isSupremeUser         = defaults.bool(forKey: kIsSupremeUser)
        self.isPremiumUser         = defaults.bool(forKey: kIsPremiumUser)
        self.globalLikesCount      = defaults.integer(forKey: kGlobalLikesCount)
        self.globalLikesMeCount    = defaults.integer(forKey: kGlobalLikesMeCount)
        self.globalLikeCount       = defaults.integer(forKey: kGlobalLikeCount)
        self.globalCrushCount      = defaults.integer(forKey: kGlobalCrushCount)
        self.globalPraiseCount     = defaults.integer(forKey: kGlobalPraiseCount)
        
        self.globalTurboCount      = defaults.integer(forKey: kGlobalTurboCount)
        self.selectedTurboOption   = defaults.string(forKey: kSelectedTurboOption) ?? "5 Turbo"
        
        if let photoData = defaults.data(forKey: kPhotos),
           let decodedArray = try? JSONDecoder().decode([String].self, from: photoData) {
            self.photos = decodedArray
        } else {
            self.photos = []
        }
        
        self.selectedTab          = defaults.integer(forKey: kSelectedTab)
        self.loadedPhotosString   = defaults.string(forKey: kLoadedPhotosString) ?? ""
        
        self.globalLatitude       = defaults.double(forKey: kGlobalLatitude)
        self.globalLongitude      = defaults.double(forKey: kGlobalLongitude)
        self.globalSubadministrativeArea = defaults.string(forKey: kGlobalSubadminArea) ?? ""
        
        // 新配對相關
        if let newID = defaults.string(forKey: kNewMatchedChatID) {
            self.newMatchedChatID = newID
        } else {
            self.newMatchedChatID = nil
        }
        if let newName = defaults.string(forKey: kNewMatchedChatName) {
            self.newMatchedChatName = newName
        } else {
            self.newMatchedChatName = nil
        }
        if let newPhone = defaults.string(forKey: kNewMatchedPhone) {
            self.newMatchedPhone = newPhone
        } else {
            self.newMatchedPhone = nil
        }
    }
    
    // MARK: - 4. 若要提供「清除所有設定」的操作
    func clearAllData() {
        let defaults = UserDefaults.standard
        if let appDomain = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: appDomain)
        }
        defaults.synchronize()
        
        // 也可順便重設當前實例值
        self.globalUserID        = "userID_1"
        self.globalUserName      = "玩玩"
        self.globalUserBirthday  = "1999/07/02"
        self.globalUserGender    = .male
        self.globalSelectedGender = "女生"
        self.globalIsUserVerified = false
        self.globalPhoneNumber    = ""
        self.globalCountry        = "taiwan"
        self.globalCountryCode    = "+886"
        self.isProfilePhotoVerified = true
        self.aboutMe             = "default about me"
        
        self.isSupremeUser       = false
        self.isPremiumUser       = false
        self.globalLikesCount    = 0
        self.globalLikesMeCount  = 0
        self.globalLikeCount     = 0
        self.globalCrushCount    = 0
        self.globalPraiseCount   = 0
        
        self.globalTurboCount    = 0
        self.selectedTurboOption = "5 Turbo"
        
        self.photos              = []
        self.selectedTab         = 0
        self.loadedPhotosString  = ""
        
        self.globalLatitude      = 0.0
        self.globalLongitude     = 0.0
        self.globalSubadministrativeArea = ""
    }
    
    // MARK: - 🔥 以下為行為分析平台的示範方法

    // 範例: Firebase Analytics 設定 userID
    func setCurrentUserId(_ userId: String) {
        // Firebase
        Analytics.setUserID(userId)

        // Mixpanel
        // 若你還沒針對使用者呼叫 identify，需先呼叫
        Mixpanel.mainInstance().identify(distinctId: userId)

        print("Debug: setCurrentUserId => \(userId)")
    }
    
    // 範例: Mixpanel 設定 userProfile
    func setUserProfile(name: String, phone: String) {
        // --- Firebase ---
        // Firebase 沒有預設的「name」或「phone」屬性，需要使用自訂屬性:
        Analytics.setUserProperty(name, forName: "user_name")
        Analytics.setUserProperty(phone, forName: "user_phone")

        // --- Mixpanel ---
        // 若已經 identify 過此使用者，可透過 Mixpanel People API 設定
        Mixpanel.mainInstance().people.set(properties: ["name": name, "phone": phone])

        print("Debug: setUserProfile => name=\(name), phone=\(phone)")
    }
}

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false // 使用 @Published 來追蹤登入狀態
}
