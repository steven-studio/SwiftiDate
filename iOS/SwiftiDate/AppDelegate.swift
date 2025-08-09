//
//  AppDelegate.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/9.
//

import Foundation
import CoreLocation
import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseCrashlytics
import KeychainAccess
import FirebaseAppCheck
import FirebaseFirestore
import UserNotifications
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    var cloudService: CloudService?
    
    let locationService = LocationService() // 建立實例
    let geocoder = CLGeocoder() // Initialize the geocoder
    
    static var apnsReady = false
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // 🔥 Firebase 官方標準初始化方式：
        if FirebaseApp.app() == nil { FirebaseApp.configure() }
        print("Firebase Options:", FirebaseApp.app()?.options as Any)
        
//        #if DEBUG
//        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
//        #endif

        // AppCheck (這裡沒有問題)
        let providerFactory = DeviceCheckProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        
        // 確認 Firebase 初始化成功之後，再進行 Firestore測試
        testFirebaseConnection { success in
            if success {
                self.cloudService = FirebaseCloudService()
                self.cloudService?.initialize() // 這個 initialize 應僅用來做你額外設定（如 listener 等）
            } else {
                let aliCloud = AliCloudService()
                aliCloud.initialize()
                self.cloudService = aliCloud
            }
        }

        // Store or retrieve device identifier
        storeDeviceIdentifier()
        
        // 開始定位
        locationService.start()
        
        // 設定 closure，接收更新
        locationService.onLocationUpdate = { location in
            globalLatitude = location.coordinate.latitude
            globalLongitude = location.coordinate.longitude
            print("Location updated: \(location)")
        }
        
        locationService.onPlacemarkUpdate = { placemark in
            globalLocality = placemark.locality
            globalSubadministrativeArea = placemark.subAdministrativeArea
            print("Placemark updated: \(placemark)")
            
            if placemark.country == "Taiwan", placemark.locality == "Hsinchu City" {
//                    print("The location is in Hsinchu City, Taiwan!")
            } else {
//                    print("The location is not in Hsinchu City, Taiwan. It is in \(placemark.locality ?? "Unknown City"), \(placemark.country ?? "Unknown Country").")
            }
        }
        
        // 配置通知功能
        NotificationManager.shared.requestAuthorization()
        NotificationManager.shared.registerForPushNotifications()
        
        // 調用 IPManager 取得對外 IP
        IPManager.shared.fetchPublicIP { ipAddress in
            DispatchQueue.main.async {
                if let ip = ipAddress {
                    print("取得的對外 IP 為：\(ip)")
                    // 此處可以做後續處理，例如上傳至後端、存檔等
                } else {
                    print("無法取得對外 IP")
                }
            }
        }
        
        // 🔔🔔🔔🔔🔔 推播的關鍵程式碼在這 🔔🔔🔔🔔🔔
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            guard granted else {
                print("❌ 推播權限未允許")
                return
            }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                print("✅ 已呼叫 registerForRemoteNotifications")
            }
        }
        
        // ✅ 確保在 configure 完成後才送事件
        DispatchQueue.main.async {
            AnalyticsManager.shared.trackEvent("app_launch")
        }
        return true
    }
    
    // 收到設備令牌時的回調
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        #if DEBUG
        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
        #else
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
        #endif
        guard AppDelegate.apnsReady == true else {
            // 提示：還在初始化推播，請稍後再試
            return
        }
        
        Messaging.messaging().apnsToken = deviceToken // 必須要有這行！
        NotificationManager.shared.handleDeviceToken(deviceToken: deviceToken)
        
        print("✅ 已成功取得 deviceToken: \(deviceToken)")

    }

    // 註冊失敗的回調
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        AppDelegate.apnsReady = false
        // NotificationCenter.default.post(name: .apnsFailed, object: error)
        print("Failed to register for notifications: \(error.localizedDescription)")
    }
    
    // 在前台顯示通知時的處理
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge]) // 顯示通知
    }
    
    // 2)（可選）使用者點通知的情況也轉給 Firebase Auth
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        _ = Auth.auth().canHandleNotification(response.notification.request.content.userInfo)
        completionHandler()
    }
        
    private func storeDeviceIdentifier() {
        let keychain = Keychain(service: "stevenstudio.SwiftiDate")
        if let existingUUID = keychain["deviceUUID"] {
            print("Existing Device UUID: \(existingUUID)")
            deviceIdentifier = existingUUID // Store it in the global variable
        } else {
            let newUUID = UUID().uuidString
            keychain["deviceUUID"] = newUUID
            deviceIdentifier = newUUID // Store it in the global variable
            print("New Device UUID stored: \(newUUID)")
        }
    }
    
    // Request notification permission
//    private func requestNotificationPermission() {
//        let center = UNUserNotificationCenter.current()
//        center.delegate = self
//        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            if let error = error {
//                print("Error requesting notification permission: \(error.localizedDescription)")
//            } else {
//                print("Notification permission granted: \(granted)")
//            }
//        }
//    }
    
    private func testFirebaseConnection(completion: @escaping (Bool) -> Void) {
        // 簡單示範，做個 Firestore 測試
        let db = Firestore.firestore()
        db.collection("test").document("testDoc").getDocument { snapshot, error in
            if let error = error {
                print("Firebase 連線失敗：\(error)")
                completion(false)
            } else {
                print("Firebase 連線成功")
                completion(true)
            }
        }
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if Auth.auth().canHandle(url) { return true }
        return false
    }
    
    // 1) iOS 的 remote notification 回呼（含靜默推播）
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // 讓 Firebase Auth 嘗試處理 (自動讀碼會用到這裡)
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
        // 你的其他處理...
        completionHandler(.noData)
    }
}
