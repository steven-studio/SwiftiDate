//
//  SwipeCardView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/8/18.
//

import SwiftUI

struct User {
    let id: String
    let name: String
    let age: Int
    let zodiac: String
    let location: String
    let height: Int
    let photos: [String]
}

struct SwipeCardView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var offset = CGSize.zero
    @State private var showCircleAnimation = false
    @State private var showPrivacySettings = false // 控制隱私設置頁面的顯示
    @EnvironmentObject var userSettings: UserSettings
    @State private var showWelcomePopup = false // 初始值為 true，代表剛登入時顯示彈出視窗

    // List of users and current index
    @State private var users: [User] = [
        User(id: "userID_2", name: "後照鏡被偷", age: 20, zodiac: "雙魚座", location: "桃園市", height: 172, photos: [
            "userID_2_photo1", "userID_2_photo2"
        ]),
        User(id: "userID_3", name: "小明", age: 22, zodiac: "天秤座", location: "台北市", height: 180, photos: [
            "userID_3_photo1", "userID_3_photo2", "userID_3_photo3", "userID_3_photo4", "userID_3_photo5", "userID_3_photo6"
        ]),
        User(id: "userID_4", name: "小花", age: 25, zodiac: "獅子座", location: "新竹市", height: 165, photos: [
            "userID_4_photo1", "userID_4_photo2", "userID_4_photo3"
        ])
        // Add more users here
    ]
    @State private var currentIndex = 0
    
    var body: some View {
        ZStack {
            if locationManager.authorizationStatus == .authorizedWhenInUse ||
               locationManager.authorizationStatus == .authorizedAlways {
                // 使用者已授權位置存取，顯示滑動卡片畫面
                mainSwipeCardView
            } else {
                // 使用者未授權位置存取，顯示提示畫面
                locationPermissionPromptView
            }

            // 右上角的圖標，固定在整個螢幕的右上角
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        // 顯示隱私設置畫面
                        showPrivacySettings = true
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.gray)
                            .font(.system(size: 30))
                            .padding(.top, 50)
                            .padding(.trailing, 20)
                    }
                }
                Spacer()
            }
            
            // 顯示彈出視窗
            if showWelcomePopup {
                welcomePopupView
            }
        }
        .edgesIgnoringSafeArea(.all) // 保證圖標能貼近螢幕邊緣
        .fullScreenCover(isPresented: $showPrivacySettings) {
            PrivacySettingsView(isPresented: $showPrivacySettings)
        }
        .background(
            userSettings.globalUserGender == .female ?
                LinearGradient(
                    gradient: Gradient(colors: [Color.pink.opacity(0.1), Color.purple.opacity(0.2)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            :
                LinearGradient( // ✅ 確保男性用戶也使用 LinearGradient
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.gray.opacity(0.2)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
        )
    }
    
    // 主滑動卡片畫面
    var mainSwipeCardView: some View {
        ZStack {
            if showCircleAnimation {
                // 動態圓圈動畫頁面
                CircleExpansionView()
            } else {
                // 從後往前顯示卡片
                ForEach(Array(users[currentIndex..<min(currentIndex + 3, users.count)]).reversed(), id: \.id) { user in
                    let index = users.firstIndex(where: { $0.id == user.id }) ?? 0
                    let isCurrentCard = index == currentIndex
                    let yOffset = CGFloat(index - currentIndex) * 10
                    let rotationAngle = isCurrentCard ? Double(offset.width / 10) : 0
                    let zIndexValue = Double(users.count - index)
                    let scaleValue = isCurrentCard ? 1.0 : 0.95
                    let xOffset = isCurrentCard ? offset.width : 0

                    SwipeCard(user: user)
                        .offset(x: xOffset, y: yOffset)
                        .scaleEffect(scaleValue)
                        .rotationEffect(.degrees(rotationAngle))
                        .gesture(
                            isCurrentCard ? DragGesture()
                                .onChanged { gesture in
                                    withAnimation(nil) {
                                        self.offset = gesture.translation
                                    }
                                }
                                .onEnded { _ in
                                    withAnimation(nil) {
                                        if self.offset.width > 120 {
                                            // Like gesture (右滑)
                                            handleSwipe(rightSwipe: true)
                                        } else if self.offset.width < -150 {
                                            // Dislike gesture (左滑)
                                            handleSwipe(rightSwipe: false)
                                        } else {
                                            // 如果滑動不夠，重置偏移
                                            self.offset = .zero
                                        }
                                    }
                                }
                            : nil
                        )
                        .zIndex(zIndexValue) // 控制卡片的顯示層級
                        .animation(nil, value: offset) // 禁止不必要的動畫
                }
            }
        }
        .background(
            userSettings.globalUserGender == .female ?
                LinearGradient(
                    gradient: Gradient(colors: [Color.pink.opacity(0.1), Color.purple.opacity(0.2)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            :
                LinearGradient( // ✅ 確保男性用戶也使用 LinearGradient
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.gray.opacity(0.2)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
        )
    }
    
    // Handle swipe action
    func handleSwipe(rightSwipe: Bool) {
        if rightSwipe {
            print("Like")
            userSettings.globalLikeCount += 1
        } else {
            print("Dislike")
        }

        // Move to the next user after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Go to the next user if available
            if currentIndex < users.count - 1 {
                currentIndex += 1
            } else {
                // No more users, show animation
                withAnimation {
                    showCircleAnimation = true
                }
                print("No more users")
            }
            // Reset offset
            self.offset = .zero
        }
    }
    
    // 位置權限提示畫面
    var locationPermissionPromptView: some View {
        VStack {
            Spacer()
            Image(systemName: "location.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
            Text("來認識附近的新朋友吧")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)

            Text("SwiftiDate 需要你的 \"位置權限\" 才能幫你找到附近好友哦")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()

            Button(action: {
                locationManager.requestPermission()
            }) {
                Text("前往設置")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
            }
            Spacer()
        }
        .padding()
    }
    
    var welcomePopupView: some View {
        ZStack {
            // 半透明背景，覆蓋全屏
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .frame(width: 300, height: 400)
                        .shadow(radius: 10)
                    
                    VStack {
                        Image(systemName: "person.fill.checkmark")
                            .font(.system(size: 80))
                            .foregroundColor(.green)
                            .padding(.top, 40)
                        
                        Text("你喜歡什麼樣類型的？")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top, 20)
                        
                        Text("我們會根據你的左滑和右滑了解你喜歡的類型，為你推薦更優質的用戶。")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        
                        Spacer()
                        
                        Button(action: {
                            showWelcomePopup = false // 點擊按鈕時關閉彈出視窗
                        }) {
                            Text("知道了，開始吧！")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .cornerRadius(10)
                                .padding(.horizontal, 40)
                                .padding(.bottom, 20)
                        }
                    }
                    .padding()
                }
                .frame(width: 300, height: 400)
                Spacer()
            }
        }
    }
}

// 單個卡片的顯示
struct SwipeCard: View {
    var user: User
    @State private var currentPhotoIndex = 0 // 用來追蹤目前顯示的照片索引
    @EnvironmentObject var userSettings: UserSettings

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
                    
                    // 顯示用戶名稱與年齡
                    Text("\(user.name), \(user.age)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // 顯示用戶的標籤
                    HStack(spacing: 10) {
                        // 星座標籤
                        HStack(spacing: 5) {
                            Image(systemName: "bolt.circle.fill") // 替換為合適的星座圖示
                            Text(user.zodiac)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.8))
                        .foregroundColor(.white)
                        .clipShape(Capsule())

                        // 地點標籤
                        HStack(spacing: 5) {
                            Image(systemName: "location.fill")
                            Text(user.location)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.8))
                        .foregroundColor(.white)
                        .clipShape(Capsule())

                        // 身高標籤
                        HStack(spacing: 5) {
                            Image(systemName: "ruler")
                            Text("\(user.height) cm")
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.8))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    }
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading) // 讓標籤靠左對齊
                    
                    // 底部五個按鈕
                    HStack {
                        Button(action: {
                            // Undo action
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
    }
}

struct SwipeCardView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeCardView()
            .environmentObject(UserSettings()) // ✅ 加入 userSettings
            .previewDevice("iPhone 15 Pro Max") // ✅ 指定預覽設備
    }
}
