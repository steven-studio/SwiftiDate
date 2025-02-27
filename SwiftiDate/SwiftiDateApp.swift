//
//  SwiftiDateApp.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/8/18.
//

import Foundation
import SwiftUI
import FirebaseCore
import CoreLocation
import KeychainAccess
import UserNotifications // Import UserNotifications framework
import FirebaseFirestore
import FirebaseAppCheck
import FirebaseAuth
import FirebaseCrashlytics

var deviceIdentifier: String? // Global variable
var globalLatitude: Double? // Global variable for latitude
var globalLongitude: Double? // Global variable for longitude
var globalSubadministrativeArea: String? // Global variable for subadministrative area
var globalLocality: String? // Global variable for locality

@main
struct SwiftiDateApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var appState = AppState()
    @StateObject var userSettings = UserSettings() // Initialize UserSettings as a state object
    
    init() {
        // 在 App 初始化時檢查是否帶有 -UI_TEST_MODE
        if ProcessInfo.processInfo.arguments.contains("-UI_TEST_MODE") {
            // 這裡把 UserDefaults, Keychain 或資料庫等都清除
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            // 清除 Keychain、登出 Firebase 等
            userSettings.globalPhoneNumber = ""
            userSettings.globalUserName = ""
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if !userSettings.globalPhoneNumber.isEmpty { // 改為檢查非空
                    ContentView()
                        .environmentObject(userSettings)
                        .environmentObject(appState)
                        .onAppear {
                            // 1. 在這裡呼叫一個方法，執行 Firebase 匿名登入
                            signInAnonymously()
                        }
                } else {
                    LoginOrRegisterView()
                        .environmentObject(userSettings)
                        .environmentObject(appState)
                }
            }
            .onAppear {
//                userSettings.globalPhoneNumber = "0972516868"
//                userSettings.globalUserName = "玩玩"
                userSettings.globalPhoneNumber = ""
                userSettings.globalUserName = ""
                userSettings.globalUserGender = Gender.male
                userSettings.globalIsUserVerified = true
                userSettings.globalSelectedGender = "女生"
                userSettings.globalUserBirthday = "1999/07/02"
                userSettings.globalUserID = "userID_1"
                userSettings.globalLikesMeCount = 0
                userSettings.globalLikeCount = 0
                userSettings.isPremiumUser = true
                userSettings.isSupremeUser = true
                userSettings.globalTurboCount = 1
                userSettings.globalCrushCount = 10000
                userSettings.globalPraiseCount = 10000
                userSettings.isProfilePhotoVerified = true
            }
        }
    }
    
    func signInAnonymously() {
        if let user = Auth.auth().currentUser {
            // 已登入過了
            userSettings.globalUserID = user.uid
            print("Already logged in, uid = \(user.uid)")
        } else {
            // 尚未登入 => 執行匿名登入
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    print("匿名登入失敗: \(error.localizedDescription)")
                    return
                }
                if let user = result?.user {
                    print("匿名登入成功, uid = \(user.uid)")
                    // 這時可以把 user.uid 等資訊灌到 userSettings
                    userSettings.globalUserID = user.uid
                }
            }
        }
    }
}
