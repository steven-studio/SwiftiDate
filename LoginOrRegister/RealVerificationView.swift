//
//  RealVerificationView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/3.
//

import Foundation
import SwiftUI

struct RealVerificationView: View {
    @EnvironmentObject var appState: AppState // ✅ 存取全局登入狀態
    @EnvironmentObject var userSettings: UserSettings // ✅ 存取用戶設置
    
    @Binding var selectedCountryCode: String
    @Binding var phoneNumber: String
    @State private var isVerified = false  // ✅ 是否通過真人驗證
    @State private var message = "請依指示轉頭"  // ✅ 提示訊息
//    @State private var showUploadPhoto = false // ✅ 是否跳轉到上傳照片頁面
    @State private var showPasswordLoginView = false
    @State private var showCreatePasswordView = false

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // 返回上一頁前記錄事件
                    AnalyticsManager.shared.trackEvent("RealVerification_BackTapped", parameters: nil)
                    // 這裡可以加入返回的行為，例如關閉頁面或其他邏輯
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.black.opacity(0.5)) // 設置文字顏色為黑色
                        .padding(.leading)
                }
                Spacer()
            }
            .padding(.top)
            
            Text("真人驗證")
                .font(.title)
                .padding()

            Text(message)
                .foregroundColor(.blue)
                .font(.headline)
                .padding()

            FaceTrackingView(isVerified: $isVerified, message: $message)
                .frame(height: 400)  // 設定 AR 追蹤畫面大小

            if isVerified {
                Text("✅ 真人驗證成功！")
                    .foregroundColor(.green)
                    .font(.title)
                    .padding()
                
                Button(action: {
                    AnalyticsManager.shared.trackEvent("RealVerification_ContinuePhotoVerificationTapped", parameters: nil)
//                    showUploadPhoto = true
                    showPasswordLoginView = true
                }) {
                    Text("繼續進行照片驗證")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .padding()
        .fullScreenCover(isPresented: $showCreatePasswordView) {
            CreatePasswordView()  // 依照你的 PasswordLoginView 的初始設定傳入必要的參數
                .environmentObject(appState)
                .environmentObject(userSettings)
        }
//        .fullScreenCover(isPresented: $showUploadPhoto) { // ✅ 跳轉到照片上傳頁面
//            UploadPhotoView(selectedCountryCode: $selectedCountryCode, phoneNumber: $phoneNumber)
//                .environmentObject(appState) // ✅ 傳遞 AppState
//                .environmentObject(userSettings) // ✅ 傳遞 UserSettings
//        }
        .onAppear {
            // 畫面出現時記錄 Analytics 事件
            AnalyticsManager.shared.trackEvent("RealVerificationView_Appeared", parameters: nil)
        }
        .onChange(of: isVerified) { newValue in
            if newValue {
                AnalyticsManager.shared.trackEvent("RealVerification_Verified", parameters: nil)
                // 驗證通過後直接進入 PasswordLoginView
                showCreatePasswordView = true
            }
        }
    }
}

struct RealVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        RealVerificationView(
            selectedCountryCode: .constant("+886"),
            phoneNumber: .constant("0912345678")
        )
        .environmentObject(AppState())
        .environmentObject(UserSettings())
        .previewDevice("iPhone 15 Pro")
    }
}
