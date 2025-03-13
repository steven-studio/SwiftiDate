//
//  BirthdayInputView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/4.
//

import Foundation
import SwiftUI

struct BirthdayInputView: View {
    @State private var selectedDate = Date()  // 用於記錄使用者的生日
    
    // 你可以根據需要設定可選擇的日期範圍，例如：16 歲以上
    // 這裡示範最小值為 1900 年 1 月 1 日，最大值為當天
    private var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let minDate = calendar.date(from: DateComponents(year: 1900, month: 1, day: 1)) ?? Date()
        
        // 往前推 18 年
        let eighteenYearsAgo = calendar.date(byAdding: .year, value: -18, to: Date()) ?? Date()
        
        // 只能選 1900/1/1 ~ (現在 - 18 年)
        return minDate...eighteenYearsAgo
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    // 返回上一頁前追蹤返回事件
                    AnalyticsManager.shared.trackEvent("CreatePassword_BackTapped", parameters: nil)
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.gray.opacity(0.5)) // 設置文字顏色為黑色
                        .padding(.leading)
                }
                Spacer()
            }
            .padding(.top)
            
            // 標題
            Text("你的生日是…")
                .font(.title)
                .bold()
                .padding(.top, 40)
            
            // 說明文字
            Text("生日為重要個人資訊，註冊後只可修改一次，請謹慎填寫。")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // 日期顯示區域
            Text("\(formattedDate)")
                .font(.title)
                .padding()
                .frame(maxWidth: .infinity, alignment: .center) // 讓文字靠左
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            Spacer()
            
            // 進一步提示
            Text("對方只會看到你的年齡，不會顯示你真實的出生日期")
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            // DatePicker
            // 如果想要隱藏標籤，可設置 .labelsHidden()
            // 如果想要使用輪子樣式，可設置 .datePickerStyle(.wheel)
            DatePicker(
                "",
                selection: $selectedDate,
                in: dateRange,
                displayedComponents: .date
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            
            Spacer()
            
            // 「完成」按鈕
            Button(action: {
                // 在這裡執行儲存生日的動作
                // 或跳轉到下一個頁面
                print("使用者的生日：\(formattedDate)")
            }) {
                Text("完成")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .frame(width: 300)
                    .cornerRadius(25)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
        .padding()
    }
    
    // 將選擇的日期格式化顯示
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: selectedDate)
    }
}

struct BirthdayInputView_Previews: PreviewProvider {
    static var previews: some View {
        BirthdayInputView()
    }
}
