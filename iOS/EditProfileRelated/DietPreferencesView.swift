//
//  DietPreferencesView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/8/20.
//

import Foundation
import SwiftUI

struct DietPreferencesView: View {
    @Binding var selectedDietPreference: String?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("你有任何飲食上的偏好嗎？")
                .font(.headline)
                .padding()

            // List of diet preferences
            ForEach(["從不挑食", "純素主義", "素食", "潔食", "清真", "其他飲食偏好"], id: \.self) { option in
                Button(action: {
                    selectedDietPreference = option
                    // 埋點：使用者選擇某個飲食偏好
                    AnalyticsManager.shared.trackEvent("diet_preference_selected", parameters: [
                        "option": option
                    ])
                }) {
                    Text(option)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedDietPreference == option ? Color.green : Color.clear)
                        .foregroundColor(selectedDietPreference == option ? .white : .primary)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }

            Spacer()

            // Clear and Confirm buttons
            HStack {
                Button(action: {
                    selectedDietPreference = nil // Clear the selection
                    // 埋點：清空操作
                    AnalyticsManager.shared.trackEvent("diet_preference_cleared")
                }) {
                    Text("清空")
                        .foregroundColor(.primary)
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(10)
                }
                Spacer()
                Button(action: {
                    // 埋點：確認操作，並傳入最終選擇的偏好（若無則用 "none"）
                    AnalyticsManager.shared.trackEvent("diet_preference_confirmed", parameters: [
                        "selected": selectedDietPreference ?? "none"
                    ])
                    presentationMode.wrappedValue.dismiss() // Confirm and dismiss the view
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
            // 埋點：頁面曝光
            AnalyticsManager.shared.trackEvent("diet_preferences_view_appear")
        }
    }
}
