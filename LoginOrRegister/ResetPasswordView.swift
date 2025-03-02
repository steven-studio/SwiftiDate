//
//  ResetPasswordView.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/2.
//

import Foundation
import SwiftUI

struct ResetPasswordView: View {
    @EnvironmentObject var appState: AppState // ✅ 存取全局登入狀態
    @EnvironmentObject var userSettings: UserSettings // ✅ 存取用戶設置
    @Binding var selectedCountryCode: String
    @Binding var phoneNumber: String
    @State private var password: String = ""
    @State private var isLoggingIn = false

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // 返回上一頁前記錄事件
                    AnalyticsManager.shared.trackEvent("ResetPassword_BackTapped", parameters: nil)
                    // Handle Back Action (Pop to previous view)
                    // isRegistering = false
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.black.opacity(0.5)) // 設置文字顏色為黑色
                        .padding(.leading)
                }
                Spacer()
            }
            .padding(.top)
            
            Text("更換新密碼")
                .font(.title)
                .foregroundColor(.white)
            
            Text("密碼須不少於6個字符")
                .font(.body)
                .padding()
                .foregroundColor(.white)

            TextField("", text: $password)
                .font(.title3)
                .padding(.horizontal)
                .padding(.vertical)
                .foregroundColor(.black)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
                .accessibilityIdentifier("ResetPasswordTextField") // <- 加上 Identifier
            
            Spacer()

            Button(action: loginUser) {
                HStack {
                    if isLoggingIn {
                        ProgressView()
                    }
                    Text(isLoggingIn ? "重設中..." : "繼續")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(isLoggingIn)
            .padding()
        }
        .padding()
        .background(Color.black)
        .onAppear {
            // 畫面出現時記錄 Analytics 事件
            AnalyticsManager.shared.trackEvent("ResetPasswordView_Appeared", parameters: nil)
        }
    }

    private func loginUser() {
        isLoggingIn = true
        AnalyticsManager.shared.trackEvent("ResetPassword_ResetAttempt", parameters: ["phone": "\(selectedCountryCode)\(phoneNumber)"])
        
        // 重設密碼的 API 呼叫流程
        // 假設 API 呼叫成功後：
        URLSession.shared.dataTask(with: URL(string: "https://your-api.com/resetPassword")!) { data, response, error in
            DispatchQueue.main.async {
                isLoggingIn = false
            }
            if let error = error {
                print("❌ 重設密碼失敗: \(error.localizedDescription)")
                AnalyticsManager.shared.trackEvent("ResetPassword_Failure", parameters: ["error": error.localizedDescription])
                return
            }
            
            // 假設回傳成功
            DispatchQueue.main.async {
                print("✅ 重設密碼成功")
                AnalyticsManager.shared.trackEvent("ResetPassword_Success", parameters: nil)
                // 登入或轉跳到主畫面等後續處理
                userSettings.globalPhoneNumber = phoneNumber
                appState.isLoggedIn = true
            }
        }.resume()
    }
}

// **✅ 加入 SwiftUI 預覽**
struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView(
            selectedCountryCode: .constant("+886"), // ✅ 使用 .constant 模擬台灣區碼
            phoneNumber: .constant("0972516868")  // ✅ 使用 .constant 模擬手機號碼
        )
        .environmentObject(AppState())
        .environmentObject(UserSettings())
        .previewDevice("iPhone 15 Pro") // ✅ 指定裝置模擬
    }
}
