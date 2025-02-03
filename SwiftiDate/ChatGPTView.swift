//
//  ChatGPTView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/9.
//

import Foundation
import UIKit
import SwiftUI

struct ChatGPTView: View {
    @Binding var messages: [Message]   // 聊天歷史記錄綁定自 ChatDetailView
    @Binding var showChatGPTView: Bool // 綁定來自 ModelSelectorView 的控制變數

    @State private var userInput: String = ""   // 用戶輸入的訊息
    @State private var chatGPTResponse: String = ""  // GPT 的回應
    @State private var isLoading = false        // 用來顯示加載狀態
    @State private var dynamicHeight: CGFloat = 150 // 初始高度
    private let maxHeight: CGFloat = 300 // 最大高度限制

    let apiKey = openAIAPIKey  // 將這個替換為您的 API 密鑰

    var body: some View {
        NavigationStack {
            VStack {
                Text("ChatGPT-4o")
                    .font(.title)
                    .padding()
                
                MessageListView(
                    messages: $messages,
                    Response: $chatGPTResponse,
                    dynamicHeight: $dynamicHeight,
                    maxHeight: maxHeight
                )
                .frame(maxWidth: UIScreen.main.bounds.width - 32, maxHeight: 300)
                .border(Color.gray, width: 1)

                TextField("輸入您的訊息...", text: $userInput, axis: .vertical) // by bryan_u.6_developer
                    .frame(minHeight: 30)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)

                if isLoading {
                    ProgressView()  // 顯示加載中狀態
                        .padding()
                }

                Button(action: {
                    sendMessageToChatGPT()  // 發送用戶輸入給 ChatGPT
                }) {
                    Text("發送")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding()
        }
        .ignoresSafeArea(.keyboard) // 忽略键盘的安全区域
    }
    
    // 與 OpenAI API 進行交互的函數
    func sendMessageToChatGPT() {
        guard !userInput.isEmpty else { return }

        isLoading = true
        
        // 確保 messages 裡面的內容可以被正確轉換成 JSON
        let jsonMessages: [[String: String]] = messages.compactMap { message in
            let role = message.isSender ? "user" : "chat_partner"

            // 根據 MessageType 提取內容
            switch message.content {
            case .text(let text):
                return ["role": role, "content": text]
            case .image:
                return ["role": role, "content": "[圖片]"] // 替換為適合的占位文本
            case .audio:
                return ["role": role, "content": "[語音]"] // 替換為適合的占位文本
            }
        }
        
        // 添加用戶輸入的問題作為最後一條記錄
        let finalMessages = jsonMessages + [["role": "user", "content": userInput]]

        // 準備 API 請求
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 設置請求 body，將聊天記錄和新問題一起發送
        let body: [String: Any] = [
            "model": "gpt-4", // 使用 gpt-4 模型
            "messages": finalMessages
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        // 發送請求
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            // 確保沒有錯誤且數據正確
            guard let data = data, error == nil else {
                print("API請求失敗：\(error?.localizedDescription ?? "未知錯誤")")
                return
            }
            
            // 解碼 API 回應
            if let response = try? JSONDecoder().decode(Response.self, from: data) {
                DispatchQueue.main.async {
                    if let chatResponseText = response.choices.first?.message.content {
                        // 顯示 GPT 回應
                        chatGPTResponse = chatResponseText
                    } else {
                        // 如果沒有回應，顯示 "對方未回應"
                        chatGPTResponse = "對方未回應"
                    }
                    userInput = ""  // 清空用戶輸入
                }
            } else {
                print("無法解析回應數據")
                DispatchQueue.main.async {
                    chatGPTResponse = "對方未回應"
                }
            }
        }.resume()
    }
    
    // 獲取當前時間的函數
    func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: Date())
    }
}

// 添加 PreviewProvider
struct ChatGPTView_Previews: PreviewProvider {
    static var previews: some View {
        ChatGPTView(messages: .constant([ // 使用 .constant 來模擬綁定數據
            Message(
                id: UUID(),
                content: .text("你好，這是範例訊息1"), // 將文字包裝為 .text
                isSender: true,
                time: "10:00 AM",
                isCompliment: false
            ),
            Message(
                id: UUID(),
                content: .text("你好，這是範例訊息2"), // 將文字包裝為 .text
                isSender: false,
                time: "10:05 AM",
                isCompliment: false
            )
        ]), showChatGPTView: .constant(true))
    }
}
