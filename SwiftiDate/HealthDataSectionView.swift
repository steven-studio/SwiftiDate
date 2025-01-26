//
//  HealthDataSectionView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/1/26.
//

import SwiftUI
import Charts

struct HealthDataSectionView: View {
    // 1) 透過 @ObservedObject 或 @EnvironmentObject 引入 ConnectivityManager
    //    - 若整個 App 都會用到，可以改用 @EnvironmentObject；此處示範 @ObservedObject
    @ObservedObject var connectivityManager = ConnectivityManager()
    
    // 以下是你的原本屬性
    @State private var heartRate: Int = 75 // 模擬心率數據
    @State private var bloodOxygen: Int = 98 // 模擬血氧數據
    @State private var isSendingData = false // 控制是否顯示連續更新的數據

    // 用於存儲心率和血氧數據的歷史數據
    @State private var heartRateData: [HealthDataPoint] = []
    @State private var bloodOxygenData: [HealthDataPoint] = []
    
    // 這是我們自訂的閉包，用來通知父視圖「我要返回了」
    var onBack: () -> Void = {}
    
    // 自定義初始化器
    init(
        heartRate: Int = 75,
        bloodOxygen: Int = 98,
        heartRateData: [HealthDataPoint] = [],
        bloodOxygenData: [HealthDataPoint] = [],
        isSendingData: Bool = false,
        onBack: @escaping () -> Void = {}  // 給個預設值
    ) {
        self._heartRate = State(initialValue: heartRate)
        self._bloodOxygen = State(initialValue: bloodOxygen)
        self._heartRateData = State(initialValue: heartRateData)
        self._bloodOxygenData = State(initialValue: bloodOxygenData)
        self._isSendingData = State(initialValue: isSendingData)
        self.onBack = onBack
    }

    var body: some View {
        VStack {
            ZStack {
                // 左上角的返回按鈕
                HStack {
                    Button(action: {
                        onBack()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.gray) // 設置按鈕顏色
                    }
                    .padding(.leading) // 添加內邊距以確保按鈕不會緊貼邊緣
                    
                    Spacer() // This will push the button to the left
                }
                
                Text("健康數據")
                    .font(.headline)
                    .padding()
            }
            
            Spacer()
            
            VStack {
                VStack(spacing: 20) {
                    // 顯示折線圖
                    VStack {
                        Text("心率變化圖")
                            .font(.subheadline)
                            .padding(.bottom, 5)
                        Chart(heartRateData) {
                            LineMark(
                                x: .value("時間", $0.timestamp),
                                y: .value("心率", $0.value)
                            )
                            .foregroundStyle(.red)
                        }
                        .frame(height: 200)

                        Text("血氧變化圖")
                            .font(.subheadline)
                            .padding(.top, 10)
                        Chart(bloodOxygenData) {
                            LineMark(
                                x: .value("時間", $0.timestamp),
                                y: .value("血氧", $0.value)
                            )
                            .foregroundStyle(.blue)
                        }
                        .frame(height: 200)
                    }

                    if isSendingData {
                        Text("正在連續傳輸健康數據...")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)

                Button(action: {
                    // 2) 呼叫 ConnectivityManager 來切換狀態
                    connectivityManager.toggleDataSending()
                    // 如果要同時重啟計時器，則可在此一併處理
                    if connectivityManager.isSendingData {
                        startDataSimulation()
                    }
                }) {
                    Text(connectivityManager.isSendingData ? "停止傳輸" : "開始傳輸")
                        .padding()
                        .background(connectivityManager.isSendingData ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            Spacer()
        }
    }

    // 模擬數據變化（心率和血氧）
    private func startDataSimulation() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            guard isSendingData else {
                timer.invalidate()
                return
            }
            // 模擬數據
            let newHeartRate = Int.random(in: 60...100)
            let newBloodOxygen = Int.random(in: 95...100)

            // 添加數據點到數據數組
            heartRateData.append(HealthDataPoint(value: newHeartRate, timestamp: Date()))
            bloodOxygenData.append(HealthDataPoint(value: newBloodOxygen, timestamp: Date()))

            // 更新顯示
            heartRate = newHeartRate
            bloodOxygen = newBloodOxygen

            // 保持數據數量不過多（例如僅保存最近 20 條數據）
            if heartRateData.count > 20 { heartRateData.removeFirst() }
            if bloodOxygenData.count > 20 { bloodOxygenData.removeFirst() }
        }
    }
}

// 用於存儲健康數據的數據點
struct HealthDataPoint: Identifiable {
    let id = UUID()
    let value: Int
    let timestamp: Date
}

// 預覽
struct HealthDataSectionView_Previews: PreviewProvider {
    static var previews: some View {
        // 模擬假資料
        let startTime = Date()
        let heartRateData = (0..<300).map { i in
            HealthDataPoint(value: Int.random(in: 60...100), timestamp: startTime.addingTimeInterval(Double(i)))
        }
        let bloodOxygenData = (0..<300).map { i in
            HealthDataPoint(value: Int.random(in: 95...100), timestamp: startTime.addingTimeInterval(Double(i)))
        }

        return HealthDataSectionView(
            heartRateData: heartRateData,
            bloodOxygenData: bloodOxygenData
        )
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color.white)
    }
}
