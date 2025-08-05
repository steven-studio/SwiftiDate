//
//  SwipeCardView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/8/18.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

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
    
    // MARK: - Firebase
    private let db = Firestore.firestore()

    // MARK: - Environment & Observed Objects
    @EnvironmentObject var userSettings: UserSettings
    @StateObject private var locationManager = LocationManager()

    // MARK: - State Variables
    @State private var currentIndex = 0
    @State private var offset = CGSize.zero

    // MARK: - UI Controls
    @State private var showCircleAnimation = false
    @State private var showPrivacySettings = false // 控制隱私設置頁面的顯示
    @State private var showWelcomePopup = false    // 初始值為 true，代表剛登入時顯示彈出視窗
    
    @State private var swipedIDs: Set<String> = [] // 存放已滑過的 userIDs
    private var currentUserID: String? {
        Auth.auth().currentUser?.uid
    }
    
    @State private var lastDocument: DocumentSnapshot? = nil
    @State private var isLoading: Bool = false

    // MARK: - Undo Tracking
    /// 記錄最後一次滑動資訊：
    /// - user: 使用者資料
    /// - index: 卡片在陣列中的索引
    /// - isRightSwipe: 是否為向右滑 (Like)
    /// - docID: 此筆滑動資料在 Firebase 中的文件 ID
    @State private var lastSwipedData: (user: User, index: Int, isRightSwipe: Bool, docID: String)?
    // 加一個屬性，記錄最後飛出的 offset
    @State private var lastSwipedOffset: CGSize?

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
    
    // Use the view model
    @StateObject var viewModel = SwipeCardViewModel()
    // If needed, you can pass other environment objects (like UserSettings or LocationManager) here.
    
    var body: some View {
        ZStack {
            if locationManager.authorizationStatus == .authorizedWhenInUse ||
               locationManager.authorizationStatus == .authorizedAlways {
                // 使用者已授權位置存取，顯示滑動卡片畫面
                mainSwipeCardView
                    .blur(radius: userSettings.globalSelectedGender == "none" ? 10 : 0) // ✅ 讓畫面模糊
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
                    // 加上識別標識
                    .accessibility(identifier: "privacySettingsButton")
                }
                Spacer()
            }
            
            // 顯示彈出視窗
            if showWelcomePopup {
                welcomePopupView
            }
        }
        .accessibilityIdentifier("SwipeCardViewIdentifier")
        .edgesIgnoringSafeArea(.all) // 保證圖標能貼近螢幕邊緣
        .fullScreenCover(isPresented: $showPrivacySettings) {
            PrivacySettingsView(isPresented: $showPrivacySettings)
        }
        .onReceive(NotificationCenter.default.publisher(for: .undoSwipeNotification)) { _ in
            viewModel.undoSwipe()
            print("Got undo notification!")
        }
        .onAppear {
            viewModel.userSettings = userSettings
            fetchSwipes()
        }
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
                    // 先把基礎的堆疊位移
                    let baseY = CGFloat(index - currentIndex) * 10
                    let rotationAngle = isCurrentCard ? Double(offset.width / 40) : 0
                    let zIndexValue = Double(users.count - index)
                    let scaleValue = isCurrentCard ? 1.0 : 0.95

                    SwipeCard(user: user)
                        .offset(
                            x: isCurrentCard ? offset.width : 0,
                            y: isCurrentCard ? offset.height : CGFloat(index - currentIndex) * 10
                        )
                        .scaleEffect(scaleValue)
                        .rotationEffect(.degrees(rotationAngle))
                        .gesture(
                            isCurrentCard ? DragGesture()
                                .onChanged { gesture in
                                    self.offset = gesture.translation
                                }
                                .onEnded { value in
                                    
                                    // 1) 抓出預估結束時的 x / y 偏移
                                    let predictedX = value.predictedEndTranslation.width
                                    let predictedY = value.predictedEndTranslation.height

                                    // 2) 根據門檻來判斷是否左滑或右滑
                                    if predictedX > 100 {
                                        withAnimation(.easeInOut) {
                                            offset = CGSize(width: 1000, height: 0)
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            offset = .zero
                                            if currentIndex < users.count - 1 {
                                                currentIndex += 1
                                            }
                                        }
                                    } else if predictedX < -100 {
                                        // ◀︎ 左滑 (dislike)
                                        withAnimation(.easeInOut) {
                                            offset = CGSize(width: -1000, height: 0)
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            offset = .zero
                                            if currentIndex < users.count - 1 {
                                                currentIndex += 1
                                            }
                                        }
                                    } else {
                                        // 回彈，不夠力就歸位
                                        withAnimation(.spring()) {
                                            offset = .zero
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
    }
    
    // 先抓「已滑過」的紀錄
    func fetchSwipes() {
        db.collection("swipes")
            .whereField("userID", isEqualTo: currentUserID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("取得 swipes 失敗：\(error)")
                    return
                }
                
                var swipedSet = Set<String>()
                snapshot?.documents.forEach { doc in
                    let data = doc.data()
                    if let targetID = data["targetID"] as? String {
                        swipedSet.insert(targetID)
                    }
                }
                
                self.swipedIDs = swipedSet
                // 有了 swipedIDs 之後，再去抓潛在對象
                self.loadUsers(pageSize: 20, lastDocument: nil)
            }
    }
    
    func loadUsers(pageSize: Int = 20, lastDocument: DocumentSnapshot? = nil) {
        guard !isLoading else { return } // 防止重複加載
        isLoading = true
        
        // 如果d想先篩選資料，例如：只顯示男女、年齡區間，可在這裡加 .whereField(...)
        var query = db.collection("users")
            .order(by: "createdAt", descending: false)  // 假設你的 user document 有 "createdAt" 欄位
            .limit(to: pageSize)
        
        // 若有上一批的最後一筆資料，就從那邊繼續
        if let lastDoc = lastDocument {
            query = query.start(afterDocument: lastDoc)
        }
        
        query.getDocuments { snapshot, error in
            self.isLoading = false
            
            if let error = error {
                print("取得 users 失敗：\(error)")
                return
            }
            
            guard let docs = snapshot?.documents, !docs.isEmpty else {
                print("沒有更多資料或 docs 為空")
                return
            }
            
            // 建立一個臨時陣列，去解析回傳文件
            var tempUsers: [User] = []
            
            for doc in docs {
                let data = doc.data()
                let id = doc.documentID
                
                // 解析成 User 結構
                if let name = data["name"] as? String,
                   let age = data["age"] as? Int,
                   let zodiac = data["zodiac"] as? String,
                   let location = data["location"] as? String,
                   let height = data["height"] as? Int,
                   let photos = data["photos"] as? [String] {
                    
                    // 已滑過 or 自己 就跳過
                    if self.swipedIDs.contains(id) || id == self.currentUserID {
                        continue
                    }
                    
                    let user = User(
                        id: id,
                        name: name,
                        age: age,
                        zodiac: zodiac,
                        location: location,
                        height: height,
                        photos: photos
                    )
                    tempUsers.append(user)
                }
            }
            
            // 把新抓到的 user 陣列「接續」到 self.users
            self.users.append(contentsOf: tempUsers)
            
            // 更新 lastDocument，為下一頁做準備
            self.lastDocument = docs.last
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
    }
}

extension Notification.Name {
    static let undoSwipeNotification = Notification.Name("undoSwipeNotification")
}

struct SwipeCardView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeCardView()
            .environmentObject(UserSettings()) // ✅ 加入 userSettings
            .previewDevice("iPhone 15 Pro Max") // ✅ 指定預覽設備
    }
}
