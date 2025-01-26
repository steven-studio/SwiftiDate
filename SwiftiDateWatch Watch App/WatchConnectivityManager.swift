//
//  WatchConnectivityManager.swift
//  SwiftiDateWatch Watch App
//
//  Created by 游哲維 on 2025/1/25.
//

import WatchConnectivity
import SwiftUI

class WatchConnectivityManager: NSObject, ObservableObject, WCSessionDelegate {
    // 讓整個 App 共用的單例(Singleton)
    static let shared = WatchConnectivityManager()
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    // 假設手錶量測到新的心率、血氧後主動傳送給 iPhone：
    func sendHealthDataToPhone(heartRate: Int, bloodOxygen: Int) {
        guard WCSession.default.isReachable else {
            print("🚫 Watch 無法連線到 iPhone")
            return
        }
        let data: [String: Any] = [
            "heartRate": heartRate,
            "bloodOxygen": bloodOxygen
        ]
        WCSession.default.sendMessage(data, replyHandler: nil) { error in
            print("🚫 傳送失敗：\(error.localizedDescription)")
        }
    }

    // MARK: - WCSessionDelegate

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        if let error = error {
            print("🚫 Watch session 啟動失敗：\(error.localizedDescription)")
        } else {
            print("✅ Watch session 啟動狀態：\(activationState.rawValue)")
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        // 如果 iPhone 端有回傳什麼訊息給 Watch，也在這裡接收
    }
}
