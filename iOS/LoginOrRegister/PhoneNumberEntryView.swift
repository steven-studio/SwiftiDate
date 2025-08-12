//
//  PhoneNumberEntryView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/4.
//

import Foundation
import SwiftUI

struct PhoneNumberEntryView: View {
    @EnvironmentObject var appState: AppState // ✅ 存取全局登入狀態
    @EnvironmentObject var userSettings: UserSettings // ✅ 存取用戶設置
    @Binding var isRegistering: Bool // Binding variable to control view navigation
    @State private var isShowingCountryCodePicker = false
    @State private var selectedCountryCode: String = "+886" // 預設為台灣國碼
    @State private var phoneNumber: String = ""
    @State private var showAlert = false // 控制顯示警告視窗的變數
    @State private var showOTPView = false // 控制 OTP 驗證畫面
    @State private var showPasswordLoginView = false // ✅ 控制是否顯示輸入密碼畫面
    @State private var isChecking = false // ✅ 控制是否顯示「檢查中」的 Loading
    private var isPhoneValid: Bool {
        PhoneValidator.validate(countryCode: selectedCountryCode, phoneNumber: phoneNumber)
    }
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // 返回上一頁前記錄事件
                    AnalyticsManager.shared.trackEvent("PhoneNumberEntry_BackTapped", parameters: nil)
                    isRegistering = false
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.black.opacity(0.5)) // 設置文字顏色為黑色
                        .padding(.leading)
                }
                Spacer()
            }
            .padding(.top)
            
            Text("你的手機號碼是？")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            Text("註冊或登錄需要輸入你的手機號碼")
                .font(.subheadline)
                .foregroundColor(.black)
                .padding(.top, 5)
            
            HStack {
                Button(action: {
                    isShowingCountryCodePicker.toggle() // 點擊顯示國碼選擇器
                }) {
                    HStack {
                        Text(selectedCountryCode) // 顯示選中的國碼
                            .font(.title2)
                            .foregroundColor(.black) // 設置文字顏色為黑色
                        Image(systemName: "chevron.down") // 向下箭頭圖示
                            .font(.system(size: 16))
                            .foregroundColor(.gray.opacity(0.7)) // 設置圖示顏色為黑色
                    }
                    .font(.title2)
                    .padding(.horizontal)
                    .padding(.vertical)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .accessibilityIdentifier("CountryCodeButton") // <- 加上 Identifier
                .onChange(of: selectedCountryCode) { oldValue, newValue in
                    userSettings.globalCountryCode = newValue
                }
                
                TextField("", text: $phoneNumber)
                    .keyboardType(.numberPad)
                    .font(.title2)
                    .padding(.horizontal)
                    .padding(.vertical)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .accessibilityIdentifier("PhoneNumberTextField") // <- 加上 Identifier
                
                Spacer()
            }
            
            Spacer()
            
            HStack {
                Image(systemName: "phone")
                    .foregroundColor(.gray) // You can change the color to your preference
                Text("請確認你的手機號碼為目前正在使用的手機號碼！")
            }
            .font(.footnote)
            .foregroundColor(.gray)
            .padding(.horizontal)
            .padding(.bottom, 5)
            
            HStack {
                Image(systemName: "umbrella.fill")
                Text("我們不會將該資訊分享給任何人，你的手機號碼也不會出現在你的個人首頁")
            }
            .font(.footnote)
            .foregroundColor(.gray)
            .padding(.horizontal)
            .padding(.bottom, 5)
            
            Button(action: {
                // 記錄使用者點擊「繼續」按鈕
                AnalyticsManager.shared.trackEvent("PhoneNumberEntry_ContinueTapped", parameters: ["phone": "\(selectedCountryCode) \(phoneNumber)"])
                self.showAlert = true
            }) {
                //                Text("繼續")
                HStack {
                    if isChecking {
                        ProgressView()
                    }
                    Text(isChecking ? "檢查中..." : "繼續")
                }
                .font(.title2)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isPhoneValid ? Color.green : Color.gray.opacity(0.5))  // <-- 依狀態切換顏色
                .cornerRadius(25)
                .foregroundColor(.white)
            }
            .accessibilityIdentifier("ContinueButton") // <- 加上 Identifier
            .padding(.horizontal)
            .padding(.bottom)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("請驗證你的手機號碼：\n\(selectedCountryCode) \(phoneNumber)"),
                    message: Text("我們需要驗證 \(selectedCountryCode) \(phoneNumber) 是你的手機號碼"),
                    primaryButton: .default(Text("確定"), action: {
                        // 記錄確認檢查手機號碼的事件
                        AnalyticsManager.shared.trackEvent("PhoneNumberEntry_CheckPhoneNumber", parameters: ["phone": "\(selectedCountryCode) \(phoneNumber)"])
                        checkPhoneNumber()
                    }),
                    secondaryButton: .cancel(Text("取消"))
                )
            }
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .fullScreenCover(isPresented: $showOTPView) { // ✅ 切換到 OTP 驗證畫面
            OTPVerificationView(
                isRegistering: $isRegistering,
                selectedCountryCode: $selectedCountryCode,
                phoneNumber: $phoneNumber
            )
            .environment(\.authService, FirebaseAuthService()) // 👈 之後要換 Twilio 改這裡
            .environmentObject(appState) // ✅ 傳遞 AppState
            .environmentObject(userSettings) // ✅ 傳遞 UserSettings
        }
        .fullScreenCover(isPresented: $showPasswordLoginView) {
            PasswordLoginView(
                selectedCountryCode: $selectedCountryCode,
                phoneNumber: $phoneNumber
            )
            .environmentObject(appState) // ✅ 傳遞 AppState
            .environmentObject(userSettings) // ✅ 傳遞 UserSettings
        }
        .fullScreenCover(isPresented: $isShowingCountryCodePicker) {
            CountryCodePickerView(selectedCountryCode: $selectedCountryCode)
        }
        .onAppear {
            // 畫面出現時記錄 Analytics 事件
            AnalyticsManager.shared.trackEvent("PhoneNumberEntryView_Appeared", parameters: nil)
        }
    }
    
    // **✅ 先檢查手機號碼是否存在**
    func checkPhoneNumber() {
        isChecking = true
        let url = URL(string: "https://us-central1-swiftidate-cdff0.cloudfunctions.net/checkPhone")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "data": [
                "countryCode": selectedCountryCode,
                "phoneNumber": phoneNumber
            ]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { isChecking = false }
            
            if let error = error {
                print("❌ 網路請求錯誤：\(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("❌ 回傳的 data 是 nil")
                return
            }
            
            // ⭐️ 將回應內容印出來查看：
            if let responseString = String(data: data, encoding: .utf8) {
                print("📬 API 回應內容：\(responseString)")
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let result = json["result"] as? [String: Any],
                  let exists = result["exists"] as? Bool else {
                print("❌ API回應解析錯誤")
                return
            }

            DispatchQueue.main.async {
                if exists {
                    showPasswordLoginView = true
                } else {
                    showOTPView = true
                }
            }
        }.resume()
    }
}

struct PhoneNumberEntryView_Previews: PreviewProvider {
    @State static var isRegistering = true
    
    static var previews: some View {
        PhoneNumberEntryView(isRegistering: $isRegistering)
            .environmentObject(AppState()) // ✅ 傳遞 AppState
            .environmentObject(UserSettings()) // ✅ 傳遞 UserSettings
            .previewDevice("iPhone 15 Pro")
    }
}
