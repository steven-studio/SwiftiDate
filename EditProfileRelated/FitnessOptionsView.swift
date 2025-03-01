//
//  FitnessOptionsView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/8/20.
//

import Foundation
import SwiftUI

struct FitnessOptionsView: View {
    @Binding var selectedFitnessOption: String?
    @Environment(\.presentationMode) var presentationMode // Used to control view dismissal

    var body: some View {
        VStack {
            Text("你平時健身嗎？")
                .font(.headline)
                .padding()

            // List of fitness options
            ForEach(["經常健身", "有時候", "幾乎從不"], id: \.self) { option in
                Button(action: {
                    selectedFitnessOption = option
                    // 埋點：使用者選擇健身偏好
                    AnalyticsManager.shared.trackEvent("fitness_option_selected", parameters: [
                        "option": option
                    ])
                }) {
                    Text(option)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedFitnessOption == option ? Color.green : Color.clear)
                        .foregroundColor(selectedFitnessOption == option ? .white : .primary)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }

            Spacer()
            
            // Clear and Confirm buttons
            HStack {
                Button(action: {
                    selectedFitnessOption = nil // Clear the selection
                    // 埋點：使用者清空健身偏好
                    AnalyticsManager.shared.trackEvent("fitness_option_cleared")
                }) {
                    Text("清空")
                        .foregroundColor(.primary)
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(10)
                }
                Spacer()
                Button(action: {
                    // 埋點：使用者確認健身偏好，並傳入最終選擇（若無則傳 "none"）
                    AnalyticsManager.shared.trackEvent("fitness_option_confirmed", parameters: [
                        "option": selectedFitnessOption ?? "none"
                    ])
                    presentationMode.wrappedValue.dismiss() // Dismiss the view
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
            AnalyticsManager.shared.trackEvent("fitness_options_view_appear")
        }
    }
}
