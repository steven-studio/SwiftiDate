//
//  modelSelector.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/9.
//

import Foundation
import SwiftUI

// 定義支持的 LLM 模型
enum LLMModel: String, CaseIterable {
    case chatgpt = "ChatGPT\n (OpenAI)"
    case claude = "Claude AI\n (Anthropic)"
    case vertexai = "Gemini\n (Google DeepMind)"
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
            return [.chatgpt, .vertexai, .claude, .deepseek, .local] // 顯示大陸以外的模型
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
            return URL(string: "https://api.openai.com/v1/models")
        case .vertexai:
            return URL(string: "https://www.google.com/")  // 模擬 Gemini => Google
        case .claude:
            return URL(string: "https://www.anthropic.com/")
        default:
            return nil // 不需要特別測試 or local
        }
    }

    // 是否需要外網連線測試
    var requiresExternalCheck: Bool {
        return self == .chatgpt || self == .vertexai || self == .claude
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
        print("[DEBUG] Model \(model) 不需要外網測試，直接回傳 true")
        completion(true)
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    // 針對 OpenAI API，添加 Bearer Token
    if model == .chatgpt {
        let firebaseURLString = "https://us-central1-swiftidate-cdff0.cloudfunctions.net/chatCompletionGpt4o"
        guard let firebaseURL = URL(string: firebaseURLString) else {
            completion(false)
            print("No Connection")
            return
        }
        request = URLRequest(url: firebaseURL)
        // 根據你 Cloud Function 的實作，設定合適的 HTTP 方法與 header
        request.httpMethod = "GET"  // 或 "POST"，視你端點而定
    }
    
    print("[DEBUG] 準備測試外網連線: \(request.url?.absoluteString)")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        
        // 1) 檢查有沒有 error
        if let error = error {
            print("[DEBUG] 請求失敗，error: \(error.localizedDescription) \(url)")
            completion(false)
            return
        }
        
        // 2) 檢查 response 是不是 HTTP 回應
        guard let httpResponse = response as? HTTPURLResponse else {
            print("[DEBUG] response 不是 HTTPURLResponse: \(String(describing: response))")
            completion(false)
            return
        }
        
        // 3) 印出狀態碼、標頭
        print("[DEBUG] 收到 HTTP 狀態碼: \(httpResponse.statusCode)")
        // 若想看全部 header，可:
         print("[DEBUG] HTTP Header: \(httpResponse.allHeaderFields)")
        
        // 4) 如果有 data 也可查看回應內容 (可能是 HTML, JSON 等)
        if let data = data,
           let _ = String(data: data, encoding: .utf8) {
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
    @Environment(\.dismiss) var dismiss  // 新增這行來獲取 dismiss function
    @State private var selectedModel: LLMModel = .chatgpt // 默認為 ChatGPT
    @State private var navigateToChatGPT = false
    @State private var navigateToGemini = false
    @State private var navigateToClaude = false
    @State private var navigateToDeepSeek = false
    @State private var navigateToCustom = false
    @State private var availableModels: [LLMModel] = []  // 根據地區篩選出的模型
    @Binding var messages: [Message]  // 綁定聊天歷史記錄

    // 設定 3 欄的網格
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        NavigationView {
            VStack {
                Text("選擇 LLM 模型")
                    .font(.headline)
                    .padding()
                
                // 埋點：畫面曝光
                .onAppear {
                    AnalyticsManager.shared.trackEvent("model_selector_view_appear")
                }

                // 自定義 HStack 作為選擇器
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(availableModels, id: \.self) { model in
                        Button(action: {
                            selectedModel = model // 更新選擇的模型
                            // 埋點：使用者點選了某模型
                            AnalyticsManager.shared.trackEvent("model_selected", parameters: [
                                "model": model.rawValue
                            ])
                        }) {
                            ZStack {
                                // 1) 若目前被選擇，顯示圓角背景／描邊；否則用透明或不顯示
                                if selectedModel == model {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.blue.opacity(0.2))   // 或者 fill(Color.blue.opacity(0.2)) 來上色
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                                
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
                }
                .padding()

                // 顯示當前選擇的模型
                Text("當前選擇的模型是：\(selectedModel.rawValue)")
                    .padding()

                Spacer()
                
                // NavigationLink 控制視圖導航
                NavigationLink(destination: ChatGPTView(messages: $messages, showChatGPTView: $navigateToChatGPT), isActive: $navigateToChatGPT) { EmptyView() }
                NavigationLink(destination: GeminiView(messages: $messages, showGeminiView: $navigateToGemini), isActive: $navigateToGemini) { EmptyView() }
                NavigationLink(destination: ClaudeAIView(messages: $messages, showClaudeAIView: $navigateToClaude), isActive: $navigateToClaude) { EmptyView() }
                NavigationLink(destination: DeepSeekView(messages: $messages, showDeepSeekView: $navigateToDeepSeek), isActive: $navigateToDeepSeek) { EmptyView() }
                NavigationLink(destination: LocalModelView(messages: $messages, showLocalModel: $navigateToCustom), isActive: $navigateToCustom) { EmptyView() }

                
                // 在底部新增「繼續」按鈕
                Button(action: {
                    // 埋點：使用者點選「繼續」按鈕
                    AnalyticsManager.shared.trackEvent("continue_button_pressed", parameters: [
                        "selected_model": selectedModel.rawValue
                    ])
                    // 在這裡處理「繼續」按鈕的邏輯
                    print("使用者選擇的模型：\(selectedModel.rawValue)")
                    triggerNavigation()
                }) {
                    Text("繼續")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)

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
                    // 埋點：可追蹤篩選完成的模型清單（選填）
                    AnalyticsManager.shared.trackEvent("model_filter_complete", parameters: [
                        "available_models_count": filtered.count
                    ])
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("關閉") {
                        // 在這裡添加退出邏輯，例如 dismiss sheet
                        // 如果是使用 .presentationMode，可以呼叫 dismiss()
                        // 或是利用 parent view 的 Binding 控制是否顯示
                        dismiss()  // 調用 dismiss() 就可以關閉這個 sheet 或視圖
                    }
                }
            }
        }
    }
    
    /// ✅ 這個函數會根據選擇的模型來設置 NavigationLink 的 isActive
    private func triggerNavigation() {
        resetNavigation() // 先將所有狀態重置
        
        switch selectedModel {
        case .chatgpt:
            navigateToChatGPT = true
        case .vertexai:
            navigateToGemini = true
        case .claude:
            navigateToClaude = true
        case .deepseek:
            navigateToDeepSeek = true
        case .local:
            navigateToCustom = true
        default:
            break
        }
        
        // 埋點：完成導航觸發
        AnalyticsManager.shared.trackEvent("trigger_navigation", parameters: [
            "selected_model": selectedModel.rawValue
        ])
    }

    /// ✅ 這個函數會確保 NavigationLink 的狀態不會衝突
    private func resetNavigation() {
        navigateToChatGPT = false
        navigateToGemini = false
        navigateToClaude = false
        navigateToDeepSeek = false
        navigateToCustom = false
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
            let desiredOrder: [LLMModel] = [.chatgpt, .vertexai, .claude, .deepseek, .local]
            
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
        case .vertexai:
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
        ModelSelectorView(messages: .constant([ // 使用 .constant 來模擬綁定數據
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
        ]))
        .environmentObject(UserSettings())  // 加入環境物件
    }
}
