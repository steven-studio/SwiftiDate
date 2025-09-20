//
//  MainViewSwipeDataSource.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/9/20.
//

import SwiftUI
import SwipeCardKit

// MARK: - 自定義 DataSource
class MainViewSwipeDataSource: SwipeDataSource {
    func fetchInitialCards() async throws -> [User] {
        print("🔵 MainViewSwipeDataSource.fetchInitialCards called")
        
        // 返回包含圖片和影片的用戶資料
        let users = [
            User(
                id: "1",
                name: "艾莉亞",
                age: 25,
                zodiac: "天秤座",
                location: "台北市",
                height: 165,
                medias: [
                    Media(url: "https://picsum.photos/300/400?random=1", type: .image),
                    Media(url: "https://picsum.photos/300/400?random=11", type: .image),
                    Media(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4", type: .video)
                ]
            ),
            User(
                id: "2",
                name: "傑克",
                age: 28,
                zodiac: "獅子座",
                location: "高雄市",
                height: 180,
                medias: [
                    Media(url: "https://picsum.photos/300/400?random=2", type: .image),
                    Media(url: "https://picsum.photos/300/400?random=12", type: .image),
                    Media(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4", type: .video)
                ]
            ),
            User(
                id: "3",
                name: "莎拉",
                age: 23,
                zodiac: "雙魚座",
                location: "台中市",
                height: 170,
                medias: [
                    Media(url: "https://picsum.photos/300/400?random=3", type: .image),
                    Media(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4", type: .video),
                    Media(url: "https://picsum.photos/300/400?random=13", type: .image)
                ]
            ),
            User(
                id: "4",
                name: "麥克",
                age: 30,
                zodiac: "水瓶座",
                location: "台南市",
                height: 175,
                medias: [
                    Media(url: "https://picsum.photos/300/400?random=4", type: .image),
                    Media(url: "https://picsum.photos/300/400?random=14", type: .image)
                ]
            ),
            User(
                id: "5",
                name: "艾瑪",
                age: 27,
                zodiac: "處女座",
                location: "桃園市",
                height: 168,
                medias: [
                    Media(url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4", type: .video),
                    Media(url: "https://picsum.photos/300/400?random=5", type: .image),
                    Media(url: "https://picsum.photos/300/400?random=15", type: .image)
                ]
            )
        ]
        
        print("🔵 Returning \(users.count) users with images and videos")
        for (index, user) in users.enumerated() {
            print("   \(index): \(user.name) - \(user.medias.count) media files")
        }
        
        // 模擬 API 延遲
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 秒
        
        return users
    }
    
    func observeCards() -> AsyncStream<[User]> {
        return AsyncStream { continuation in
            continuation.finish()
        }
    }
    
    func send(action: SwipeAction, userID: String) async throws {
        switch action {
        case .like:
            print("❤️ 用戶喜歡了: \(userID)")
        case .nope:
            print("❌ 用戶不喜歡: \(userID)")
        case .rewind:
            print("↩️ 用戶撤銷了: \(userID)")
        }
    }
}
