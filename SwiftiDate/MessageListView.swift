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
        ScrollView {
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
