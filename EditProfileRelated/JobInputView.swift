//
//  JobInputView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/8/19.
//

import Foundation
import SwiftUI

struct JobInputView: View {
    @Binding var selectedJob: String?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("你的職業是？")
                .font(.headline)
                .padding()

            TextField("輸入你的職業", text: Binding(
                get: { selectedJob ?? "" },
                set: { selectedJob = $0.isEmpty ? nil : $0 }
            ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Spacer()
            
            HStack {
                Button(action: {
                    selectedJob = nil // 清空输入
                    // 埋點：記錄用戶清空職業輸入
                    AnalyticsManager.shared.trackEvent("job_input_cleared")
                }) {
                    Text("清空")
                        .foregroundColor(.primary)
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(10)
                }
                Spacer()
                Button(action: {
                    // 埋點：記錄用戶確認輸入，傳入最終選擇的職業（若無則為 "none"）
                    AnalyticsManager.shared.trackEvent("job_input_confirmed", parameters: [
                        "job": selectedJob ?? "none"
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
            .padding(.trailing)
        }
        .padding()
        .onAppear {
            // 埋點：頁面曝光
            AnalyticsManager.shared.trackEvent("job_input_view_appear")
        }
    }
}

struct JobInputView_Previews: PreviewProvider {
    @State static var selectedJob: String? = "軟體工程師" // 預設值為軟體工程師

    static var previews: some View {
        JobInputView(selectedJob: $selectedJob) // 傳遞預設的 `@State` 變數作為綁定
    }
}
