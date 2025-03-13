//
//  ProfileHeaderView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/17.
//

import Foundation
import SwiftUI

struct ProfileHeaderView: View {
    @Binding var isShowingEditProfileView: Bool
    @Binding var photos: [String]
    @EnvironmentObject var userSettings: UserSettings // 使用 EnvironmentObject 來存取 UserSettings

    var body: some View {
        HStack {
            ProfileImageView(photoName: photos.first)

            Button(action: {
                // 埋點：點擊編輯按鈕
                AnalyticsManager.shared.trackEvent("edit_profile_button_pressed", parameters: [
                    "user_name": userSettings.globalUserName
                ])
                isShowingEditProfileView = true // 顯示 EditProfileView
            }) {
                Image(systemName: "pencil.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .gray, radius: 4, x: 0, y: 2)
            }
            .offset(x: -25, y: -25)
            .fullScreenCover(isPresented: $isShowingEditProfileView) {
                EditProfileView(photos: $photos)
            }

            VStack(alignment: .leading) {
                HStack {
                    Text(userSettings.globalUserName)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    if userSettings.isSupremeUser {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.black)
                            .font(.system(size: 18))
                            .padding(10) // 添加一些內邊距，讓背景顏色與圖片之間有間隔
                            .background(Color.gold) // 設置背景顏色
                            .clipShape(Circle()) // 如果想讓背景是圓形的，可以使用這個修飾符
                    } else {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .padding(10) // 添加一些內邊距，讓背景顏色與圖片之間有間隔
                            .background(Color.gray.opacity(0.5)) // 設置背景顏色
                            .clipShape(Circle()) // 如果想讓背景是圓形的，可以使用這個修飾符
                    }
                }
                
                if userSettings.globalIsUserVerified {
                    HStack {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.blue)
                        Text("已認證")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                } else {
                    HStack {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.gray.opacity(0.7))
                            .background(Color.white)
                        Text("尚未認證")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            Spacer()
        }
        .padding()
        .onAppear {
            // 埋點：頁面曝光
            AnalyticsManager.shared.trackEvent("profile_header_view_appear", parameters: [
                "user_name": userSettings.globalUserName
            ])
        }
    }
}
