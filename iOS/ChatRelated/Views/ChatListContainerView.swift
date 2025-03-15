//
//  ChatListContainerView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/9.
//

import Foundation
import SwiftUI

struct ChatListContainerView: View {
    @ObservedObject var viewModel: ChatViewModel
    @State private var disableChildSwipe: Bool = false
    @Binding var showTurboView: Bool
    
    // 自定義初始化器，需要傳入 viewModel 和 showTurboView
    init(viewModel: ChatViewModel, showTurboView: Binding<Bool>) {
        self.viewModel = viewModel
        self._showTurboView = showTurboView
        UITableView.appearance().separatorStyle = .none
    }

    var body: some View {
        // 聊天列表
        List {
            // Custom title for new matches
            Text("新配對")
                .font(.headline)
                .padding(.leading)
                .listRowSeparator(.hidden)  // 添加在這裡

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
                        viewModel.showTurboPurchaseView = true // Navigate to TurboPurchaseView
                    }
                    
                    if viewModel.showSearchField {
                        // Existing users
                        ForEach(viewModel.filteredMatches) { user in
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
                        ForEach(viewModel.userMatches) { user in
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
                            .onAppear {
                                print("viewModel.userMatches = \(viewModel.userMatches)")
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .listRowSeparator(.hidden)  // 添加在這裡
            
            // 聊天
            Text("聊天")
                .font(.headline)
                .padding(.leading)
                .listRowSeparator(.hidden)  // 添加在這裡
            
            // Add the 'WhoLikedYouView' at the top
            Button(action: {
                // 埋點：點擊 WhoLikedYouView
                AnalyticsManager.shared.trackEvent("who_liked_you_tapped")
                showTurboView = true // Navigate to TurboView
            }) {
                WhoLikedYouView()
                    .padding(.top)
            }
            .listRowSeparator(.hidden)  // 添加在這裡
            
            if viewModel.showSearchField {
                // 使用 List 顯示聊天對話
                ForEach(viewModel.filteredChats) { chat in
                    if let messages = viewModel.chatMessages[chat.id] {
                        ChatRow(chat: chat, messages: messages) // Pass messages to ChatRow
                            .swipeActions(edge: .trailing) {
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
                            .listRowSeparator(.hidden)  // 添加在這裡
                    } else {
                        // 如果 messages 不存在，显示 chat.id 作为调试信息
                        Text(chat.id.uuidString)
                            .listRowSeparator(.hidden)  // 添加在這裡
                    }
                }
            } else {
                // 使用 List 顯示聊天對話
                ForEach(viewModel.chatData) { chat in
                    ChatRow(chat: chat, messages: viewModel.chatMessages[chat.id] ?? []) // Pass messages to ChatRow
                        .swipeActions(edge: .trailing) {
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
                        .listRowSeparator(.hidden)  // 添加在這裡
                }
            }
        }
        .listStyle(PlainListStyle())
    }
}
