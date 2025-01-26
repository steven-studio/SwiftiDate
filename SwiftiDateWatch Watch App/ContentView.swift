//
//  ContentView.swift
//  SwiftiDateWatch Watch App
//
//  Created by 游哲維 on 2025/1/25.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @State private var isSendingData = false // 是否正在傳送數據
    private let sendInterval = 2.0 // 傳送數據的間隔時間（秒）

    var body: some View {
        VStack(spacing: 20) {
            Text("Send Health Data")
                .font(.headline)
                .padding()

            // Start Send 按鈕
            Button(action: startSendingHealthData) {
                Text("Start Send")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .buttonStyle(.plain) // 移除默認邊框背景
            .disabled(isSendingData) // 正在發送時禁用按鈕

            // Stop Send 按鈕
            Button(action: stopSendingHealthData) {
                Text("Stop Send")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(!isSendingData) // 未發送時禁用按鈕
        }
    }

    // 開始傳送數據
    func startSendingHealthData() {
        guard !isSendingData else { return }
        isSendingData = true

        // 模擬連續傳送數據的計時器
        Timer.scheduledTimer(withTimeInterval: sendInterval, repeats: true) { timer in
            if !isSendingData { // 如果停止傳輸，結束計時器
                timer.invalidate()
                return
            }

            sendHeartRateToiPhone()
            sendBloodOxygenToiPhone()
        }
    }

    // 停止傳送數據
    func stopSendingHealthData() {
        isSendingData = false
        print("Stopped sending health data")
    }

    // 傳送心率數據
    func sendHeartRateToiPhone() {
        guard WCSession.default.isReachable else {
            print("iPhone is not reachable")
            return
        }

        let heartRate = Int.random(in: 60...100) // 模擬心率數據
        WCSession.default.sendMessage(["heartRate": heartRate], replyHandler: nil) { error in
            print("Failed to send heart rate: \(error.localizedDescription)")
        }
        print("Sent heart rate: \(heartRate)")
    }

    // 傳送血氧數據
    func sendBloodOxygenToiPhone() {
        guard WCSession.default.isReachable else {
            print("iPhone is not reachable")
            return
        }

        let bloodOxygen = Int.random(in: 95...100) // 模擬血氧數據
        WCSession.default.sendMessage(["bloodOxygen": bloodOxygen], replyHandler: nil) { error in
            print("Failed to send blood oxygen: \(error.localizedDescription)")
        }
        print("Sent blood oxygen: \(bloodOxygen)")
    }
}

#Preview {
    ContentView()
}
