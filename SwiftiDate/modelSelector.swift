//
//  modelSelector.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/1/22.
//

import Foundation
import SwiftUI

// 定義支持的 LLM 模型
enum LLMModel: String, CaseIterable {
    case chatgpt = "ChatGPT\n (OpenAI)"
    case claude = "Claude AI\n (Anthropic)"
    case gemini = "Gemini\n (Google DeepMind)"
    case wenxin = "文心一言 (Baidu)"
    case tongyi = "通義千問 (Alibaba)"
    case local = "本地模型 (Custom)"
    case deepseek = "DeepSeek\n (DeepSeek AI)" // 新增 DeepSeek 模型
    case douban = "豆瓣 (Douban)"  // 新增的豆瓣


    // 根據地區返回可用模型列表
    static func availableModels(for region: Region) -> [LLMModel] {
        switch region {
        case .mainlandChina:
            return [.wenxin,
                    .tongyi,
                    .deepseek,
                    .douban,
                    .local] // 僅顯示大陸地區的模型
        case .other:
            return [.chatgpt, .gemini, .claude, .deepseek, .local] // 顯示大陸以外的模型
        }
    }
    
    // 給需要外網連線的模型一個測試URL
    // 這邊隨意舉例 (ChatGPT 用 openai.com, Gemini / Claude 用一些 API endpoint)
    var testURL: URL? {
        switch self {
        // 在台灣測試時，https://api.openai.com 和 ai.openai.com 都常連不上的情況，
        // 但實際上使用 ChatGPT 在台灣是可行的，所以這裡以 google.com 代替測試。
        // 基本邏輯是：能連上 Google，就大概率能連上 ChatGPT。
        case .chatgpt:
            return URL(string: "https://www.google.com/")
        case .gemini:
            return URL(string: "https://www.google.com/")  // 模擬 Gemini => Google
        case .claude:
            return URL(string: "https://www.anthropic.com/")
        default:
            return nil // 不需要特別測試 or local
        }
    }

    // 是否需要外網連線測試
    var requiresExternalCheck: Bool {
        return self == .chatgpt || self == .gemini || self == .claude
    }
}

// 定義地區類型
enum Region {
    case mainlandChina
    case other
}

// 模擬檢測地區的功能（替換為實際的地區檢測邏輯）
func detectRegion() -> Region {
    // 假設檢測大陸地區的方法
    let currentLocale = Locale.current.region?.identifier
    return currentLocale == "CN" ? .mainlandChina : .other
}

/// 檢測能否連線到 model.testURL；如果 model.testURL == nil，就表示不需要測試 => 成功
func canConnect(to model: LLMModel, completion: @escaping (Bool) -> Void) {
    guard model.requiresExternalCheck, let url = model.testURL else {
        // 不需要測試外網 => 直接回傳 true
//        print("[DEBUG] Model \(model) 不需要外網測試，直接回傳 true")
        completion(true)
        return
    }
//    print("[DEBUG] 準備測試外網連線: \(url.absoluteString)")
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        
        // 1) 檢查有沒有 error
        if let error = error {
//            print("[DEBUG] 請求失敗，error: \(error.localizedDescription) \(url)")
            completion(false)
            return
        }
        
        // 2) 檢查 response 是不是 HTTP 回應
        guard let httpResponse = response as? HTTPURLResponse else {
//            print("[DEBUG] response 不是 HTTPURLResponse: \(String(describing: response))")
            completion(false)
            return
        }
        
        // 3) 印出狀態碼、標頭
//        print("[DEBUG] 收到 HTTP 狀態碼: \(httpResponse.statusCode)")
        // 若想看全部 header，可:
        // print("[DEBUG] HTTP Header: \(httpResponse.allHeaderFields)")
        
        // 4) 如果有 data 也可查看回應內容 (可能是 HTML, JSON 等)
        if let data = data,
           let bodyString = String(data: data, encoding: .utf8) {
//            print("[DEBUG] 回應內容: \(bodyString)")
        }
        
        // 5) 檢查狀態碼是否 2xx
        if (200...299).contains(httpResponse.statusCode) {
//            print("[DEBUG] (200~299) 請求成功")
            completion(true)
        } else {
//            print("[DEBUG] 非 2xx，請求失敗，狀態碼: \(httpResponse.statusCode)")
            completion(false)
        }
    }
    task.resume()
}

// 模型選擇視圖
struct ModelSelectorView: View {
    @State private var selectedModel: LLMModel = .chatgpt // 默認為 ChatGPT
    @State private var availableModels: [LLMModel] = []  // 根據地區篩選出的模型

    // 設定 3 欄的網格
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        VStack {
            Text("選擇 LLM 模型")
                .font(.headline)
                .padding()

            // 自定義 HStack 作為選擇器
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(availableModels, id: \.self) { model in
                    Button(action: {
                        selectedModel = model // 更新選擇的模型
                    }) {
                        VStack {
                            // 動態顯示模型對應的圖標
                            Image(iconName(for: model))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(selectedModel == model ? .white : .blue)
                            
                            // 顯示模型名稱
                            Text(model.rawValue)
                                .padding(.top, 5)
                                .foregroundColor(selectedModel == model ? .blue : .black)
                        }
                    }
                }
            }
            .padding()

            // 顯示當前選擇的模型
            Text("當前選擇的模型是：\(selectedModel.rawValue)")
                .padding()

            Spacer()
        }
        .padding()
        .onAppear {
            // 根據地區篩選模型
            let region = detectRegion()
            // 1) 先取得初步可用清單
            let rawModels = LLMModel.availableModels(for: region)
            
            // 2) 逐一測試連線 (異步)
            filterModelsByConnectivity(models: rawModels) { filtered in
                // 3) 更新 UI
                self.availableModels = filtered
                // 若沒有可用模型，也可視情況顯示預設
                self.selectedModel = filtered.first ?? .local
            }
        }
    }
    
    /// 對所有需外網的 model 做測試；回傳能連線的清單
    private func filterModelsByConnectivity(models: [LLMModel],
                                            completion: @escaping ([LLMModel]) -> Void) {
        var results: [LLMModel] = []
        
        let group = DispatchGroup()
        
        for model in models {
            group.enter()
            canConnect(to: model) { success in
                if success {
                    results.append(model)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            // results 只是篩完的 model；仍維持插入順序
            // 若想更保險，可手動 sort
            var sorted = results
            let desiredOrder: [LLMModel] = [.chatgpt, .gemini, .claude, .deepseek, .local]
            
            sorted.sort { a, b in
                let indexA = desiredOrder.firstIndex(of: a) ?? Int.max
                let indexB = desiredOrder.firstIndex(of: b) ?? Int.max
                return indexA < indexB
            }
            completion(sorted)
        }
    }
    
    // 根據模型返回對應的圖標名稱
    private func iconName(for model: LLMModel) -> String {
        switch model {
        case .chatgpt:
            return "ChatGPT"
        case .claude:
            return "Claude"
        case .gemini:
            return "Gemini 1"
        case .wenxin:
            return "Wenxin"
        case .tongyi:
            return "Tongyi"
        case .deepseek:
            return "Deepseek"
        case .douban:
            return "Douban"
        case .local:
            return "Local"
        }
    }
}

// 預覽
struct ModelSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        ModelSelectorView()
    }
}
