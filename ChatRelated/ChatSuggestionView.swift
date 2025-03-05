//
//  ChatSuggestionView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/5.
//

import Foundation
import SwiftUI

struct ChatSuggestionResponse: Codable {
    struct Choice: Codable {
        let message: Message
    }
    struct Message: Codable {
        let role: String
        let content: String
    }
    let choices: [Choice]
}

func generateChatSuggestions(for context: String, completion: @escaping ([String]?) -> Void) {
    // 請求的 API URL（以 OpenAI 的 Chat Completion API 為例）
    guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
        completion(nil)
        return
    }
    
    // 構造 prompt：將對話脈絡作為提示，讓模型生成建議
    let prompt = """
    請根據以下對話脈絡生成幾句適合用來引導對話的建議：
    \(context)
    
    請輸出一個 JSON 陣列，例如：["嗨，你好嗎？", "今天過得怎麼樣？", "最近有什麼好玩的事？"]
    """
    
    // 構造請求內容，這裡使用 gpt-3.5-turbo 模型
    let requestBody: [String: Any] = [
        "model": "gpt-3.5-turbo",
        "messages": [
            ["role": "system", "content": "你是一個能夠根據對話脈絡提供聊天建議的助手。"],
            ["role": "user", "content": prompt]
        ],
        "max_tokens": 100,
        "temperature": 0.7
    ]
    
    guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody) else {
        completion(nil)
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    // 設定 API 金鑰（請將 "YOUR_API_KEY" 換成你真實的 API 金鑰）
    request.addValue("Bearer YOUR_API_KEY", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = httpBody
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard error == nil,
              let data = data else {
            print("請求失敗：\(error?.localizedDescription ?? "Unknown error")")
            completion(nil)
            return
        }
        
        do {
            let result = try JSONDecoder().decode(ChatSuggestionResponse.self, from: data)
            // 假設模型輸出的內容是一個 JSON 陣列字串，例如：["嗨，你好嗎？", "今天過得怎麼樣？"]
            // 你可以嘗試解析這個內容
            if let suggestionsData = result.choices.first?.message.content.data(using: .utf8),
               let suggestions = try? JSONSerialization.jsonObject(with: suggestionsData) as? [String] {
                completion(suggestions)
            } else {
                // 如果無法解析，就直接返回模型輸出的字串，並以換行分割作為候選建議
                let suggestions = result.choices.first?.message.content.components(separatedBy: "\n").filter { !$0.isEmpty }
                completion(suggestions)
            }
        } catch {
            print("解析錯誤：\(error.localizedDescription)")
            completion(nil)
        }
    }
    task.resume()
}

// 測試範例：假設我們有一段聊天脈絡
let chatContext = """
男：你今天過得怎麼樣？
女：還不錯，只是工作有點忙。
男：那週末有沒有什麼計劃？
"""

//generateChatSuggestions(for: chatContext) { suggestions in
//    if let suggestions = suggestions {
//        print("生成的聊天建議：\(suggestions)")
//    } else {
//        print("無法生成聊天建議")
//    }
//}

// 聊天建議視圖：會橫向滾動顯示一系列建議文字
struct ChatSuggestionView: View {
    let suggestions: [String]
    let onSelect: (String) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(suggestions, id: \.self) { suggestion in
                    Button(action: {
                        onSelect(suggestion)
                    }) {
                        Text(suggestion)
                            .font(.caption)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(Color.blue.opacity(0.2))
                            .foregroundColor(.blue)
                            .cornerRadius(15)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
