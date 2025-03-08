//
//  ChatRow.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/16.
//

import Foundation
import SwiftUI

// 聊天行的顯示樣式
struct ChatRow: View {
    var chat: Chat
    var messages: [Message] // Add this parameter
    
    var body: some View {
        HStack(spacing: 15) {
            // Avatar image
            if let uiImage = UIImage(named: chat.name) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .padding(4)
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
                    .clipShape(Circle())
                    .padding(4)
            }
            
            VStack(alignment: .leading) {
                Text(chat.name)
                    .font(.headline)
                    .foregroundColor(.black) // Set the text color to black

                // Display the last message
                if let lastMessage = messages.last {
                    Text(lastMessage.text)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            VStack {
                Text(chat.time)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                if chat.unreadCount > 0 {
                    Text("\(chat.unreadCount)")
                        .font(.caption)
                        .padding(5)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.vertical, 5)
    }
}
