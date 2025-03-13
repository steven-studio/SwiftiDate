//
//  ConnectivityManager.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/1/26.
//

import Foundation
import WatchConnectivity

class ConnectivityManager: NSObject, ObservableObject, WCSessionDelegate {
    // 是否正在傳送數據
    @Published var isSendingData: Bool = false

    override init() {
        super.init()

        // 確認當前裝置支援 WatchConnectivity
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()  // 啟動連線
        }
    }

    // MARK: - 對外公開的方法

    func toggleDataSending() {
        isSendingData.toggle()
    }

    /// 傳送健康數據 (範例：心率、血氧)
    func sendHealthData(heartRate: Int, bloodOxygen: Int) {
        guard WCSession.default.isReachable else {
            print("🚫 iPhone 與 Apple Watch 尚未連線或無法即時通訊")
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

    /// session 啟動完成後的回呼
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        if let error = error {
            print("🚫 session 啟動失敗：\(error.localizedDescription)")
        } else {
            print("✅ session 啟動狀態：\(activationState.rawValue)")
        }
    }

    /// iPhone 端接收 Apple Watch 傳來的 message
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            // 依據 key 取出資料，做你需要的處理
            if let watchHeartRate = message["heartRate"] as? Int,
               let watchBloodOxygen = message["bloodOxygen"] as? Int {
                print("⌚️ 收到來自 Watch 的心率：\(watchHeartRate)、血氧：\(watchBloodOxygen)")
                // 你可以在這裡更新 @Published 狀態或儲存資料...
            }
        }
    }

    // 這兩個是必須實作，但可以留空
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        // 重新啟動 session
        WCSession.default.activate()
    }
}
