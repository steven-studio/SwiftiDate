//
//  LocalModelView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/3.
//

import SwiftUI

struct LocalModelView: View {
    @State private var availableModels = ["Llama 2", "Mistral 7B", "GPT4All", "Custom Model"]
    @State private var selectedModel: String? = "Llama 2"
    @State private var temperature: Double = 0.7
    @State private var maxTokens: Int = 512
    @State private var userInput: String = ""
    @State private var responseText: String = "這裡會顯示模型回應..."
    @State private var isProcessing = false
    @Binding var messages: [Message]  // Bind to the messages passed from modelSelector
    @Binding var showLocalModel: Bool

    var body: some View {
        NavigationStack {
            VStack {
                // 🔹 模型選擇
                Picker("選擇本地模型", selection: $selectedModel) {
                    ForEach(availableModels, id: \.self) { model in
                        Text(model).tag(model)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()

                // 🔹 參數調整
                VStack {
                    HStack {
                        Text("溫度（Temperature）")
                        Slider(value: $temperature, in: 0.1...1.0, step: 0.1)
                        Text(String(format: "%.1f", temperature))
                    }
                    .padding()

                    HStack {
                        Text("最大 Token")
                        Slider(value: Binding(get: { Double(maxTokens) }, set: { maxTokens = Int($0) }), in: 128...2048, step: 128)
                        Text("\(maxTokens)")
                    }
                    .padding()
                }
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding()

                // 🔹 用戶輸入
                TextEditor(text: $userInput)
                    .frame(height: 100)
                    .padding()
                    .border(Color.gray, width: 1)
                    .cornerRadius(8)
                
                // 🔹 模型回應
                ScrollView {
                    Text(responseText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                .frame(height: 150)
                .padding()

                // 🔹 送出按鈕
                Button(action: generateResponse) {
                    HStack {
                        if isProcessing {
                            ProgressView()
                        }
                        Text(isProcessing ? "生成中..." : "生成回應")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
            .padding()
            .navigationTitle("本地 AI 模型")
        }
    }

    // 模擬本地推理處理
    func generateResponse() {
        isProcessing = true
        responseText = "處理中..."
        
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 2.0) {
            let generatedText = "這是「\(selectedModel ?? "未知模型")」產生的回應，溫度 \(String(format: "%.1f", temperature))，最大 Tokens \(maxTokens)。"
            
            DispatchQueue.main.async {
                responseText = generatedText
                isProcessing = false
            }
        }
    }
}

struct LocalModelView_Previews: PreviewProvider {
    static var previews: some View {
        LocalModelView(messages: .constant([ // 使用 .constant 來模擬綁定數據
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
                                           ]), showLocalModel: .constant(true))
    }
}
