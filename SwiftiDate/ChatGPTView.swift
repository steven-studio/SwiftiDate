//
//  ChatGPTView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/9.
//

import Foundation
import UIKit
import SwiftUI

// 自定義 UIViewRepresentable 組件
struct TextViewRepresentable: UIViewRepresentable {
    var text: String
    @Binding var dynamicHeight: CGFloat
    let maxHeight: CGFloat // 最大高度限制

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false // 禁止編輯
        textView.isSelectable = true // 啟用選取功能
        textView.backgroundColor = UIColor.green.withAlphaComponent(0.1) // 背景設置為透明
        textView.isScrollEnabled = true  // 防止自動滾動
        textView.font = UIFont.systemFont(ofSize: 17) // 設置字體
        let isChineseText = text.range(of: "\\p{Han}", options: .regularExpression) != nil
        textView.textContainer.lineBreakMode = isChineseText ? .byCharWrapping : .byWordWrapping
//        textView.textContainer.lineFragmentPadding = 0 // 移除行內邊距
//        textView.textContainerInset = .zero // 移除內邊距
        
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        let isChineseText = text.range(of: "\\p{Han}", options: .regularExpression) != nil
        print("Is Chinese Text:", isChineseText)

        // 禁用 translatesAutoresizingMaskIntoConstraints
        uiView.translatesAutoresizingMaskIntoConstraints = false

        // 刪除現有的寬度約束
        uiView.constraints.forEach { constraint in
            if constraint.firstAttribute == .width {
                uiView.removeConstraint(constraint)
            }
        }
        
        // 獲取父容器的寬度
        let parentWidth = uiView.superview?.frame.width ?? UIScreen.main.bounds.width
        let fixedWidth = parentWidth - 32

        // 設置寬度約束
        NSLayoutConstraint.activate([
            uiView.widthAnchor.constraint(equalToConstant: fixedWidth)
        ])

        // 設置文本屬性
        uiView.textContainer.lineBreakMode = .byCharWrapping
        uiView.textContainer.lineFragmentPadding = 0
        uiView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

        // 使用 attributedText 設置文本
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        uiView.attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: UIFont.systemFont(ofSize: 17),
                .paragraphStyle: paragraphStyle
            ]
        )
        
        // 禁用滾動以計算高度
        uiView.isScrollEnabled = false

        // 計算內容高度
        let size = uiView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        print("Calculated Size:", size)

        // 更新高度和滾動狀態
        DispatchQueue.main.async {
            let newHeight = size.height > self.maxHeight ? self.maxHeight : size.height
            if self.dynamicHeight != newHeight {
                self.dynamicHeight = newHeight
                uiView.isScrollEnabled = size.height > self.maxHeight
            }

            // 強制刷新布局
            uiView.invalidateIntrinsicContentSize()
            uiView.setNeedsLayout()
            uiView.layoutIfNeeded()
        }
    }
}

struct ChatGPTView: View {
    @Binding var messages: [Message]   // 聊天歷史記錄綁定自 ChatDetailView
    @State private var userInput: String = ""   // 用戶輸入的訊息
    @State private var chatGPTResponse: String = ""  // GPT 的回應
    @State private var isLoading = false        // 用來顯示加載狀態
    @State private var dynamicHeight: CGFloat = 150 // 初始高度
    private let maxHeight: CGFloat = 300 // 最大高度限制

    let apiKey = openAIAPIKey  // 將這個替換為您的 API 密鑰

    var body: some View {
        VStack {
            Text("ChatGPT-4o")
                .font(.title)
                .padding()
            
            ScrollView {
                ForEach(messages, id: \.id) { message in
                    HStack {
                        Text(message.isSender ? "你: " : "對方: ")
                            .fontWeight(.bold)
                        Text(message.text)
                    }
                    .padding()
                    .frame(maxWidth: UIScreen.main.bounds.width - 64, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .textSelection(.enabled) // by bryan_u.6_developer
                }

                TextViewRepresentable(text: chatGPTResponse,
                    dynamicHeight: $dynamicHeight,
                    maxHeight: maxHeight
                )
                    .frame(maxWidth: UIScreen.main.bounds.width - 64, minHeight: dynamicHeight, maxHeight: dynamicHeight) // 設置最大寬度和最小高度
                    .cornerRadius(10)
                    .padding()
            }
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
        .ignoresSafeArea(.keyboard) // 忽略键盘的安全区域
    }
    
    // 與 OpenAI API 進行交互的函數
    func sendMessageToChatGPT() {
        guard !userInput.isEmpty else { return }

        isLoading = true
        
        // 確保 messages 裡面的內容可以被正確轉換成 JSON
        let jsonMessages: [[String: String]] = messages.map { message in
            [
                "role": message.isSender ? "user" : "chat_partner", // 用 "chat_partner" 表示女生或對方的訊息，而不是 "assistant"
                "content": message.text // 消息內容是字符串
            ]
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
            if let response = try? JSONDecoder().decode(ChatGPTResponse.self, from: data) {
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

// 定義 OpenAI API 回應的資料結構
struct ChatGPTResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}

// 添加 PreviewProvider
struct ChatGPTView_Previews: PreviewProvider {
    static var previews: some View {
        ChatGPTView(messages: .constant([ // 使用 .constant 來模擬綁定數據
            Message(id: UUID(), text: "你好，這是範例訊息1", isSender: true, time: "10:00 AM", isCompliment: false),
            Message(id: UUID(), text: "你好，這是範例訊息2", isSender: false, time: "10:05 AM", isCompliment: false)
        ]))
    }
}
