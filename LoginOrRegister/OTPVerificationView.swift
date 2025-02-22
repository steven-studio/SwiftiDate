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

    @Binding var verificationID: String?
    @Binding var isRegistering: Bool
    @Binding var selectedCountryCode: String // 預設為台灣國碼
    @Binding var phoneNumber: String
//    @State private var otpCode: String = ""
    @State private var otpCode: [String] = Array(repeating: "", count: 6) // Create an array of 6 strings
    @State private var isVerifying = false
    @State private var isResending = false
    @State private var countdown = 30 // 倒數計時器
    @FocusState private var focusedField: Int? // Tracks which TextField is currently focused
    @State private var showRealVerification = false // ✅ 控制是否跳轉到真人認證

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
                    
                    TextField("", text: binding)
                    .keyboardType(.numberPad)
                    .frame(width: 50, height: 50)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .focused($focusedField, equals: index) // Bind focus to this TextField
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(focusedField == index ? Color.green : Color.clear, lineWidth: 2) // 綠色邊框
                    )
                }
            }
            .padding(.horizontal)
            .onAppear {
                if verificationID == nil {
                    FirebaseAuthManager.shared.sendOTP()  // ✅ 當 verificationID 為 nil，發送第一次驗證碼
                }
                focusedField = 0 // Start by focusing on the first field
                startCountdown()
            }
            .onChange(of: focusedField) { oldValue, newValue in
                print("🔍 當前選中的輸入框索引：\(String(describing: newValue))")
            }
            
            Text("🔍 `focusedField` 變更: 從 \(String(describing: focusedField))")
            
            Button(action: {
                
            }) {
                countdown == 0 ? Text("重新獲取")
                    .foregroundColor(.green)
                    .fontWeight(.bold) : Text("你的驗證碼大概將於\(countdown)秒後送達").foregroundColor(.green).fontWeight(.semibold)
            }
            
            Spacer()

            Button(action: verifyOTPCode) {
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
        .fullScreenCover(isPresented: $showRealVerification) { // ✅ 驗證成功後跳轉真人認證
            RealVerificationView(selectedCountryCode: $selectedCountryCode, phoneNumber: $phoneNumber)
                .environmentObject(appState) // ✅ 傳遞 AppState
                .environmentObject(userSettings) // ✅ 傳遞 UserSettings
        }
    }
    
    // 处理输入的函数
    private func handleInput(_ newValue: String, at index: Int) {
        // 如果输入超过1个字符，将剩余字符分配给下一个输入框
        if newValue.count > 1 {
            let chars = Array(newValue)
            otpCode[index] = String(chars[0])
            
            if index < 5 {
                // 将剩下的字符分配给接下来的输入框
                for i in 1..<chars.count {
                    if index + i <= 5 {
                        otpCode[index + i] = String(chars[i])
                    }
                }
                // 设置焦点到下一个输入框
                focusedField = min(index + chars.count, 5)
            } else {
                focusedField = nil // 当到最后一位时，关闭键盘
            }
        } else {
            // 如果只有一个字符，正常处理并移动到下一个框
            otpCode[index] = newValue
            if newValue.count == 1 {
                moveToNextField(from: index)
            }
        }
        print("Current verificationCode array: \(otpCode)")
    }
    
    private func moveToNextField(from index: Int) {
        if index < 5 {
            focusedField = index + 1
        } else {
            focusedField = nil // Dismiss the keyboard when all fields are filled
        }
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
                    showRealVerification = true // ✅ 觸發真人認證畫面
                }
            }
        }
    }
}

struct OTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        OTPVerificationView(
            verificationID: .constant("123456"),  // 測試用的假 verificationID
            isRegistering: .constant(true),  // 測試時不會影響主 UI,
            selectedCountryCode: .constant("+886"),
            phoneNumber: .constant("0972516868")
        )
        .environmentObject(AppState())
        .environmentObject(UserSettings())
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print("✅ 手動觸發 `focusedField = 0`")
            }
        }
        .previewDevice("iPhone 15 Pro")  // 指定模擬的裝置
    }
}
