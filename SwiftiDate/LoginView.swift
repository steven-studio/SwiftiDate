//
//  LoginView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/11.
//

import Foundation
import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @State private var authorizationController: ASAuthorizationController?
    @EnvironmentObject var appState: AppState // 使用 @EnvironmentObject 來訪問 AppState
    @EnvironmentObject var userSettings: UserSettings // 使用 @EnvironmentObject 來訪問 UserSettings
    
    private var showExistingUserPopup: Binding<Bool> {
        Binding<Bool>(
            get: { !userSettings.globalPhoneNumber.isEmpty },
            set: { newValue in
                // 如果需要手動更新 globalPhoneNumber，可以在這裡處理
                if !newValue {
                    userSettings.globalPhoneNumber = "" // 清除手機號碼
                }
            }
        )
    }

    var body: some View {
        ZStack {
            // 背景顏色
            LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.5), Color.blue]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Button(action: {
                        // Handle Back Action (Pop to previous view)
                        LocalStorageManager.shared.clearAll()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.gray.opacity(0.5)) // 設置文字顏色為黑色
                            .padding(.leading)
                    }
                    Spacer()
                }
                .padding(.top)
                
                Spacer()
                
                // 中間的標誌
                Text("SwiftiDate")
                    .font(.system(size: 72))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 50)
                
                Spacer()
                
                // 登入選項按鈕
                VStack(spacing: 20) {
                    Button(action: {
                        // 行動電話登入按鈕的動作
                    }) {
                        HStack {
                            Image(systemName: "phone.fill")
                            Text("使用手機號碼登入")
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(25)
                        .padding(.horizontal)
                    }
                    
                    SignInWithAppleButton(
                        onRequest: { request in
                            request.requestedScopes = [.fullName, .email]
                        },
                        onCompletion: { result in
                            switch result {
                            case .success(let authResults):
                                handleAuthorizationResult(authResults)
                            case .failure(let error):
                                print("Authorization failed: \(error.localizedDescription)")
                            }
                        }
                    )
                    .frame(height: 45)
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
                
                HStack {
                    Text("服務協議")
                        .underline()
                        .foregroundColor(.white.opacity(0.8))
                    Text("&")
                        .foregroundColor(.white.opacity(0.8))
                    Text("隱私權政策")
                        .underline()
                        .foregroundColor(.white.opacity(0.8))
                }
                .font(.footnote)
                .padding(.bottom, 20)
            }
            
            // 彈框顯示部分
            if showExistingUserPopup.wrappedValue {
                Color.black.opacity(0.4).ignoresSafeArea() // 背景透明遮罩

                VStack(spacing: 20) {
                    if let photoName = userSettings.photos.first,
                       let image = PhotoUtility.loadImageFromLocalStorage(named: photoName) {
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
                        .font(.subheadline)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        // 確定以此帳號登入
                        print("繼續使用帳號 \(userSettings.globalUserName)")
                        print("Debug - globalPhoneNumber: \(userSettings.globalPhoneNumber)") // Debug globalPhoneNumber
                        
                        appState.isLoggedIn = true // 更新登入狀態
//                        userSettings.objectWillChange.send() // Notify SwiftUI of changes in userSettings

//                        showExistingUserPopup.wrappedValue = false
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
                        showExistingUserPopup.wrappedValue = false
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
        .onAppear {
            // 在 LoginView 出現時加載用戶狀態
            LocalStorageManager.shared.loadUserSettings(into: userSettings)
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserSettings()) // Provide the environment object for UserSettings
            .environmentObject(AppState()) // 提供 AppState 的環境物件
    }
}
