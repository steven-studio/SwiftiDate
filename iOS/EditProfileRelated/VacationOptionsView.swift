//
//  VacationOptionsView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/8/20.
//

import Foundation
import SwiftUI

struct VacationOptionsView: View {
    @Binding var selectedVacationOption: String?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("平時都什麼時候休假？")
                .font(.headline)
                .padding()

            ForEach(["週末休息", "不定期休假/輪休", "時間自己掌控", "其他休息日"], id: \.self) { option in
                Button(action: {
                    selectedVacationOption = option
                    // 埋點：使用者選擇某個休假選項
                    AnalyticsManager.shared.trackEvent("vacation_option_selected", parameters: [
                        "option": option
                    ])
                }) {
                    Text(option)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedVacationOption == option ? Color.green : Color.clear)
                        .foregroundColor(selectedVacationOption == option ? .white : .primary)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }

            Spacer()

            HStack {
                Button(action: {
                    selectedVacationOption = nil
                    // 埋點：使用者清空休假選項
                    AnalyticsManager.shared.trackEvent("vacation_option_cleared")
                }) {
                    Text("清空")
                        .foregroundColor(.primary)
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(10)
                }
                Spacer()
                Button(action: {
                    // 埋點：使用者按下確定並關閉頁面
                    AnalyticsManager.shared.trackEvent("vacation_option_confirmed", parameters: [
                        "option": selectedVacationOption ?? "none"
                    ])
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("確定")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .padding()
        .onAppear {
            // 可選：進入頁面時記錄曝光事件
            AnalyticsManager.shared.trackEvent("vacation_options_view_appear")
        }
    }
}
