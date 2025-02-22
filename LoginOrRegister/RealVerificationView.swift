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
    @State private var showUploadPhoto = false // ✅ 是否跳轉到上傳照片頁面

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // Handle Back Action (Pop to previous view)
//                    isRegistering = false
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
                    showUploadPhoto = true
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
        .fullScreenCover(isPresented: $showUploadPhoto) { // ✅ 跳轉到照片上傳頁面
            UploadPhotoView(selectedCountryCode: $selectedCountryCode, phoneNumber: $phoneNumber)
                .environmentObject(appState) // ✅ 傳遞 AppState
                .environmentObject(userSettings) // ✅ 傳遞 UserSettings
        }
    }
}
