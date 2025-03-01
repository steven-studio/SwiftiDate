//
//  HometownInputView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/8/19.
//

import Foundation
import SwiftUI

struct HometownInputView: View {
    @Binding var selectedHometown: String?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("你的家鄉在哪？")
                .font(.headline)
                .padding()

            TextField("輸入你的家鄉", text: Binding(
                get: { selectedHometown ?? "" },
                set: { selectedHometown = $0.isEmpty ? nil : $0 }
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()

            Spacer()
            
            HStack {
                Button(action: {
                    selectedHometown = nil // 清空输入
                    // 埋點：用戶清空家鄉輸入
                    AnalyticsManager.shared.trackEvent("hometown_cleared")
                }) {
                    Text("清空")
                        .foregroundColor(.primary)
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(10)
                }
                Spacer()
                Button(action: {
                    // 埋點：用戶按下確定
                    AnalyticsManager.shared.trackEvent("hometown_confirmed", parameters: [
                        "hometown": selectedHometown ?? "none"
                    ])
                    // 確定並關閉頁面
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
            // 埋點：頁面曝光
            AnalyticsManager.shared.trackEvent("hometown_input_view_appear")
        }
    }
}
