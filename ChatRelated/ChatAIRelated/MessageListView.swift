//
//  MessageListView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/9.
//

import Foundation
import SwiftUI

struct MessageListView: View {
    @Binding var messages: [Message]
    @Binding var Response: String
    @Binding var dynamicHeight: CGFloat
    let maxHeight: CGFloat

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack {
                    ForEach(messages, id: \.id) { message in
                        HStack {
                            Text(message.isSender ? "你: " : "對方: ")
                                .fontWeight(.bold)
                            Text(getMessageText(message))
                        }
                        .padding()
                        .frame(maxWidth: UIScreen.main.bounds.width - 64, alignment: .leading)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .textSelection(.enabled)
                    }
                    
                    TextViewRepresentable(text: Response,
                                          dynamicHeight: $dynamicHeight,
                                          maxHeight: maxHeight
                    )
                    .frame(maxWidth: UIScreen.main.bounds.width - 64, minHeight: dynamicHeight, maxHeight: dynamicHeight) // 設置最大寬度和最小高度
                    .cornerRadius(10)
                    .padding()
                    .id("Bottom") // 也可以給底部一個 id
                }
                // 當畫面出現時，嘗試捲到最後一筆
                .onAppear {
                    print("[DEBUG] ScrollView onAppear called, messages.count = \(messages.count)")
                    DispatchQueue.main.async {
                        scrollToBottom(proxy: proxy)
                    }
                }
                // 監聽 messages.count 變化，捲到最後一筆
                .onChange(of: messages.count) { _ in
                    scrollToBottom(proxy: proxy)
                }
                // 監聽 GPT 回應的更新，捲到最後一筆
                .onChange(of: Response) { _ in
                    scrollToBottom(proxy: proxy)
                }
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                print("[DEBUG] VStack content height: \(geo.size.height)")
                            }
                    }
                )
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width - 32, maxHeight: 300)
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        // 如果沒有 message，捲動到底部的 TextViewRepresentable
        withAnimation {
            proxy.scrollTo("Bottom", anchor: .bottom)
        }
    }

    private func getMessageText(_ message: Message) -> String {
        switch message.content {
        case .text(let text): return text
        case .image: return "[圖片]"
        case .audio: return "[語音]"
        }
    }
}
