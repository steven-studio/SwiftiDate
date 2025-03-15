//
//  ChatViewModel.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/6.
//

import Foundation
import SwiftUI
import Firebase

class ChatViewModel: ObservableObject {
    // MARK: - Published State
    @Published var selectedChat: Chat? = nil
    @Published var userMatches: [UserMatch] = []
    @Published var chatData: [Chat] = []
    @Published var interactiveMessage: [Message] = []
    @Published var chatMessages: [UUID: [Message]] = [:]
    @Published var showInteractiveContent: Bool = false
    @Published var showTurboPurchaseView: Bool = false
    @Published var showTurboView: Bool = false
    @Published var selectedTurboTab: Int = 0
    @Published var showSafetyCenterView: Bool = false
    @Published var showSearchField: Bool = false
    @Published var searchText: String = ""
    
    // MARK: - AppStorage Keys
    @AppStorage("userMatchesStorage") var userMatchesString: String = ""
    @AppStorage("chatDataStorage") var chatDataString: String = ""
    @AppStorage("chatMessagesStorage") var chatMessagesString: String = ""
    
    // MARK: - Computed Properties for Filtering
    var filteredMatches: [UserMatch] {
        if searchText.isEmpty { return userMatches }
        return userMatches.filter { $0.name.contains(searchText) }
    }
    
    var filteredChats: [Chat] {
        if searchText.isEmpty { return chatData }
        return chatData.filter { $0.name.contains(searchText) }
    }
    
    // MARK: - Data Loading Methods
    func loadChats() {
        readDataFromFirebase()
    }
    
    private let userSettings: UserSettings
    
    init(userSettings: UserSettings) {
        self.userSettings = userSettings
    }
    
    func readDataFromFirebase() {
        let ref = Database.database(url: "https://swiftidate-cdff0-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        let userId = userSettings.globalUserID
        print("userSettings.globalUserID: \(userId)")

        // 讀取 userMatches
        ref.child("users").child(userId).child("userMatches").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                print("Failed to decode userMatches data")
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                print("userMatches json data: \(jsonData)")
                var userMatches = try JSONDecoder().decode([UserMatch].self, from: jsonData)
                
                // 將 userMatches 倒序排序
                userMatches.reverse()
                
                // 更新 self.userMatches 並存儲到本地
                self.userMatches = userMatches
                self.saveUserMatchesToAppStorage()
            } catch {
                // 这里使用 try? 防止在 catch 块中再次抛出错误
                if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []) {
                    print("userMatches json data: \(jsonData)")
                }
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

    // MARK: - AppStorage Save/Load Methods
    func saveUserMatchesToAppStorage() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(userMatches)
            userMatchesString = String(data: data, encoding: .utf8) ?? ""
        } catch {
            print("Failed to encode userMatches: \(error)")
        }
    }
    
    func loadUserMatchesFromAppStorage() {
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
    
    func saveChatDataToAppStorage() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(chatData)
            chatDataString = String(data: data, encoding: .utf8) ?? ""
        } catch {
            print("Failed to encode chatData: \(error)")
        }
    }
    
    func loadChatDataFromAppStorage() {
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
    
    func saveChatMessagesToAppStorage() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(chatMessages)
            chatMessagesString = String(data: data, encoding: .utf8) ?? ""
        } catch {
            print("Failed to encode chatMessages: \(error)")
        }
    }
    
    func loadChatMessagesFromAppStorage() {
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
    
    // 方便更新聊天訊息
    func updateChatMessages(for chatID: UUID, messages: [Message]) {
        chatMessages[chatID] = messages
        saveChatMessagesToAppStorage() // 保存至 AppStorage
        AnalyticsManager.shared.trackEvent("chat_messages_updated", parameters: [
            "chat_id": chatID.uuidString,
            "message_count": messages.count
        ])
    }
    
    // For checking if local storage is empty
    var chatDataStringIsEmptyOrChatMessagesStringIsEmpty: Bool {
        return chatDataString.isEmpty || chatMessagesString.isEmpty
    }
}
