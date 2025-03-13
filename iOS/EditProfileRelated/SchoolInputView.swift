//
//  SchoolInputView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/8/19.
//

import Foundation
import SwiftUI

struct SchoolInputView: View {
    @Binding var selectedSchool: String?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("你的學校是？")
                .font(.headline)
                .padding()

            TextField("輸入你的學校名稱", text: Binding(
                get: { selectedSchool ?? "" },
                set: { selectedSchool = $0.isEmpty ? nil : $0 }
            ))
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
            
            Spacer()

            HStack {
                Button(action: {
                    selectedSchool = nil
                    // 埋點：用戶清空學校輸入
                    AnalyticsManager.shared.trackEvent("school_input_cleared")
                }) {
                    Text("清空")
                        .foregroundColor(.primary)
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(10)
                }
                .padding(.leading)
                
                Spacer()

                Button(action: {
                    // 埋點：用戶確認學校輸入
                    AnalyticsManager.shared.trackEvent("school_input_confirmed", parameters: [
                        "school": selectedSchool ?? "none"
                    ])
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("確定")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.trailing)
            }
            .padding(.bottom)
        }
        .padding()
        .onAppear {
            // 埋點：頁面曝光
            AnalyticsManager.shared.trackEvent("school_input_view_appear")
        }
    }
}
