//
//  ChatView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/21.
//

import Foundation
import SwiftUI
import Firebase
import Vision

struct ChatView: View {
    @EnvironmentObject var userSettings: UserSettings
    // 使用 userSettings.globalUserID 來取得 globalUserID
    @EnvironmentObject var appState: AppState

    @State private var selectedChat: Chat? = nil // State variable to handle navigation
    @AppStorage("userMatchesStorage") private var userMatchesString: String = "" // 使用 AppStorage 儲存 JSON 字符串
    @AppStorage("chatDataStorage") private var chatDataString: String = "" // 使用 AppStorage 儲存 JSON 字符串
    @AppStorage("chatMessagesStorage") private var chatMessagesString: String = "" // 使用 AppStorage 儲存 JSON 字符串
    @State private var showInteractiveContent = false // State variable to control InteractiveContentView display
    @State private var showTurboPurchaseView = false // State variable to control TurboPurchaseView display
    @State private var showTurboView = false // State variable to control TurboView display
    @State private var selectedTurboTab: Int = 0 // State variable to control Turbo tab selection
    @Binding var contentSelectedTab: Int // Use a binding variable for selectedTab from ContentView
    
    @State private var userMatches: [UserMatch] = []
    
    @State private var chatData: [Chat] = []
    
    // Dictionary to store messages for each chat
    @State private var interactiveMessage: [Message] = []
    @State private var chatMessages: [UUID: [Message]] = [:]
    @State private var                     showSafetyCenterView = false
    @State private var showSearchField = false
    @State private var searchText = ""
    
    // 篩選後的新配對
    private var filteredMatches: [UserMatch] {
        if searchText.isEmpty {
            return userMatches
        } else {
            return userMatches.filter { $0.name.contains(searchText) }
        }
    }

    // 篩選後的聊天清單
    private var filteredChats: [Chat] {
        if searchText.isEmpty {
            return chatData
        } else {
            return chatData.filter { $0.name.contains(searchText) }
        }
    }

    init(contentSelectedTab: Binding<Int>) {
        self._contentSelectedTab = contentSelectedTab
    }
    
    func readDataFromFirebase() {
        let ref = Database.database(url: "https://swiftidate-cdff0-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        let userId = userSettings.globalUserID

        // 讀取 userMatches
        ref.child("users").child(userId).child("userMatches").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                print("Failed to decode userMatches data")
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                var userMatches = try JSONDecoder().decode([UserMatch].self, from: jsonData)
                
                // 將 userMatches 倒序排序
                userMatches.reverse()
                
                // 更新 self.userMatches 並存儲到本地
                self.userMatches = userMatches
                self.saveUserMatchesToAppStorage()
            } catch {
                print("Failed to decode userMatches: \(error)")
            }
        }

        // 讀取 chatData
        ref.child("users").child(userId).child("chats").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                print("Failed to decode chats data")
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                var chatData = try JSONDecoder().decode([Chat].self, from: jsonData)

                // 確保 chatData 至少有兩個元素
                if chatData.count > 1 {
                    // 保留第一個元素
                    let firstChat = [chatData[0]]
                    // 倒序排列剩下的元素
                    let reversedChats = chatData[1...].reversed()
                    // 合併結果
                    chatData = firstChat + reversedChats
                }

                self.chatData = chatData
                self.saveChatDataToAppStorage()
            } catch {
                print("Failed to decode chats: \(error)")
            }
        }
        
        print("Path: \(ref.child("users").child(userId).child("chatMessages").description())")
        
        // 讀取 chatMessages
        ref.child("users").child(userId).child("chatMessages").observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                print("Snapshot exists for chatMessages: \(snapshot.value ?? "nil")")
            } else {
                print("Snapshot does not exist for chatMessages")
            }
            guard let value = snapshot.value as? [String: [[String: Any]]] else {
                print("Failed to decode chatMessages data")
                return
            }
            
            var chatMessages: [UUID: [Message]] = [:]
            do {
                for (key, messagesArray) in value {
                    guard let chatId = UUID(uuidString: key) else {
                        print("Invalid UUID: \(key)")
                        continue
                    }
                    
                    print("Processing chat ID: \(chatId)")
                    let jsonData = try JSONSerialization.data(withJSONObject: messagesArray, options: [])
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        print("Serialized JSON for chat \(chatId): \(jsonString)")
                    }
                    
                    do {
                        let messages = try JSONDecoder().decode([Message].self, from: jsonData)
//                        print("Decoded Messages for chat \(chatId): \(messages)")
                        chatMessages[chatId] = messages
                    } catch let DecodingError.dataCorrupted(context) {
                        print("Data corrupted: \(context)")
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found: \(context.debugDescription)")
                        print("Coding Path: \(context.codingPath)")
                    } catch let DecodingError.typeMismatch(type, context) {
                        print("Type '\(type)' mismatch: \(context.debugDescription)")
                        print("Coding Path: \(context.codingPath)")
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found: \(context.debugDescription)")
                        print("Coding Path: \(context.codingPath)")
                    } catch {
                        print("Failed to decode Messages for chat \(chatId): \(error)")
                    }
                }
                
                // Update the state on the main thread
                DispatchQueue.main.async {
                    self.chatMessages = chatMessages
                    print("Final chatMessages dictionary: \(chatMessages)")
                    self.saveChatMessagesToAppStorage()
                }
                
            } catch {
                print("Failed to decode chatMessages: \(error)")
            }
        }
    }

    // 將 userMatches 編碼為 JSON 字符串並存入 AppStorage
    private func saveUserMatchesToAppStorage() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(userMatches)
            userMatchesString = String(data: data, encoding: .utf8) ?? ""
        } catch {
            print("Failed to encode userMatches: \(error)")
        }
    }

    // 將 chatData 編碼為 JSON 字符串並存入 AppStorage
    private func saveChatDataToAppStorage() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(chatData)
            chatDataString = String(data: data, encoding: .utf8) ?? ""
        } catch {
            print("Failed to encode chatData: \(error)")
        }
    }

    // 將 chatMessages 編碼為 JSON 字符串並存入 AppStorage
    private func saveChatMessagesToAppStorage() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(chatMessages)
            chatMessagesString = String(data: data, encoding: .utf8) ?? ""
        } catch {
            print("Failed to encode chatMessages: \(error)")
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if let chat = selectedChat {
                    ChatDetailView(chat: chat, messages: Binding(get: {
                        chatMessages[chat.id] ?? []
                    }, set: { newValue in
                        chatMessages[chat.id] = newValue
                    }), onBack: {
                        // 埋點：返回聊天列表
                        AnalyticsManager.shared.trackEvent("chat_detail_back")
                        selectedChat = nil // Reset to show ChatView again
                    })
                } else if showInteractiveContent {
                    // 找出 chat 名字 == "SwiftiDate"
                    InteractiveContentView(onBack: {
                        // 埋點：關閉互動內容
                        AnalyticsManager.shared.trackEvent("interactive_content_closed")
                        showInteractiveContent = false
                    }, messages: $interactiveMessage)
                    .environmentObject(userSettings)
                } else if showSearchField && filteredMatches.isEmpty {
                    ScrollView {
                        // 使用 List 顯示聊天對話
                        ForEach(filteredChats) { chat in
                            if let messages = chatMessages[chat.id] {
                                Button(action: {
                                    // 埋點：點擊聊天列表中的某個聊天
                                    AnalyticsManager.shared.trackEvent("chat_row_tapped", parameters: [
                                        "chat_id": chat.id.uuidString,
                                        "chat_name": chat.name
                                    ])
                                    if chat.name == "SwiftiDate" { // Adjust to your actual name for SwiftiDate
                                        // 埋點：選擇打開互動內容
                                        AnalyticsManager.shared.trackEvent("interactive_content_opened")
                                        showInteractiveContent = true // Navigate to InteractiveContentView
                                        selectedChat = nil
                                    } else {
                                        showInteractiveContent = false
                                        selectedChat = chat // Navigate to ChatDetailView
                                    }
                                }) {
                                    ChatRow(chat: chat, messages: messages) // Pass messages to ChatRow
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            // "解除配對" button
                                            Button {
                                                // 埋點：點擊解除配對
                                                AnalyticsManager.shared.trackEvent("chat_unmatch_tapped", parameters: [
                                                    "chat_id": chat.id.uuidString
                                                ])
                                                print("解除配對 tapped")
                                            } label: {
                                                Text("解除配對")
                                            }
                                            .tint(.gray)

                                            // "修改備註名稱" button
                                            Button {
                                                // 埋點：點擊修改備註名稱
                                                AnalyticsManager.shared.trackEvent("chat_rename_tapped", parameters: [
                                                    "chat_id": chat.id.uuidString
                                                ])
                                                print("修改備註名稱 tapped")
                                            } label: {
                                                Text("修改備註名稱")
                                            }
                                            .tint(.green)
                                        }
                                }
                            } else {
                                // 如果 messages 不存在，显示 chat.id 作为调试信息
                                Text(chat.id.uuidString)
                            }
                        }
                    }
                } else {
                    // 聊天列表
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            // Custom title for new matches
                            Text("新配對")
                                .font(.headline)
                                .padding(.leading)

                            // 配對用戶的水平滾動
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    // The "More Matches" button
                                    VStack {
                                        ZStack {
                                            Circle()
                                                .fill(Color.purple.opacity(0.1)) // Background circle
                                                .frame(width: 60, height: 60)
                                            
                                            Image(systemName: "bolt.fill")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.purple)
                                            
                                            Circle()
                                                .stroke(Color.white, lineWidth: 0) // Outer white border
                                                .frame(width: 68, height: 68)
                                                .offset(x: 25, y: 25)
                                                .overlay(
                                                    Image(systemName: "plus.circle.fill")
                                                        .foregroundColor(.white)
                                                        .background(Circle().fill(Color.purple))
                                                        .frame(width: 20, height: 20)
                                                        .offset(x: 20, y: 20)
                                                )
                                        }
                                        Text("更多配對")
                                            .font(.caption)
                                            .foregroundColor(.purple)
                                    }
                                    .onTapGesture {
                                        // 埋點：點擊「更多配對」
                                        AnalyticsManager.shared.trackEvent("more_matches_tapped")
                                        showTurboPurchaseView = true // Navigate to TurboPurchaseView
                                    }
                                    
                                    if showSearchField {
                                        // Existing users
                                        ForEach(filteredMatches) { user in
                                            VStack {
                                                if let uiImage = UIImage(named: user.imageName) {
                                                    Image(uiImage: uiImage)
                                                        .resizable()
                                                        .frame(width: 60, height: 60)
                                                        .clipShape(Circle())
                                                } else {
                                                    // Placeholder image when the actual image is not found
                                                    Image(systemName: "person.crop.circle.fill")
                                                        .resizable()
                                                        .frame(width: 60, height: 60)
                                                        .foregroundColor(.gray)
                                                        .clipShape(Circle())
                                                }
                                                
                                                Text(user.name)
                                                    .font(.caption)
                                            }
                                        }

                                    } else {
                                        // Existing users
                                        ForEach(userMatches) { user in
                                            VStack {
                                                if let uiImage = UIImage(named: user.imageName) {
                                                    Image(uiImage: uiImage)
                                                        .resizable()
                                                        .frame(width: 60, height: 60)
                                                        .clipShape(Circle())
                                                } else {
                                                    // Placeholder image when the actual image is not found
                                                    Image(systemName: "person.crop.circle.fill")
                                                        .resizable()
                                                        .frame(width: 60, height: 60)
                                                        .foregroundColor(.gray)
                                                        .clipShape(Circle())
                                                }
                                                
                                                Text(user.name)
                                                    .font(.caption)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            // 聊天
                            Text("聊天")
                                .font(.headline)
                                .padding(.leading)
                            
                            // Add the 'WhoLikedYouView' at the top
                            Button(action: {
                                // 埋點：點擊 WhoLikedYouView
                                AnalyticsManager.shared.trackEvent("who_liked_you_tapped")
                                showTurboView = true // Navigate to TurboView
                            }) {
                                WhoLikedYouView()
                                    .padding(.top)
                            }
                            
                            if showSearchField {
                                // 使用 List 顯示聊天對話
                                ForEach(filteredChats) { chat in
                                    if let messages = chatMessages[chat.id] {
                                        Button(action: {
                                            // 埋點：點擊聊天列表中的某個聊天
                                            AnalyticsManager.shared.trackEvent("chat_row_tapped", parameters: [
                                                "chat_id": chat.id.uuidString,
                                                "chat_name": chat.name
                                            ])
                                            if chat.name == "SwiftiDate" { // Adjust to your actual name for SwiftiDate
                                                // 埋點：選擇打開互動內容
                                                AnalyticsManager.shared.trackEvent("interactive_content_opened")
                                                showInteractiveContent = true // Navigate to InteractiveContentView
                                                selectedChat = nil
                                            } else {
                                                showInteractiveContent = false
                                                selectedChat = chat // Navigate to ChatDetailView
                                            }
                                        }) {
                                            ChatRow(chat: chat, messages: messages) // Pass messages to ChatRow
                                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                                    // "解除配對" button
                                                    Button {
                                                        // 埋點：點擊解除配對
                                                        AnalyticsManager.shared.trackEvent("chat_unmatch_tapped", parameters: [
                                                            "chat_id": chat.id.uuidString
                                                        ])
                                                        print("解除配對 tapped")
                                                    } label: {
                                                        Text("解除配對")
                                                    }
                                                    .tint(.gray)

                                                    // "修改備註名稱" button
                                                    Button {
                                                        // 埋點：點擊修改備註名稱
                                                        AnalyticsManager.shared.trackEvent("chat_rename_tapped", parameters: [
                                                            "chat_id": chat.id.uuidString
                                                        ])
                                                        print("修改備註名稱 tapped")
                                                    } label: {
                                                        Text("修改備註名稱")
                                                    }
                                                    .tint(.green)
                                                }
                                        }
                                    } else {
                                        // 如果 messages 不存在，显示 chat.id 作为调试信息
                                        Text(chat.id.uuidString)
                                    }
                                }
                            } else {
                                // 使用 List 顯示聊天對話
                                ForEach(chatData) { chat in
                                    if let messages = chatMessages[chat.id] {
                                        Button(action: {
                                            // 埋點：點擊聊天列表中的某個聊天
                                            AnalyticsManager.shared.trackEvent("chat_row_tapped", parameters: [
                                                "chat_id": chat.id.uuidString,
                                                "chat_name": chat.name
                                            ])
                                            if chat.name == "SwiftiDate" { // Adjust to your actual name for SwiftiDate
                                                // 埋點：選擇打開互動內容
                                                AnalyticsManager.shared.trackEvent("interactive_content_opened")
                                                showInteractiveContent = true // Navigate to InteractiveContentView
                                                selectedChat = nil
                                            } else {
                                                showInteractiveContent = false
                                                selectedChat = chat // Navigate to ChatDetailView
                                            }
                                        }) {
                                            ChatRow(chat: chat, messages: messages) // Pass messages to ChatRow
                                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                                    // "解除配對" button
                                                    Button {
                                                        // 埋點：點擊解除配對
                                                        AnalyticsManager.shared.trackEvent("chat_unmatch_tapped", parameters: [
                                                            "chat_id": chat.id.uuidString
                                                        ])
                                                        print("解除配對 tapped")
                                                    } label: {
                                                        Text("解除配對")
                                                    }
                                                    .tint(.gray)

                                                    // "修改備註名稱" button
                                                    Button {
                                                        // 埋點：點擊修改備註名稱
                                                        AnalyticsManager.shared.trackEvent("chat_rename_tapped", parameters: [
                                                            "chat_id": chat.id.uuidString
                                                        ])
                                                        print("修改備註名稱 tapped")
                                                    } label: {
                                                        Text("修改備註名稱")
                                                    }
                                                    .tint(.green)
                                                }
                                        }
                                    } else {
                                        // 如果 messages 不存在，显示 chat.id 作为调试信息
                                        Text(chat.id.uuidString)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .toolbar {
                if showSearchField {
                    // 分支1：顯示搜尋列
                    ToolbarItem(placement: .principal) {
                        HStack {
                            HStack(spacing: 8) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)

                                TextField("搜尋配對好友", text: $searchText)
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))  // 可換成其他淺色
                            .cornerRadius(10)
                            .padding(.horizontal, 10)

                            Button("取消") {
                                withAnimation {
                                    searchText = ""
                                    showSearchField = false
                                }
                            }
                            .foregroundColor(.green)
                        }
                    }
                } else {
                    // 中央的標題
                    ToolbarItem(placement: .principal) {
                        Text("聊天")
                            .font(.title2)
                            .bold()
                    }
                    // 左側的 shield 按鈕：進入安全意識小測驗
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            AnalyticsManager.shared.trackEvent("top_right_safety_center_pressed_from_chatview")
                            showSafetyCenterView = true
                        }) {
                            Image(systemName: "shield.fill")
                                .font(.title2)
                                .foregroundColor(.gray) // Set the color to match the design
                                .padding(.trailing, 10)
                        }
                    }
                    // 右側的 magnifyingglass 按鈕：使用名字搜尋聊天記錄
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            // 實作使用者搜尋聊天記錄的邏輯
                            print("使用者點選放大鏡搜尋聊天記錄")
                            showSearchField = true
                        }) {
                            Image(systemName: "magnifyingglass")
                                .font(.title3)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .onAppear {
                // 埋點：ChatView 畫面曝光
                AnalyticsManager.shared.trackEvent("chat_view_appear")
                
                if chatDataString.isEmpty || chatMessagesString.isEmpty {
                    // 如果本地的 chatDataString 或 chatMessagesString 為空，就從 Firebase 加載
                    print("Loading data from Firebase as local storage is empty")
                    // 埋點：從 Firebase 加載聊天資料
                    AnalyticsManager.shared.trackEvent("chat_data_load_from_firebase")
                    readDataFromFirebase()
                } else {
                    // 如果本地有儲存的數據，從本地載入
                    loadUserMatchesFromAppStorage()
                    loadChatDataFromAppStorage()
                    loadChatMessagesFromAppStorage()
                    print("Loaded data from local storage")
                    // 埋點：從本地載入聊天資料
                    AnalyticsManager.shared.trackEvent("chat_data_load_from_local")
                }
                
                if let newId = userSettings.newMatchedChatID {
                    // 埋點：檢測到 newMatchedChatID，進入新的聊天
                    AnalyticsManager.shared.trackEvent("new_matched_chat_found", parameters: [
                        "newMatchedChatID": newId
                    ])
                    let newChat = Chat(
                        id: UUID(),
                        name: "對方暱稱",
                        time: "00:00",
                        unreadCount: 0,
                        phoneNumber: "xxx"
                    )
                    selectedChat = newChat

                    // 清空，避免下次進來又觸發
                    userSettings.newMatchedChatID = nil
                }
            }
            .fullScreenCover(isPresented: $showTurboView) {
                // Pass the selectedTab to TurboView
                TurboView(contentSelectedTab: $contentSelectedTab, turboSelectedTab: $selectedTurboTab, showBackButton: true, onBack: {
                    showTurboView = false // This dismisses the TurboView
                    AnalyticsManager.shared.trackEvent("turbo_view_closed")
                })
            }
            .fullScreenCover(isPresented: $showSafetyCenterView) {
                SafetyCenterView(showSafetyCenterView: $showSafetyCenterView, photos: $userSettings.photos) // 如果全局变量为 true，则显示 SafetyCenterView
                    .environmentObject(userSettings)
                    .onAppear {
                        AnalyticsManager.shared.trackEvent("chat_view_safety_center_appear")
                    }
            }
            .sheet(isPresented: $showTurboPurchaseView) {
                TurboPurchaseView() // Present TurboPurchaseView when showTurboPurchaseView is true
                    .onAppear {
                        AnalyticsManager.shared.trackEvent("turbo_purchase_view_appear")
                    }
            }
        }
    }
    
    // 從 AppStorage 載入 userMatches
    private func loadUserMatchesFromAppStorage() {
        guard !userMatchesString.isEmpty else {
            print("No user matches found in AppStorage")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            if let data = userMatchesString.data(using: .utf8) {
                userMatches = try decoder.decode([UserMatch].self, from: data)
                // 埋點：成功從本地載入 userMatches
                AnalyticsManager.shared.trackEvent("user_matches_loaded", parameters: [
                    "count": userMatches.count
                ])
            }
        } catch {
            print("Failed to decode userMatches: \(error)")
        }
    }
    
    // 從 AppStorage 載入 chatData
    private func loadChatDataFromAppStorage() {
        guard !chatDataString.isEmpty else {
            print("No chat data found in AppStorage")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            if let data = chatDataString.data(using: .utf8) {
                chatData = try decoder.decode([Chat].self, from: data)
                AnalyticsManager.shared.trackEvent("chat_data_loaded", parameters: [
                    "chat_count": chatData.count
                ])
            }
        } catch {
            print("Failed to decode chatData: \(error)")
        }
    }

    // 從 AppStorage 載入聊天消息
    private func loadChatMessagesFromAppStorage() {
        guard !chatMessagesString.isEmpty else {
            print("No chat messages found in AppStorage")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            if let data = chatMessagesString.data(using: .utf8) {
                // 验证 JSON 数据是否有效
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print("Valid JSON: \(jsonObject)")
                } else {
                    print("Invalid JSON format")
                    return
                }
                
                // 尝试解码为 [UUID: [Message]]
                chatMessages = try decoder.decode([UUID: [Message]].self, from: data)
                print("Decoded chatMessages: \(chatMessages)")
                AnalyticsManager.shared.trackEvent("chat_messages_loaded", parameters: [
                    "chats_loaded": chatMessages.count
                ])
            }
        } catch {
            print("Failed to decode chatMessages: \(error)")
        }
    }

    // 添加或更新聊天消息
    private func updateChatMessages(for chatID: UUID, messages: [Message]) {
        chatMessages[chatID] = messages
        saveChatMessagesToAppStorage() // 保存至 AppStorage
        AnalyticsManager.shared.trackEvent("chat_messages_updated", parameters: [
            "chat_id": chatID.uuidString,
            "message_count": messages.count
        ])
    }
}

struct ChatView_Previews: PreviewProvider {
    @State static var contentSelectedTab = 3 // Add the required state variable
    
    static var previews: some View {
        ChatView(contentSelectedTab: $contentSelectedTab) // Pass the binding to the contentSelectedTab
            .environmentObject(UserSettings()) // 注入 UserSettings
    }
}
