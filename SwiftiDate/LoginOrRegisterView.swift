//
//  LoginOrRegisterView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/4.
//

import Foundation
import SwiftUI
import AuthenticationServices

struct LoginOrRegisterView: View {
    @State private var authorizationController: ASAuthorizationController?
    @EnvironmentObject var appState: AppState // ✅ 讓 LoginOrRegisterView 存取 appState
    @EnvironmentObject var userSettings: UserSettings // ✅ 讓 LoginOrRegisterView 存取 userSettings
    @State private var isRegistering = false // State to toggle between views
    @State private var showPrivacySheet: Bool = false
    
    // 用來儲存從本地載入的圖片，當 userSettings.photos 改變時更新
    @State private var loadedImage: UIImage?
    
    var body: some View {
        // Display LoginOrRegisterView when isRegistering is false
        ZStack {
            // 背景顏色
            LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.5), Color.blue]),
                           startPoint: .top,
                           endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                if userSettings.globalPhoneNumber != "" {
                    HStack {
                        Button(action: {
                            // Handle Back Action (Pop to previous view)
                            LocalStorageManager.shared.clearAll()
                            userSettings.globalPhoneNumber = "" // 清除手機號碼
                            DispatchQueue.main.async {
                                userSettings.showExistingUserPopup = false
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.gray.opacity(0.5)) // 設置文字顏色為黑色
                                .padding(.leading)
                        }
                        Spacer()
                    }
                    .padding(.top)
                }
                
                Spacer()
                
                Text("SwiftiDate")
                    .font(.system(size: 72))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 50)
                
                Spacer()
                
                if userSettings.globalPhoneNumber.isEmpty {
                    VStack {
                        
                        // Button to navigate to registration
                        Button(action: {
                            // 埋點：使用者點擊「快速註冊新帳號」按鈕
                            AnalyticsManager.shared.trackEvent("click_register_button")
                            
                            isRegistering = true // Trigger the registration flow
                        }) {
                            Text("快速註冊新帳號")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(25)
                        }
                        .accessibilityIdentifier("RegisterButton") // <-- 新增這行
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                        .fullScreenCover(isPresented: $isRegistering) {
                            PhoneNumberEntryView(isRegistering: $isRegistering)
                        }
                        
                        // Button for existing account login
                        Button(action: {
                            // 埋點：使用者點擊「已有帳號」按鈕
                            AnalyticsManager.shared.trackEvent("click_login_button")
                            
                            // Handle Login Action
                        }) {
                            Text("我已有賬號")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.clear)
                                .cornerRadius(25)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 30)
                } else {
                    // 登入選項按鈕
                    VStack(spacing: 20) {
                        Button(action: {
                            // 行動電話登入按鈕的動作
                            AnalyticsManager.shared.trackEvent("click_login_phone", parameters: [
                                "screen": "LoginView"
                            ])
                        }) {
                            HStack {
                                Image(systemName: "phone.fill")
                                Text("使用手機號碼登入")
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity)
                            .font(.system(size: 17))
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(25)
                            .padding(.horizontal)
                        }
                        .background(
                            GeometryReader { geometry in
                                Color.clear
                                    .onAppear {
                                        print("Button height: \(geometry.size.height)")
                                    }
                            }
                        )
                        
                        SignInWithAppleButton(
                            onRequest: { request in
                                request.requestedScopes = [.fullName, .email]
                                AnalyticsManager.shared.trackEvent("apple_id_login_requested")
                            },
                            onCompletion: { result in
                                switch result {
                                case .success(let authResults):
                                    // 記錄成功事件
                                    AnalyticsManager.shared.trackEvent("apple_id_login_success")
                                    handleAuthorizationResult(authResults)
                                case .failure(let error):
                                    // 記錄失敗事件，並帶上錯誤資訊
                                    AnalyticsManager.shared.trackEvent("apple_id_login_failed", parameters: [
                                        "error": error.localizedDescription
                                    ])
                                    print("Authorization failed: \(error.localizedDescription)")
                                }
                            }
                        )
                        .frame(height: 56.33333333333333)
                        .signInWithAppleButtonStyle(.white)
                        .cornerRadius(25)
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    
                    // 隱私政策及服務條款
                    Text("SwiftiDate 不會在你的 Facebook 上發文")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.bottom, 5)
                }
                
                Button(action: {
                    // 這裡可以觸發你的隱私條款頁面的展示動作
                    // 例如設定一個 state 變數來顯示一個 sheet
                    showPrivacySheet.toggle()
                }) {
                    HStack {
                        Text("服務協議")
                        Text("&")
                        Text("隱私權政策")
                    }
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.bottom, 20)
                }
                .fullScreenCover(isPresented: $showPrivacySheet) {
                    NavigationView {
                        TermsAndPrivacyView()
                    }
                }
            }
            
            // 彈框顯示部分
            if userSettings.showExistingUserPopup {
                Color.black.opacity(0.4).ignoresSafeArea() // 背景透明遮罩
                
                VStack(spacing: 20) {
                    if let image = loadedImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    } else {
                        // Default placeholder image
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    }
                    
                    Text(userSettings.globalUserName)
                        .font(.headline)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        // 確定以此帳號登入
                        print("繼續使用帳號 \(userSettings.globalUserName)")
                        print("Debug - globalPhoneNumber: \(userSettings.globalPhoneNumber)") // Debug globalPhoneNumber
                        AnalyticsManager.shared.trackEvent("existing_user_continue", parameters: [
                            "username": userSettings.globalUserName
                        ])
                        appState.isLoggedIn = true // 更新登入狀態
                    }) {
                        Text("以此帳號登錄")
                            .foregroundColor(.white)
                            .frame(width: 250, height: 45)
                        // 在背景使用漸層
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.cyan, Color.blue]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(22.5)
                    }
                    
                    Button(action: {
                        // 更換帳號並清除所有已存資料
                        //                        LocalStorageManager.shared.clearAll()
                        print("換個帳號")
                        AnalyticsManager.shared.trackEvent("existing_user_switch_account")
                        userSettings.showExistingUserPopup = false
                    }) {
                        Text("不是你？換個帳號")
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                    }
                }
                .frame(width: 300, height: 350)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.horizontal, 20)
            }
        }
        // 當 userSettings.photos 改變時更新 loadedImage
        .onReceive(userSettings.$photos) { photos in
            print("onReceive triggered, photos: \(photos)")
            if let firstPhoto = photos.first {
                loadedImage = PhotoUtility.loadImageFromLocalStorage(named: firstPhoto)
            } else {
                loadedImage = nil
            }
        }
    }
    
    // 處理 Apple ID 登入結果
    func handleAuthorizationResult(_ result: ASAuthorization) {
        guard let credential = result.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        
        let userID = credential.user
        let email = credential.email
        let fullName = credential.fullName
        
        // 在這裡處理登錄信息，例如存儲用戶信息到本地或服務器
        print("User ID: \(userID)")
        if let email = email {
            print("Email: \(email)")
        }
        if let fullName = fullName {
            print("Full Name: \(fullName)")
        }
    }
}

struct LoginOrRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        LoginOrRegisterView()
            .environmentObject(AppState()) // ✅ 確保預覽時傳遞 appState
            .environmentObject(UserSettings()) // ✅ 確保預覽時傳遞 userSettings
            .previewDevice("iPhone 15 Pro")  // You can choose a specific device for the preview
    }
}
