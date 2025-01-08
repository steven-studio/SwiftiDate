//
//  NotificationManager.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/1/8.
//

import UIKit
import Foundation
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    private override init() {}

    func requestAuthorization() {
        UNUserNotificationCenter.current().delegate = self // 设置代理
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notifications authorization: \(error.localizedDescription)")
            }
            print("Permission granted: \(granted)")
        }
    }

    func registerForPushNotifications() {
        UIApplication.shared.registerForRemoteNotifications()
    }

    func handleDeviceToken(deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token: \(token)")
        // 傳送令牌到伺服器
    }
}

// 扩展代理方法
extension NotificationManager {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Received notification: \(notification.request.content.userInfo)")
        completionHandler([.alert, .sound, .badge]) // 显示通知
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Notification clicked: \(response.notification.request.content.userInfo)")
        completionHandler()
    }
}
