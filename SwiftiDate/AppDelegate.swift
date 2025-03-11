//
//  AppDelegate.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/9.
//

import Foundation
import CoreLocation
import UIKit
import FirebaseCore
import FirebaseCrashlytics
import KeychainAccess
import FirebaseAppCheck
import FirebaseFirestore
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    var cloudService: CloudService?
    
    let locationService = LocationService() // 建立實例
    let geocoder = CLGeocoder() // Initialize the geocoder
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // 1. 嘗試初始化 Firebase
        let firebaseCloud = FirebaseCloudService()
        firebaseCloud.initialize()
        
        // 2. 檢查 Firebase 是否可用 (例如測試 Firestore 或測試 Storage 連線)
        testFirebaseConnection { success in
            if success {
                // 如果可用，就用 Firebase
                self.cloudService = firebaseCloud
            } else {
                // 如果連不上，就用阿里雲 (示例)
                let aliCloud = AliCloudService()
                aliCloud.initialize()
                self.cloudService = aliCloud
            }
        }

        // 初始化 App Check
        let providerFactory = DeviceCheckProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        
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
        
        return true
    }
    
    // 收到設備令牌時的回調
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NotificationManager.shared.handleDeviceToken(deviceToken: deviceToken)
    }

    // 註冊失敗的回調
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for notifications: \(error.localizedDescription)")
    }
    
    // 在前台顯示通知時的處理
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge]) // 顯示通知
    }
        
    private func storeDeviceIdentifier() {
        let keychain = Keychain(service: "com.stevenstudio.SwiftiDate")
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
}
