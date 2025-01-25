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
    
    // 根據地區返回可用模型列表
    static func availableModels(for region: Region) -> [LLMModel] {
        switch region {
        case .mainlandChina:
            return [.wenxin, .tongyi, .local] // 僅顯示大陸地區的模型
        case .other:
            return [.chatgpt, .gemini, .claude] // 顯示大陸以外的模型
        }
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

// 模型選擇視圖
struct ModelSelectorView: View {
    @State private var selectedModel: LLMModel = .chatgpt // 默認為 ChatGPT
    @State private var availableModels: [LLMModel] = []  // 根據地區篩選出的模型

    var body: some View {
        VStack {
            Text("選擇 LLM 模型")
                .font(.headline)
                .padding()

            // 自定義 HStack 作為選擇器
            HStack {
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
            print(region)
            availableModels = LLMModel.availableModels(for: region)
            // 設置默認選擇模型
            selectedModel = availableModels.first ?? .chatgpt
        }
    }
    
    // 根據模型返回對應的圖標名稱
    private func iconName(for model: LLMModel) -> String {
        switch model {
        case .chatgpt:
            return "ChatGPT"
        case .claude:
            return "person.circle"
        case .gemini:
            return "star.circle"
        case .wenxin:
            return "bolt.circle"
        case .tongyi:
            return "globe"
        case .local:
            return "folder"
        }
    }
}

// 預覽
struct ModelSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        ModelSelectorView()
    }
}
