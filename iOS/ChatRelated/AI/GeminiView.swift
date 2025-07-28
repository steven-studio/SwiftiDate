//
//  GeminiView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/26.
//

import Foundation
import UIKit
import SwiftUI

struct GeminiView: View {
    @Binding var messages: [Message]   // 聊天歷史記錄綁定自 ChatDetailView
    @Binding var showGeminiView: Bool // 綁定來自 ModelSelectorView 的控制變數

    @State private var userInput: String = ""   // 用戶輸入的訊息
    @State private var GeminiResponse: String = ""  // GPT 的回應
    @State private var isLoading = false        // 用來顯示加載狀態
    @State private var dynamicHeight: CGFloat = 150 // 初始高度
    private let maxHeight: CGFloat = 300 // 最大高度限制

//    let apiKey = openAIAPIKey  // 將這個替換為您的 API 密鑰

    var body: some View {
        NavigationStack {
            VStack {
                Text("Vertex AI")
                    .font(.title)
                    .padding()
                
                MessageListView(
                    messages: $messages,
                    Response: $GeminiResponse,
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
                    sendMessageToGemini()  // 發送用戶輸入給 Gemini
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
            .navigationTitle("Vertex AI 模型")
            .onAppear {
                AnalyticsManager.shared.trackEvent("VertexAIView_Appeared", parameters: nil)
            }
        }
        .ignoresSafeArea(.keyboard) // 忽略键盘的安全区域
    }
    
    // 與 Vertex AI API 進行交互的函數
    func sendMessageToGemini() {
        guard !userInput.isEmpty else { return }
        
        // 記錄用戶發送訊息事件
        AnalyticsManager.shared.trackEvent("VertexAI_MessageSent", parameters: [
            "userInputLength": userInput.count
        ])

        isLoading = true
        
        // 1. 整理舊的 messages => Vertex AI 要求的 "messages" 陣列
        let vertexMessages: [[String: String]] = messages.compactMap { msg in
            let role = msg.isSender ? "user" : "chat_partner"

            // 根據 MessageType 提取內容
            switch msg.content {
            case .text(let text):
                return ["role": role, "content": text]
            case .image:
                return ["role": role, "content": "[圖片]"] // 替換為適合的占位文本
            case .audio:
                return ["role": role, "content": "[語音]"] // 替換為適合的占位文本
            }
        }
        
        // 加上最新使用者輸入
        let finalMessages = vertexMessages + [["role": "user", "content": userInput]]

        // 準備 API 請求
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
//        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
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
            
            // 5. 解析回應
            // 預期 Vertex AI 的回應:
            // {
            //   "predictions": [
            //       {"content": "..."}
            //   ],
            //   ... 其他欄位 ...
            // }
            do {
                if let jsonObj = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let preds = jsonObj["predictions"] as? [[String: Any]],
                   let firstPred = preds.first,
                   let content = firstPred["content"] as? String {
                    
                    DispatchQueue.main.async {
                        // 把 content 當作我們的回覆
                        GeminiResponse = content
                        userInput = ""
                        
                        // 記錄回應生成完成事件
                        AnalyticsManager.shared.trackEvent("VertexAI_ResponseReceived", parameters: [
                            "responseLength": content.count
                        ])
                    }
                } else {
                    print("回應格式不符合預期。")
                    DispatchQueue.main.async {
                        GeminiResponse = "對方未回應"
                    }
                }
            } catch {
                print("JSON 解析錯誤: \(error)")
                DispatchQueue.main.async {
                    GeminiResponse = "對方未回應"
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
struct GeminiView_Previews: PreviewProvider {
    static var previews: some View {
        GeminiView(messages: .constant([ // 使用 .constant 來模擬綁定數據
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
        ]), showGeminiView: .constant(true))
    }
}
