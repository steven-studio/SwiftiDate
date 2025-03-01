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
                        .foregroundColor(.black.opacity(0.5)) // 設置文字顏色為黑色
                        .padding(.leading)
                }
                Spacer()
            }
            .padding(.top)
            
            Text("輸入密碼")
                .font(.title)
                .padding()

//            Text("\(selectedCountryCode) \(phoneNumber)")
//                .foregroundColor(.gray)

            TextField("", text: $password)
                .font(.title3)
                .padding(.horizontal)
                .padding(.vertical)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            Text("忘記密碼？")
                .font(.body)
                .foregroundColor(Color.green)
                .padding(.top)

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
                .cornerRadius(10)
            }
            .disabled(isLoggingIn)
            .padding()
        }
        .padding()
        .onAppear {
            // 畫面出現時記錄 Analytics 事件
            AnalyticsManager.shared.trackEvent("PasswordLoginView_Appeared", parameters: nil)
        }
    }

    private func loginUser() {
        isLoggingIn = true
        
        // 記錄使用者嘗試登入
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
