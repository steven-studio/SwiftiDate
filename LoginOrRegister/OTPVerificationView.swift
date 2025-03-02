//
//  OTPVerificationView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/3.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct OTPVerificationView: View {
    @EnvironmentObject var appState: AppState // ✅ 存取全局登入狀態
    @EnvironmentObject var userSettings: UserSettings // ✅ 存取用戶設置

    @State private var verificationID: String?
    @Binding var isRegistering: Bool
    @Binding var selectedCountryCode: String // 預設為台灣國碼
    @Binding var phoneNumber: String
//    @State private var otpCode: String = ""
    @State private var otpCode: [String] = Array(repeating: "", count: 6) // Create an array of 6 strings
    @State private var isVerifying = false
    @State private var isResending = false
    @State private var countdown = 30 // 倒數計時器
    @FocusState private var focusedIndex: Int? // Tracks which TextField is currently focused
    @State private var showResetPasswordView = false
    @State private var showRealVerification = false // ✅ 控制是否跳轉到真人認證
    // 新增的參數，用來判斷是否為重設密碼流程
    var isResetPassword: Bool = false
    #if DEBUG
    /// 利用環境變數 "XCODE_RUNNING_FOR_PREVIEWS" 判斷是否是 SwiftUI Preview
    private var isPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    #endif

    var attributedString: AttributedString {
        var text = AttributedString("驗證碼")
        text.font = .body

        var highlightText = AttributedString(" 正在傳送至")
        highlightText.font = .headline
        highlightText.foregroundColor = .green

        var phoneText = AttributedString(" \(selectedCountryCode) \(phoneNumber)，請在下方輸入")
        phoneText.font = .body

        return text + highlightText + phoneText
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // 返回上一頁前追蹤返回事件
                    AnalyticsManager.shared.trackEvent("OTPVerification_BackTapped", parameters: nil)
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
            
            Text("輸入驗證碼")
                .font(.title)
                .padding()
            
            Text(attributedString)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 5) {
                ForEach(0..<6) { index in
                    let binding = Binding<String>(
                        get: { otpCode[index] },
                        set: { newValue in handleInput(newValue, at: index) }
                    )
                    
                    /// 這裡就是我們自訂的包裝
                    NoCursorTextFieldWrapper(
                        text: binding,
                        index: index,
                        onDeleteBackwardWhenEmpty: {
                            // 若本格是空的又按退格，就跳到前一格
                            if index > 0, otpCode[index].isEmpty {
                                otpCode[index - 1] = ""      // 清空上一格
                                focusedIndex = index - 1
                            }
                        }
                    )
                    .frame(width: 50, height: 50)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .focused($focusedIndex, equals: index) // Bind focus to this TextField
                    // 這行很關鍵：在 SwiftUI 裡為該欄位指定 accessibilityIdentifier
                    .accessibilityIdentifier("OTPTextField\(index)")
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(focusedIndex == index ? Color.green : Color.clear, lineWidth: 2) // 綠色邊框
                    )
                }
            }
            .padding(.horizontal)
            .onAppear {
                // 畫面出現時記錄 Analytics 事件
                AnalyticsManager.shared.trackEvent("OTPVerification_Appeared", parameters: nil)
                
                #if DEBUG
                if isPreview {
                    // 直接 Mock 一個假的 verificationID，或者什麼都不做
                    self.verificationID = "MOCK_VERIFICATION_ID"
                } else if ProcessInfo.processInfo.arguments.contains("-UI_TEST_MODE") {
                    // Mock: 不要真的打 Firebase Phone Auth
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        // 假裝成功拿到 verificationID
                        self.verificationID = "123456"
                    }
                } else {
                    // 真的呼叫 Firebase Auth
                    FirebaseAuthManager.shared.sendOTP()
                }
                #endif
                self.focusedIndex = 0
                print("✅ 手動觸發 `focusedIndex = \(String(describing: focusedIndex))` after a small delay")
                startCountdown()
            }
            .onChange(of: focusedIndex) { oldValue, newValue in
                print("🔍 當前選中的輸入框索引：\(String(describing: newValue))")
            }
            .padding(.bottom)
            
            Button(action: {
                AnalyticsManager.shared.trackEvent("OTPVerification_ResendOTP", parameters: ["phone": "\(selectedCountryCode)\(phoneNumber)"])
                resendOTP()
            }) {
                countdown == 0 ? Text("重新獲取")
                    .foregroundColor(.green)
                    .fontWeight(.bold) : Text("你的驗證碼大概將於\(countdown)秒後送達").foregroundColor(.green).fontWeight(.semibold)
            }
            
            Spacer()

            Button(action: {
                // 驗證按鈕被點擊時，記錄事件並開始驗證流程
                AnalyticsManager.shared.trackEvent("OTPVerification_VerifyTapped", parameters: ["otp": otpCode.joined()])
                verifyOTPCode()
            }) {
                HStack {
                    if isVerifying {
                        ProgressView()
                    }
                    Text(isVerifying ? "驗證中..." : "提交驗證碼")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(isVerifying)
            .padding()
        }
        .padding()
        .fullScreenCover(isPresented: $showResetPasswordView) {
            ResetPasswordView(
                selectedCountryCode: $selectedCountryCode,
                phoneNumber: $phoneNumber
            )
            .environmentObject(appState)
            .environmentObject(userSettings)
        }
        .fullScreenCover(isPresented: $showRealVerification) { // ✅ 驗證成功後跳轉真人認證
            RealVerificationView(selectedCountryCode: $selectedCountryCode, phoneNumber: $phoneNumber)
                .environmentObject(appState) // ✅ 傳遞 AppState
                .environmentObject(userSettings) // ✅ 傳遞 UserSettings
        }
    }
    
    /// 當使用者在第 index 欄位輸入(或刪除)新值時，更新 otpCode 並處理焦點
    private func handleInput(_ newValue: String, at index: Int) {
        // 先記錄「舊值」
        let oldValue = otpCode[index]
        
        // 更新當前欄位為 newValue 的「第一個字元」（或空字串）
        if newValue.count > 1 {
            let chars = Array(newValue)
            otpCode[index] = String(chars[0])
            var next = index + 1
            var i = 1
            while next < 6, i < chars.count {
                otpCode[next] = String(chars[i])
                next += 1
                i += 1
            }
            focusedIndex = (next <= 5) ? next : nil
        } else {
            if newValue.isEmpty {
                // 使用者把當前欄位清空 → 可能是退格
                if !oldValue.isEmpty {
                    otpCode[index] = ""
                    // 自動跳回前一格
                    if index > 0 {
                        focusedIndex = index - 1
                    }
                } else {
                    // 舊值也是空 -> 可能使用者在空欄位按退格 (更高階需求需要 Introspect 來攔截)
                }
            } else {
                // newValue.count == 1
                otpCode[index] = newValue
                if index < 5 {
                    focusedIndex = index + 1
                } else {
                    // 若已是最後一格，收起鍵盤
                    focusedIndex = nil
                }
            }
        }
        print("Current OTP code array: \(otpCode)")
    }
    
    // **🔹 重新發送驗證碼**
    private func resendOTP() {
        isResending = true
        countdown = 59 // 重置倒數計時

        let fullPhoneNumber = "\(selectedCountryCode)\(phoneNumber)";
        FirebaseAuthManager.shared.sendFirebaseOTP(to: fullPhoneNumber)  // ← 發送 OTP
    }
    
    // **🔹 倒數計時功能**
    private func startCountdown() {
        countdown = 30
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            DispatchQueue.main.async {
                if countdown > 0 {
                    countdown -= 1
                } else {
                    timer.invalidate()
                }
            }
        }
    }

    func verifyOTPCode() {
        guard let verificationID = verificationID else { return }
        isVerifying = true
        
        let code = otpCode.joined() // ✅ 修正：將 [String] 陣列轉換為單一 String

        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)

        Auth.auth().signIn(with: credential) { authResult, error in
            DispatchQueue.main.async {
                isVerifying = false
                if let error = error {
                    print("❌ 驗證失敗: \(error.localizedDescription)")
                } else {
                    print("✅ 驗證成功！用戶登入成功")
                    if isResetPassword {
                        showResetPasswordView = true
                    } else {
                        showRealVerification = true // ✅ 觸發真人認證畫面
                    }
                }
            }
        }
    }
}

struct OTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        OTPVerificationView(
            isRegistering: .constant(true),  // 測試時不會影響主 UI,
            selectedCountryCode: .constant("+886"),
            phoneNumber: .constant("0972516868")
        )
        .environmentObject(AppState())
        .environmentObject(UserSettings())
        .previewDevice("iPhone 15 Pro")  // 指定模擬的裝置
    }
}
