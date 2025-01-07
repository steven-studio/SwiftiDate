//
//  ChatView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/21.
//

import Foundation
import SwiftUI
import Firebase

struct ChatView: View {
    @EnvironmentObject var userSettings: UserSettings
    // 使用 userSettings.globalUserID 來取得 globalUserID

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
    @State private var chatMessages: [UUID: [Message]] = [:]

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
                        selectedChat = nil // Reset to show ChatView again
                    })
                } else if showInteractiveContent {
                    InteractiveContentView(onBack: { // Add this closure to handle onBack for InteractiveContentView
                        showInteractiveContent = false // Reset to show ChatView again
                    })
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
                                        showTurboPurchaseView = true // Navigate to TurboPurchaseView
                                    }
                                    
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
                                .padding(.horizontal)
                            }
                            
                            // 聊天
                            Text("聊天")
                                .font(.headline)
                                .padding(.leading)
                            
                            // Add the 'WhoLikedYouView' at the top
                            Button(action: {
                                showTurboView = true // Navigate to TurboView
                            }) {
                                WhoLikedYouView()
                                    .padding(.top)
                            }

                            // 使用 List 顯示聊天對話
                            ForEach(chatData) { chat in
                                if let messages = chatMessages[chat.id] {
                                    Button(action: {
                                        if chat.name == "SwiftiDate" { // Adjust to your actual name for SwiftiDate
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
                                                    // Handle unmatch action
                                                    print("解除配對 tapped")
                                                } label: {
                                                    Text("解除配對")
                                                }
                                                .tint(.gray)

                                                // "修改備註名稱" button
                                                Button {
                                                    // Handle rename action
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
            .navigationTitle("聊天") // Ensure this is applied to the VStack
            .onAppear {
                chatDataString = ""
                if chatDataString.isEmpty || chatMessagesString.isEmpty {
                    // 如果本地的 chatDataString 或 chatMessagesString 為空，就從 Firebase 加載
                    print("Loading data from Firebase as local storage is empty")
                    readDataFromFirebase()
                } else {
                    // 如果本地有儲存的數據，從本地載入
                    loadUserMatchesFromAppStorage()
                    loadChatDataFromAppStorage()
                    loadChatMessagesFromAppStorage()
                    print("Loaded data from local storage")
                }
            }
            .fullScreenCover(isPresented: $showTurboView) {
                // Pass the selectedTab to TurboView
                TurboView(contentSelectedTab: $contentSelectedTab, turboSelectedTab: $selectedTurboTab, showBackButton: true, onBack: {
                    showTurboView = false // This dismisses the TurboView
                })
            }
            .sheet(isPresented: $showTurboPurchaseView) {
                TurboPurchaseView() // Present TurboPurchaseView when showTurboPurchaseView is true
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
            }
        } catch {
            print("Failed to decode chatMessages: \(error)")
        }
    }

    // 添加或更新聊天消息
    private func updateChatMessages(for chatID: UUID, messages: [Message]) {
        chatMessages[chatID] = messages
        saveChatMessagesToAppStorage() // 保存至 AppStorage
    }
}

struct ChatView_Previews: PreviewProvider {
    @State static var contentSelectedTab = 3 // Add the required state variable
    
    static var previews: some View {
        ChatView(contentSelectedTab: $contentSelectedTab) // Pass the binding to the contentSelectedTab
            .environmentObject(UserSettings()) // 注入 UserSettings
    }
}
