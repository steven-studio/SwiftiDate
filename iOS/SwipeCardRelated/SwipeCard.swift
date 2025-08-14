//
//  SwipeCard.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/8/13.
//

import SwiftUI

// 單個卡片的顯示
struct SwipeCard: View {
    var user: Profile
    @State private var currentPhotoIndex = 0 // 用來追蹤目前顯示的照片索引
    @EnvironmentObject var userSettings: UserSettings
    @State private var showFullProfile = false
    
    var body: some View {
        ZStack {
            // 照片預覽界面
            if user.photos.indices.contains(currentPhotoIndex) {
                Image(user.photos[currentPhotoIndex])
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.white, lineWidth: 4))
                    .edgesIgnoringSafeArea(.top)
                    .onTapGesture { value in
                            let screenWidth = UIScreen.main.bounds.width
                            let tapX = value.x // 取得點擊的 X 軸座標

                            if tapX < screenWidth / 2 {
                                // 點擊左半邊，切換到上一張
                                if currentPhotoIndex > 0 {
                                    currentPhotoIndex -= 1
                                }
                            } else {
                                // 點擊右半邊，切換到下一張
                                if currentPhotoIndex < user.photos.count - 1 {
                                    currentPhotoIndex += 1
                                }
                            }
                        }
            } else {
                // 顯示佔位符或錯誤圖像
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
            }

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 5) {
                    ForEach(0..<user.photos.count, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 4)
                            .frame(width: 40, height: 8)
                            .foregroundColor(index == currentPhotoIndex ? .white : .gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 8)
                .padding(.horizontal)
                .cornerRadius(10)

                Spacer()

                VStack {
                    Spacer()

                    // Display variables for optionals
                    let displayName = user.name ?? "用戶"
                    let ageText = user.age.map { String($0) } ?? "—"
                    let zodiacText = user.zodiac ?? "—"
                    let locationText = user.location ?? "—"
                    let heightText = user.height.map { "\($0) cm" } ?? "—"

                    // 顯示用戶名稱與年齡
                    Text("\(displayName), \(ageText)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // 顯示用戶的標籤
                    HStack(spacing: 10) {
                        // 星座標籤
                        HStack(spacing: 5) {
                            Image(systemName: "bolt.circle.fill") // 替換為合適的星座圖示
                            Text(zodiacText)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.8))
                        .foregroundColor(.white)
                        .clipShape(Capsule())

                        // 地點標籤
                        HStack(spacing: 5) {
                            Image(systemName: "location.fill")
                            Text(locationText)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.8))
                        .foregroundColor(.white)
                        .clipShape(Capsule())

                        // 身高標籤
                        HStack(spacing: 5) {
                            Image(systemName: "ruler")
                            Text(heightText)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.8))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        
                        Spacer()
                    }
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading) // 讓標籤靠左對齊

                    // 底部五個按鈕
                    HStack {

                        // MARK: - 這裡把 Undo 實作加上去
                        Button(action: {
                            // 呼叫父視圖的 undoSwipe()
                            // 因為這是獨立組件，要嘛用環境變數、要嘛直接改成 @Binding 或 callback
                            // 最簡單方式：把 undoSwipe 寫在父 View，這裡改成通知父層
                            // 可以將 undoSwipe() 搬到 EnvironmentObject 或者用 NotificationCenter 也可以。
                            // 下面示範用 NotificationCenter 為例：
                            NotificationCenter.default.post(name: .undoSwipeNotification, object: nil)
                        }) {
                            ZStack {
                                // 圓形背景
                                Circle()
                                    .fill(Color.gray.opacity(0.8))
                                    .frame(width: 50, height: 50) // 設定圓的大小

                                VStack {
                                    Image(systemName: "arrow.uturn.backward")
                                        .font(.title)
                                        .foregroundColor(.yellow)
                                }
                            }
                        }

                        Spacer() // 按鈕之間的彈性間距

                        // Dislike button
                        Button(action: {
                            // Dislike action
                        }) {
                            ZStack {
                                // 圓角矩形背景
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.gray.opacity(0.8))
                                    .frame(width: 70, height: 50) // 設定矩形的大小

                                Image(systemName: "xmark")
                                    .font(.system(size: 30, weight: .bold)) // 設定字體大小和粗體
                                    .foregroundColor(.red)
                                    // 加上識別標識
                                    .accessibility(identifier: "xmarkButtonImage")
                            }
                        }

                        Spacer() // 按鈕之間的彈性間距

                        Button(action: {
                            // Message action
                        }) {
                            ZStack {
                                // 圓形背景
                                Circle()
                                    .fill(Color.gray.opacity(0.8))
                                    .frame(width: 50, height: 50) // 設定圓的大小

                                VStack {
                                    Image(systemName: "message.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.gold)
                                }
                            }
                        }

                        Spacer() // 按鈕之間的彈性間距

                        // Dislike button
                        Button(action: {
                            // Dislike action
                        }) {
                            ZStack {
                                // 圓角矩形背景
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.gray.opacity(0.8))
                                    .frame(width: 70, height: 50) // 設定矩形的大小

                                Image(systemName: "heart.fill")
                                    .font(.system(size: 24, weight: .bold)) // 設定字體大小和粗體
                                    .foregroundColor(.green)
                                    // 加上識別標識
                                    .accessibility(identifier: "heartFillButtonImage")
                            }
                        }

                        Spacer() // 按鈕之間的彈性間距

                        Button(action: {
                            // Special feature action
                        }) {
                            ZStack {
                                // 圓形背景
                                Circle()
                                    .fill(Color.gray.opacity(0.8))
                                    .frame(width: 50, height: 50) // 設定圓的大小

                                VStack {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(userSettings.globalUserGender == .male ? .blue : .pink)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height - 200)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)  // <--- 加上這裡
        // ✅ 只在這裡放一顆展開按鈕，固定右下角
        .overlay(alignment: .bottomTrailing) {
            Button {
                showFullProfile = true
            } label: {
                Image(systemName: "chevron.up")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.8))
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 80)
        }
        .fullScreenCover(isPresented: $showFullProfile) {
            FullProfileView(user: user)
        }
    }
}
