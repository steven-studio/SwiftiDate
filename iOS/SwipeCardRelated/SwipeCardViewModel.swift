//
//  SwipeCardViewModel.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/16.
//

import SwiftUI
import FirebaseFirestore

// MARK: - ViewModel
/// This is the view model for our swipe card view. It holds the state and logic for:
/// - Which card is currently on top
/// - The current drag offset (for moving the card)
/// - The “like” count and undo logic
/// - Loading and recording swipe data (here Firebase is simulated for simplicity)
class SwipeCardViewModel: ObservableObject {
    // Firebase reference (if needed)
    private let db = Firestore.firestore()
    private let currentUserID = "abc123"
    
    // Inject UserSettings from the view.
    // (We use an implicitly unwrapped optional so we know it must be assigned.)
    var userSettings: UserSettings!
    
    // MARK: - Published Properties (State)
    @Published var currentIndex: Int = 0
    @Published var offset: CGSize = .zero
    @Published var showCircleAnimation: Bool = false
    @Published var swipedIDs: Set<String> = []
    
    // Undo tracking:
    // This holds information about the last swiped card so that an undo can be performed.
    @Published var lastSwipedData: (user: User, index: Int, isRightSwipe: Bool, docID: String)?
    // Also record the offset at which the card flew out.
    @Published var lastSwipedOffset: CGSize?
    
    // Count of likes (right swipes)
    @Published var likeCount: Int = 0
    
    // The list of user cards. (In a real app, these would be loaded from a server.)
    @Published var users: [User] = [
        User(
            id: "userID_2",
            name: "後照鏡被偷",
            age: 20,
            zodiac: "雙魚座",
            location: "桃園市",
            height: 172,
            photos: ["userID_2_photo1", "userID_2_photo2"]
        ),
        User(
            id: "userID_3",
            name: "小明",
            age: 22,
            zodiac: "天秤座",
            location: "台北市",
            height: 180,
            photos: ["userID_3_photo1", "userID_3_photo2", "userID_3_photo3", "userID_3_photo4", "userID_3_photo5", "userID_3_photo6"]
        ),
        User(
            id: "userID_4",
            name: "小花",
            age: 25,
            zodiac: "獅子座",
            location: "新竹市",
            height: 165,
            photos: ["userID_4_photo1", "userID_4_photo2", "userID_4_photo3"]
        )
        // Add more users here if needed.
    ]
    
    // MARK: - Business Logic Functions
    
    /// Moves the card off-screen with an animation.
    func swipeOffScreen(toRight: Bool, predictedX: CGFloat, predictedY: CGFloat) {
        // 先決定要飛到螢幕外多遠
        // 你可以用一個固定值 1000，或動態計算
        let flyDistance: CGFloat = 1000
        
        // 計算 y 偏移量，維持差不多的角度
        // 例如：y / x 比例 * flyDistance
        let ratio = predictedY / predictedX
        let finalY = ratio * flyDistance
        
        // 最後的 x：右滑就是 +1000，左滑就是 -1000
        let finalX = toRight ? flyDistance : -flyDistance
        
        // 執行動畫
        withAnimation(.easeOut(duration: 0.4)) {
            offset = CGSize(width: finalX, height: finalY)
        }
        
        // 把這個「飛出去」的 offset 存起來
        self.lastSwipedOffset = CGSize(width: finalX, height: finalY)
        
        // 0.4秒後，再切換到下一張
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            // 這裡就可以呼叫 handleSwipe()，或直接做 currentIndex += 1
            self.handleSwipe(rightSwipe: toRight)
        }
    }
    
    /// Called after a swipe has been completed.
    func handleSwipe(rightSwipe: Bool) {
        // 先做本地端的暫時 UI 效果 (例如：卡片飛出去)
        // ...
        
        // 確保 currentIndex 還在有效範圍內
        guard currentIndex < users.count else {
            print("Error: currentIndex 超出陣列範圍，無法繼續滑卡。")
            return
        }
        
        // === 1. 建立 Firebase 參考 ===
        let newDocRef = db.collection("swipes").document()
        
        // === 2. 準備要上傳的資料 ===
        let data: [String: Any] = [
            "userID": "<你當前使用者的ID>",
            "targetID": users[currentIndex].id,
            "isLike": rightSwipe,
            "timestamp": FieldValue.serverTimestamp() // Firestore 會自動帶入雲端時間
        ]
        
        // === 3. 寫進 Firestore ===
        newDocRef.setData(data) { error in
            if let error = error {
                print("寫入 Firestore 失敗: \(error)")
                // 這裡可以根據需求做錯誤處理 (UI 還原)
                //                return
            }
            
            // ★ 在這裡加上行為分析 (Card Swipe) ★
            AnalyticsManager.shared.trackEvent("card_swipe", parameters: [
                "target_id": self.users[self.currentIndex].id,
                "is_like": rightSwipe
            ])
            
            // === 4. 成功後，紀錄這次滑卡資料 ===
            self.lastSwipedData = (
                user: self.users[self.currentIndex],
                index: self.currentIndex,
                isRightSwipe: rightSwipe,
                docID: newDocRef.documentID
            )
            
            // Like 的話，依你原本邏輯，加個計數：
            if rightSwipe {
                self.userSettings.globalLikeCount += 1
            }
            
            // === UI：前往下一張卡 ===
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self.currentIndex < self.users.count - 1 {
                    self.currentIndex += 1
                } else {
                    // 沒有更多卡了
                    withAnimation {
                        self.showCircleAnimation = true
                    }
                }
                self.offset = .zero
            }
        }
    }
    
    /// Undoes the last swipe, moving the card back to center.
    func undoSwipe() {
        guard let data = lastSwipedData else {
            print("❌ undoSwipe - lastSwipedData == nil，沒有可以撤回的資料")
            // 沒有可以撤回的資料
            return
        }
        print("✅ undoSwipe - lastSwipedData:", data)
        
        let docRef = db.collection("swipes").document(data.docID)
        
        // 這裡示範「刪除」的作法
        docRef.delete { error in
            if let error = error {
                print("刪除 Firestore 紀錄失敗: \(error)")
                //                return
            }
            
            // ★ 在這裡加上行為分析 (Swipe Undo) ★
            AnalyticsManager.shared.trackEvent("card_swipe_undo", parameters: [
                "target_id": data.user.id,
                "was_like": data.isRightSwipe
            ])
            
            // 如果上次是 Like，就把 like count 加回來
            if data.isRightSwipe {
                self.userSettings.globalLikeCount -= 1
            }
            
            // UI 邏輯：將 currentIndex 拉回上一張
            self.currentIndex = data.index
            
            // 3) 把卡片「從飛走位置」飛回中心
            //    如果你想「真實飛回」，就把 offset 設為當初的飛出位置
            //    如果你沒存過當時 offset，可以直接設定一個 (±1000, 0) 再動畫回來
            if let oldOffset = self.lastSwipedOffset {
                // 先瞬移到飛出去的位置
                self.offset = oldOffset
            } else {
                // 若沒存就假設往右飛
                self.offset = CGSize(width: 1000, height: 0)
            }
            
            // 4) 用動畫拉回到 .zero
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 5.0)) {
                    self.offset = .zero
                }
            }
            
            // 5) 關閉沒卡動畫 (假如本來進入沒卡圈圈動畫了)
            withAnimation {
                self.showCircleAnimation = false
            }
            
            // 清空，代表只能撤回最後一次
            self.lastSwipedData = nil
        }
    }
}
