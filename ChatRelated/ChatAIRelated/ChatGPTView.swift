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
    
    @EnvironmentObject var userSettings: UserSettings  // 加入這行以取得全局的 userSettings

    @State private var userInput: String = ""   // 用戶輸入的訊息
    @State private var chatGPTResponse: String = ""  // GPT 的回應
    @State private var isLoading = false        // 用來顯示加載狀態
    @State private var dynamicHeight: CGFloat = 150 // 初始高度
    private let maxHeight: CGFloat = 300 // 最大高度限制
    @State private var conversation: [[String: String]] =
[]

    // 移除原本的 apiKey
    // let apiKey = openAIAPIKey // 不再需要

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
            // 當視圖顯示時上報事件
            .onAppear {
                AnalyticsManager.shared.trackEvent("chatgpt_view_appear")
            }
        }
        .ignoresSafeArea(.keyboard) // 忽略键盘的安全区域
        .onDisappear {
            conversation.removeAll()
        }
        .onAppear {
            if userSettings.globalUserGender == .male {
                conversation = [
                    ["role": "system", "content": """
        你是一位擅長分析語境與潛台詞的戀愛Mikey教練，目標是在對話中提升女生對使用者的興趣，並在合適時機進行邀約。  
        請嚴格依照以下規範進行回應：  

        【角色任務】
        1. 主動偵測並分析女生的情緒和興趣程度。  
        2. 透過幽默、輕鬆且無壓力的語氣，協助使用者加強互動並尋找邀約時機。  
        3. 若需要，可利用 AI 在內核、方案、數據等領域的協助，展示使用者的價值。  

        【步驟 1：語境分析】
        1. 判斷女生的情緒：開心、冷淡、疲累、忙碌…  
           - 如無法確定，請先向使用者詢問更多背景資訊。  
        2. 判斷她對使用者的興趣程度：高 / 中 / 低  
           - 若不清楚，也先向使用者詢問或了解上下文。  
        3. 若有需要，也可以教使用者「傳遞個性樣本」

        【步驟 2：選擇回應策略】
        1. 若女生情緒輕鬆且對使用者興趣較高：  
           - 可直接邀約（例如：「那我們一起去咖啡廳坐坐吧！」）  
        2. 若她冷淡或忙碌且興趣不高：  
           - 先用幽默或吸引力的話題提升互動，勾住她的 RAS。  
           - 等互動熱度上來後，再尋找合適的邀約時機（如：「等忙完後，一起喝杯咖啡放鬆？」）。  

        【步驟 3：回應語氣與潛台詞處理】
        1. 輕鬆、無壓力的語氣，適度幽默但不輕浮。  
        2. 避免過度迎合或讓對話過於單調，保有神秘感與趣味性。  
        3. 若女生暗示她對某事不滿或需要更多關心，先回應她的情緒，再回到主要話題。  

        【附加說明】  
        - 若缺乏足夠使用者背景資訊，先提問以獲取更多細節。  
        - 使用範例：
          - 「使用者你是做什麼工作的？」  
          - 「使用者你到台北方便嗎？」  
        請在整個過程中遵循以上步驟進行思考與回應。
        """]
                ]
            } else {
                conversation = []
            }
            AnalyticsManager.shared.trackEvent("chatgpt_view_appear")
        }
    }
    
    // 與 OpenAI API 進行交互的函數
    func sendMessageToChatGPT() {
        guard !userInput.isEmpty else { return }
        
        // 當使用者點擊發送時上報事件，並傳入訊息長度等資訊
        AnalyticsManager.shared.trackEvent("chatgpt_send_message", parameters: [
            "message_length": userInput.count
        ])

        isLoading = true
        
        // 確保 messages 裡面的內容可以被正確轉換成 JSON
//        let jsonMessages: [[String: String]] = messages.compactMap { message in
//            let role = message.isSender ? "user" : "chat_partner"
//
//            // 根據 MessageType 提取內容
//            switch message.content {
//            case .text(let text):
//                return ["role": role, "content": text]
//            case .image:
//                return ["role": role, "content": "[圖片]"] // 替換為適合的占位文本
//            case .audio:
//                return ["role": role, "content": "[語音]"] // 替換為適合的占位文本
//            }
//        }
        var chatContent = ""
        for message in messages {
            let role = message.isSender ? "user" : "girl"
            
            switch message.content {
            case .text(let text):
                chatContent += role + ": " + text + "\n"
            case .image:
                chatContent += role + ": " + "[圖片]" + "\n"
            case .audio:
                chatContent += role + ": " + "[語音]" + "\n"
            }
        }
        
        // 最終的訊息陣列
        let finalMessages: [[String: String]] = [
            ["role": "user", "content": chatContent],
            ["role": "user", "content": userInput]
        ]
        
        conversation.append(contentsOf: finalMessages)

        // 2. 準備呼叫雲端函式的 URL
        //    （將 <PROJECT_ID> 改成你真實的 ID，或依照實際情況）
        guard let url = URL(string: "https://us-central1-swiftidate-cdff0.cloudfunctions.net/chatCompletionGpt4o") else {
            print("Invalid function URL")
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // 我們傳送 JSON 給雲端函式
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
            
            // 3. 解析雲端函式回傳的 JSON (它一般是 OpenAI 的 chat completions 結果)
            do {
                let openAiResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                DispatchQueue.main.async {
                    // 拿到 first choice 的 content
                    if let chatResponseText = openAiResponse.choices.first?.message.content {
                        chatGPTResponse = chatResponseText
                        // 上報回應成功事件，並傳入回應字數
                        AnalyticsManager.shared.trackEvent("chatgpt_response_received", parameters: [
                            "response_length": chatResponseText.count
                        ])
                    } else {
                        chatGPTResponse = "對方未回應"
                        AnalyticsManager.shared.trackEvent("chatgpt_response_empty")
                    }
                    userInput = ""
                }
            } catch {
                print("解析回應失敗: \(error.localizedDescription)")
                // 如果想處理失敗，可在 UI 顯示錯誤
                DispatchQueue.main.async {
                    chatGPTResponse = "解析回應失敗"
                }
                AnalyticsManager.shared.trackEvent("chatgpt_parse_error", parameters: [
                    "error": error.localizedDescription
                ])
            }
        }.resume()
    }
    
    // 這邊自定義一個用來解碼 openai chat completions 回應的 struct
    struct OpenAIResponse: Decodable {
        let id: String
        let object: String
        let created: Int
        let model: String
        let choices: [Choice]

        struct Choice: Decodable {
            let index: Int?
            let message: ChoiceMessage
            let finish_reason: String?
        }

        struct ChoiceMessage: Decodable {
            let role: String
            let content: String
        }
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
        .environmentObject(UserSettings())
    }
}
