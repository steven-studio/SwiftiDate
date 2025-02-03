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

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // Handle Back Action (Pop to previous view)
                    isRegistering = false
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
                
                TextField("", text: $phoneNumber)
                    .keyboardType(.numberPad)
                    .font(.title2)
                    .padding(.horizontal)
                    .padding(.vertical)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                
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
            
            Button(action: checkPhoneNumber) {
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
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(25)
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.bottom)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("請驗證你的手機號碼：\n\(selectedCountryCode) \(phoneNumber)"),
                    message: Text("我們需要驗證 \(selectedCountryCode) \(phoneNumber) 是你的手機號碼"),
                    primaryButton: .default(Text("確定"), action: {
                        // 確定按鈕的行為
                        showOTPView = true // ✅ 點擊確定後進入 OTP 驗證
                    }),
                    secondaryButton: .cancel(Text("取消"))
                )
            }
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .fullScreenCover(isPresented: $showOTPView) { // ✅ 切換到 OTP 驗證畫面
            OTPVerificationView(
                verificationID: .constant("123456"),  // 假設的驗證 ID（正式應用應該從後端獲取）
                isRegistering: $isRegistering,
                selectedCountryCode: $selectedCountryCode,
                phoneNumber: $phoneNumber
            )
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
    }
    
    // **✅ 先檢查手機號碼是否存在**
    private func checkPhoneNumber() {
        isChecking = true

        let fullPhoneNumber = "\(selectedCountryCode)\(phoneNumber)"
        let url = URL(string: "https://your-api.com/check-phone")! // ✅ 替換為你的後端 API
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["phone": fullPhoneNumber]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isChecking = false
            }

            guard let data = data, error == nil else {
                print("❌ API 請求失敗: \(error?.localizedDescription ?? "未知錯誤")")
                return
            }

            do {
                let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let exists = result?["exists"] as? Bool ?? false

                DispatchQueue.main.async {
                    if exists {
                        print("✅ 手機號碼已註冊，跳轉到密碼登入畫面")
                        showPasswordLoginView = true
                    } else {
                        print("✅ 手機號碼未註冊，跳轉到 OTP 驗證畫面")
                        showOTPView = true
                    }
                }
            } catch {
                print("❌ API 回應解析失敗: \(error.localizedDescription)")
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
