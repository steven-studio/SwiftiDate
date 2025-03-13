//
//  ChatListView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/9.
//

import Foundation
import SwiftUI

struct ChatListView: View {
    @ObservedObject var viewModel: ChatViewModel

    var body: some View {
        List {
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
            }
        }
        .listStyle(PlainListStyle())
    }
}
