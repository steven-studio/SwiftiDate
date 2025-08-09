//
//  UserGenderSelectionView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/4.
//

import Foundation
import SwiftUI

enum GenderType: String {
    case male = "男生"
    case female = "女生"
    // 若想支援其他性別或自訂選項，可以在這裡新增
}

struct UserGenderSelectionView: View {
    @State private var selectedGender: GenderType? = nil
    @State private var showUploadPhotoView = false       // ← 新增
    @EnvironmentObject var userSettings: UserSettings  // 若需要儲存到全局設定
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 32) {
            HStack {
                Button(action: {
                    // 返回上一頁前追蹤返回事件
                    AnalyticsManager.shared.trackEvent("UserGenderSelection_BackTapped", parameters: nil)
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.gray.opacity(0.5)) // 設置文字顏色為黑色
                        .padding(.leading)
                }
                Spacer()
            }
            .padding(.top)
            
            // 標題
            Text("你是…")
                .font(.title)
                .bold()
                .padding(.bottom, 20)
            
            // 性別選擇區塊
            HStack(spacing: 60) {
                // 女生按鈕
                VStack {
                    // 圖示部分，可換成你自己的圖片資源
                    Image("icon_female")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .onTapGesture {
                            selectedGender = .female
                        }
                        .grayscale(selectedGender == .female ? 0 : 1)
                    
                    Text("女生")
                        .font(.headline)
                }
                
                // 男生按鈕
                VStack {
                    Image("icon_male")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .onTapGesture {
                            selectedGender = .male
                        }
                        .grayscale(selectedGender == .male ? 0 : 1)
                    
                    Text("男生")
                        .font(.headline)
                }
            }
            
            Spacer()
            
            // 「繼續」按鈕
            Button(action: {
                // 當使用者點擊「繼續」後的行為
                if let gender = selectedGender {
                    // 將性別儲存到 userSettings 或傳給後端
                    userSettings.globalSelectedGender = gender.rawValue
                    print("使用者選擇的性別：\(gender.rawValue)")
                    showUploadPhotoView = true           // ← 觸發跳轉
                }
            }) {
                Text("繼續")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedGender == nil ? Color.gray : Color.green)
                    .foregroundColor(.white)
                    .frame(width: 300)
                    .cornerRadius(25)
            }
            .disabled(selectedGender == nil)
            .padding(.horizontal, 20)
        }
        .padding()
        // 彈出 UploadPhotoView
        .fullScreenCover(isPresented: $showUploadPhotoView) {
            UploadPhotoView(
                selectedCountryCode: Binding(
                    get: { userSettings.globalCountryCode },
                    set: { userSettings.globalCountryCode = $0 }
                ),
                phoneNumber: Binding(
                    get: { userSettings.globalPhoneNumber },
                    set: { userSettings.globalPhoneNumber = $0 }
                )
            )
            // 如果 AppState / UserSettings 已經在更上層用 .environmentObject 注入，
            // 這裡其實可以不用再補，但補上也OK（要確保是同一份物件）
            .environmentObject(userSettings)
            .environmentObject(appState)
        }
    }
}

struct UserGenderSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        // 建議提供預覽時的 userSettings 或其他 EnvironmentObject
        UserGenderSelectionView()
            .environmentObject(UserSettings())
            .environmentObject(AppState())
            .previewDevice("iPhone 15 Pro")
    }
}
