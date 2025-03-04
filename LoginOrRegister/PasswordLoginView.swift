//
//  PasswordLoginView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/3.
//

import Foundation
import SwiftUI

struct PasswordLoginView: View {
    @EnvironmentObject var appState: AppState // ✅ 存取全局登入狀態
    @EnvironmentObject var userSettings: UserSettings // ✅ 存取用戶設置
    @Binding var selectedCountryCode: String
    @Binding var phoneNumber: String
    @State private var password: String = ""
    @State private var isLoggingIn = false
    @State private var showOTPForResetPassword = false  // 新增這個狀態

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // 返回上一頁前記錄事件
                    AnalyticsManager.shared.trackEvent("PasswordLogin_BackTapped", parameters: nil)
                    // Handle Back Action (Pop to previous view)
                    // isRegistering = false
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.gray.opacity(0.5)) // 設置文字顏色為黑色
                        .padding(.leading)
                }
                Spacer()
            }
            .padding(.top)
            
            Text("輸入密碼")
                .font(.title)
                .padding()
                .foregroundColor(.white)

//            Text("\(selectedCountryCode) \(phoneNumber)")
//                .foregroundColor(.gray)

            TextField("", text: $password)
                .font(.title2)
                .padding(.horizontal)
                .padding(.vertical)
                .foregroundColor(.black)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
                .accessibilityIdentifier("PasswordTextField") // <- 加上 Identifier
            
            // 將 "忘記密碼？" 改成 Button
            Button(action: {
                // 記錄事件，並切換到 OTP 驗證（密碼重設模式）
                AnalyticsManager.shared.trackEvent("PasswordLogin_ForgotPasswordTapped", parameters: nil)
                showOTPForResetPassword = true
            }) {
                Text("忘記密碼？")
                    .font(.headline)
                    .foregroundColor(.green)
                    .padding(.top)
            }
            .accessibilityIdentifier("ForgotPasswordButton") // <- 加上 Identifier

            Spacer()

            Button(action: loginUser) {
                HStack {
                    if isLoggingIn {
                        ProgressView()
                    }
                    Text(isLoggingIn ? "登入中..." : "繼續")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .frame(width: 300)
                .cornerRadius(25)
            }
            .accessibilityIdentifier("PasswordLogin_ContinueButton")
            .disabled(isLoggingIn)
            .padding()
        }
        .padding()
        .background(.black)
        .onAppear {
            // 畫面出現時記錄 Analytics 事件
            AnalyticsManager.shared.trackEvent("PasswordLoginView_Appeared", parameters: nil)
        }
        // 使用 fullScreenCover 導向 OTPVerificationView，並傳入密碼重設模式參數
        .fullScreenCover(isPresented: $showOTPForResetPassword) {
            OTPVerificationView(
                isRegistering: .constant(false), // 若非註冊流程
                selectedCountryCode: $selectedCountryCode,
                phoneNumber: $phoneNumber,
                isResetPassword: true // 新增參數，告知 OTPVerificationView 是用於重設密碼
            )
            .environmentObject(appState)
            .environmentObject(userSettings)
        }
    }

    private func loginUser() {
        // 檢查是否啟用了繞過 Firebase 驗證的模式
        if ProcessInfo.processInfo.arguments.contains("-SKIP_FIREBASE_CHECK") {
            print("⚠️ SKIP_FIREBASE_CHECK 啟用：模擬登入成功")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isLoggingIn = false
                AnalyticsManager.shared.trackEvent("PasswordLogin_LoginSuccess", parameters: nil)
                userSettings.globalPhoneNumber = phoneNumber
                appState.isLoggedIn = true
            }
            return
        }
        
        isLoggingIn = true
        AnalyticsManager.shared.trackEvent("PasswordLogin_LoginAttempt", parameters: ["phone": "\(selectedCountryCode)\(phoneNumber)"])

        let fullPhoneNumber = "\(selectedCountryCode)\(phoneNumber)"
        let url = URL(string: "https://your-api.com/login")! // ✅ 替換為你的後端 API
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["phone": fullPhoneNumber, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoggingIn = false
            }

            guard let data = data, error == nil else {
                let errorMessage = error?.localizedDescription ?? "未知錯誤"
                print("❌ 登入失敗: \(error?.localizedDescription ?? "未知錯誤")")
                return
            }

            do {
                let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let success = result?["success"] as? Bool ?? false

                DispatchQueue.main.async {
                    if success {
                        print("✅ 登入成功")
                        AnalyticsManager.shared.trackEvent("PasswordLogin_LoginSuccess", parameters: nil)
                        // 跳轉到主畫面
                        userSettings.globalPhoneNumber = phoneNumber
                        appState.isLoggedIn = true
                    } else {
                        print("❌ 密碼錯誤")
                        AnalyticsManager.shared.trackEvent("PasswordLogin_LoginFailure", parameters: ["reason": "密碼錯誤"])
                    }
                }
            } catch {
                let parseError = error.localizedDescription
                print("❌ API 回應解析失敗: \(error.localizedDescription)")
                AnalyticsManager.shared.trackEvent("PasswordLogin_LoginFailure", parameters: ["error": parseError])
            }
        }.resume()
    }
}

// **✅ 加入 SwiftUI 預覽**
struct PasswordLoginView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordLoginView(
            selectedCountryCode: .constant("+886"), // ✅ 使用 .constant 模擬台灣區碼
            phoneNumber: .constant("0972516868")  // ✅ 使用 .constant 模擬手機號碼
        )
        .environmentObject(AppState())
        .environmentObject(UserSettings())
        .previewDevice("iPhone 15 Pro") // ✅ 指定裝置模擬
    }
}
