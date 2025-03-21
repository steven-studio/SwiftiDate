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
    @Binding var contentSelectedTab: Int // Use a binding variable for selectedTab from ContentView
    @State var showTurboView: Bool = false
    
    @StateObject private var viewModel: ChatViewModel

    init(contentSelectedTab: Binding<Int>, userSettings: UserSettings) {
        self._contentSelectedTab = contentSelectedTab
        // 注意：無法在 init 裡直接用 @EnvironmentObject，所以我們需要延遲初始化
        _viewModel = StateObject(wrappedValue: ChatViewModel(userSettings: userSettings))
    }
    
    var searchBarView: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("搜尋配對好友", text: $viewModel.searchText)
                .font(.headline)
                .foregroundColor(.gray)
                .disableAutocorrection(true)
                .autocapitalization(.none)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal, 10)
    }

    // 將 chatMessages 編碼為 JSON 字符串並存入 AppStorage
    
    var body: some View {
        NavigationView {
            VStack {
                if let chat = viewModel.selectedChat {
                    ChatDetailView(
                        chat: chat,
                        messages: Binding(
                            get: { viewModel.chatMessages[chat.id] ?? [] },
                            set: { newValue in viewModel.chatMessages[chat.id] = newValue }
                        ), onBack: {
                            AnalyticsManager.shared.trackEvent("chat_detail_back")
                            viewModel.selectedChat = nil // Reset to show ChatView again
                        }
                    )
                } else if viewModel.showInteractiveContent {
                    // 找出 chat 名字 == "SwiftiDate"
                    InteractiveContentView(
                        onBack: {
                            AnalyticsManager.shared.trackEvent("interactive_content_closed")
                            viewModel.showInteractiveContent = false
                        },
                        messages: $viewModel.interactiveMessage
                    )
                    .environmentObject(userSettings)
                } else if viewModel.showSearchField && viewModel.filteredMatches.isEmpty {
                    // 使用 List 顯示聊天對話
                    List {
                        ForEach(viewModel.filteredChats) { chat in
                            if let messages = viewModel.chatMessages[chat.id] {
                                ChatRow(chat: chat, messages: messages) // Pass messages to ChatRow
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
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
                                    }
                                    .onTapGesture {
                                        // 埋點：點擊聊天列表中的某個聊天
                                        AnalyticsManager.shared.trackEvent("chat_row_tapped", parameters: [
                                            "chat_id": chat.id.uuidString,
                                            "chat_name": chat.name
                                        ])
                                        if chat.name == "SwiftiDate" { // Adjust to your actual name for DateVerse
                                            // 埋點：選擇打開互動內容
                                            AnalyticsManager.shared.trackEvent("interactive_content_opened")
                                            viewModel.showInteractiveContent = true // Navigate to InteractiveContentView
                                            viewModel.selectedChat = nil
                                        } else {
                                            viewModel.showInteractiveContent = false
                                            viewModel.selectedChat = chat // Navigate to ChatDetailView
                                        }
                                    }
                                    .onAppear {
                                        print("Chat \(chat.name) has \(messages.count) messages")
                                    }
                            } else {
                                // 如果 messages 不存在，显示 chat.id 作为调试信息
                                Text(chat.id.uuidString)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                } else {
                    ChatListContainerView(viewModel: viewModel, showTurboView: $showTurboView)
                }
            }
            .toolbar {
                if viewModel.showSearchField {
                    // 分支1：顯示搜尋列
                    ToolbarItem(placement: .principal) {
                        HStack {
                            searchBarView

                            Button("取消") {
                                withAnimation {
                                    viewModel.searchText = ""
                                    viewModel.showSearchField = false
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
                            viewModel.showSafetyCenterView = true
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
                            viewModel.showSearchField = true
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
                
                if viewModel.chatDataString.isEmpty || viewModel.chatMessagesString.isEmpty || viewModel.userMatches.isEmpty {
                    // 如果本地的 chatDataString 或 chatMessagesString 為空，就從 Firebase 加載
                    print("Loading data from Firebase as local storage is empty")
                    // 埋點：從 Firebase 加載聊天資料
                    AnalyticsManager.shared.trackEvent("chat_data_load_from_firebase")
                    viewModel.readDataFromFirebase()
                } else {
                    // 如果本地有儲存的數據，從本地載入
                    viewModel.loadUserMatchesFromAppStorage()
                    viewModel.loadChatDataFromAppStorage()
                    viewModel.loadChatMessagesFromAppStorage()
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
                        phoneNumber: "xxx",
                        photoURLs: []
                    )
                    viewModel.selectedChat = newChat

                    // 清空，避免下次進來又觸發
                    userSettings.newMatchedChatID = nil
                }
            }
            .fullScreenCover(isPresented: $viewModel.showTurboView) {
                // Pass the selectedTab to TurboView
                TurboView(contentSelectedTab: $contentSelectedTab, turboSelectedTab: $viewModel.selectedTurboTab, showBackButton: true, onBack: {
                    viewModel.showTurboView = false // This dismisses the TurboView
                    AnalyticsManager.shared.trackEvent("turbo_view_closed")
                })
            }
            .fullScreenCover(isPresented: $viewModel.showSafetyCenterView) {
                SafetyCenterView(showSafetyCenterView: $viewModel.showSafetyCenterView, photos: $userSettings.photos) // 如果全局变量为 true，则显示 SafetyCenterView
                    .environmentObject(userSettings)
                    .onAppear {
                        AnalyticsManager.shared.trackEvent("chat_view_safety_center_appear")
                    }
            }
            .sheet(isPresented: $viewModel.showTurboPurchaseView) {
                TurboPurchaseView() // Present TurboPurchaseView when showTurboPurchaseView is true
                    .onAppear {
                        AnalyticsManager.shared.trackEvent("turbo_purchase_view_appear")
                    }
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    @State static var contentSelectedTab = 3 // Add the required state variable
    
    static var previews: some View {
        let settings = UserSettings()
        return ChatView(contentSelectedTab: $contentSelectedTab, userSettings: settings)
            .environmentObject(settings)
    }
}
