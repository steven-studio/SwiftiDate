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

// 全局未捕獲異常處理函數
func uncaughtExceptionHandler(exception: NSException) {
    let error = NSError(domain: exception.name.rawValue,
                        code: 0,
                        userInfo: [NSLocalizedDescriptionKey: exception.reason ?? "No reason"])
    Crashlytics.crashlytics().record(error: error)
    print("Uncaught exception logged to Crashlytics: \(exception.name.rawValue)")
}

class AppDelegate: NSObject, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    let locationService = LocationService() // 建立實例
    let geocoder = CLGeocoder() // Initialize the geocoder
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseManager.shared.configureFirebase()
        
        FirebaseManager.shared.configureFirestore()
        
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
}
