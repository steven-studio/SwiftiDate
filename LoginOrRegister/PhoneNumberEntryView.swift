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
        switch selectedCountryCode {
        case "+886": // 台灣
            return PhoneValidator.isTaiwanNumber(phoneNumber)
        case "+86":  // 大陸
            return PhoneValidator.isMainlandChinaNumber(phoneNumber)
        default:
            // 其他國碼 → 看你是否也要檢查或直接返回 false
            return false
        }
    }
    
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
                .accessibilityIdentifier("CountryCodeButton") // <- 加上 Identifier
                .onChange(of: selectedCountryCode) { newValue in
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
                // 這裡是「按鈕被點擊時要做的事」
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
                        // 確定按鈕的行為
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
        userSettings.globalCountryCode = selectedCountryCode

        // 替換為你實際部署的函式 URL，比如:
        // https://us-central1-你的專案ID.cloudfunctions.net/checkTaiwanPhone
        
        var urlString = "https://us-central1-swiftidate-cdff0.cloudfunctions.net/checkTaiwanPhone"
        
        // 1. 建立「國碼 -> 雲函式路徑」的字典
        let functionMap: [String: String] = [
            "+886": "checkTaiwanPhone",
            "+86":  "checkChinaPhone",
            "+852": "checkHongKongPhone", // 其實 +853 是澳門，+852 是香港
            "+853": "checkMacaoPhone",
            "+1":   "checkUSPhone",
            "+65":  "checkSingaporePhone",
            "+62":  "checkIndonesianPhone",
            "+81":  "checkJapanPhone",
            "+61":  "checkAustralianPhone",
            "+44":  "checkBritishPhone",
            "+39":  "checkItalianPhone",
            "+64":  "checkNewZealandPhone",
            "+82":  "checkKoreaPhone"
        ]

        // 2. 以 selectedCountryCode 查字典
        if let functionName = functionMap[selectedCountryCode] {
            // 為了維護容易，可把雲函式主機放在一個常數
            let baseURL = "https://us-central1-swiftidate-cdff0.cloudfunctions.net"
            urlString = "\(baseURL)/\(functionName)"
        } else {
            // 沒對應到就給個預設 fallback
            // 或者直接不改 urlString
            print("⚠️ 未定義此國碼對應的雲函式，請補充")
        }
        
        guard let url = URL(string: urlString) else {
            isChecking = false
            print("❌ 無法生成 URL，請確認網址是否正確")
            return
        }
        
        // 建立 POST 請求
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "data": [
                "phone": phoneNumber
            ]
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("❌ JSON 編碼失敗: \(error)")
            isChecking = false
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            // 在主執行緒更新 UI
            DispatchQueue.main.async {
                isChecking = false
            }

            if let error = error {
                print("❌ API 請求失敗: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("❌ 回應資料為空")
                return
            }

            do {
                // onCall 函式的回傳格式預設為:
                // {
                //   "result": {
                //       "exists": true / false
                //   }
                // }
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let result = json?["result"] as? [String: Any],
                   let exists = result["exists"] as? Bool {
                    
                    DispatchQueue.main.async {
                        if exists {
                            // 手機號碼已註冊，導向「密碼登入」畫面
                            print("✅ 手機號碼已註冊，跳轉到密碼登入畫面")
                            self.showPasswordLoginView = true
                        } else {
                            // 手機號碼未註冊，導向「OTP 驗證」畫面
                            print("✅ 手機號碼未註冊，跳轉到 OTP 驗證畫面")
                            self.showOTPView = true
                        }
                    }
                } else {
                    print("❌ JSON 格式不符合預期: \(String(describing: json))")
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
