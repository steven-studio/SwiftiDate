//
//  ChatDetailView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/22.
//

import Foundation
import SwiftUI

struct ChatDetailView: View {
    @EnvironmentObject var userSettings: UserSettings // 使用 EnvironmentObject 存取 UserSettings
    
    var chat: Chat
    @Binding var messages: [Message]  // Bind to the messages passed from ChatView
    @State private var newMessageText: String = "" // State variable to hold the input message text
    @State private var showChatGPTModal = false // 控制 ChatGPT 彈框的顯示
    @State private var showActionSheet = false // 控制 ActionSheet 彈框的顯示
    var onBack: () -> Void // Add this line to accept the onBack closure

    var body: some View {
        VStack {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    onBack() // Call the onBack closure when the button is pressed
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                }

                Image(systemName: "person.crop.circle.fill") // Avatar Image (replace with actual image)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .padding(.leading, 5)

                Text(chat.name)
                    .font(.headline)
                    .padding(.leading, 5)
                
                Image(systemName: "bell.fill") // Notification Bell Icon
                    .foregroundColor(.pink)
                    .padding(.leading, 5)

                Spacer()
                
                Button(action: {
                    if let phoneURL = URL(string: "tel://\(userSettings.globalPhoneNumber)") {
                        if UIApplication.shared.canOpenURL(phoneURL) {
                            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
                        } else {
                            print("無法撥打電話，請檢查電話號碼格式")
                        }
                    }
                }) {
                    Image(systemName: "phone.fill")
                        .resizable() // 使圖標可以調整大小
                        .aspectRatio(contentMode: .fit) // 確保圖標保持比例
                        .frame(width: 25, height: 25) // 調整圖標的寬高，這裡設置為30x30
                        .foregroundColor(.green)
                        .padding(.trailing, 10)
                }
                
                Button(action: {
                    showActionSheet = true // 顯示 ActionSheet
                }) {
                    Image(systemName: "ellipsis")
                        .resizable() // 使圖標可以調整大小
                        .aspectRatio(contentMode: .fit) // 確保圖標保持比例
                        .frame(width: 25, height: 25) // 調整圖標的寬高，這裡設置為30x30
                        .foregroundColor(.black)
                        .padding(.trailing, 10)
                }
                .actionSheet(isPresented: $showActionSheet) {
                    ActionSheet(
                        title: Text("選項"),
                        message: Text("請選擇你想進行的操作"),
                        buttons: [
                            .default(Text("修改備註名稱")) {
                                // Handle "修改備註名稱" action
                                print("修改備註名稱 selected")
                            },
                            .default(Text("匿名檢舉和封鎖")) {
                                // Handle "匿名檢舉和封鎖" action
                                print("匿名檢舉和封鎖 selected")
                            },
                            .default(Text("安全中心")) {
                                // Handle "安全中心" action
                                print("安全中心 selected")
                            },
                            .default(Text("刪除聊天記錄")) {
                                // Handle "刪除聊天記錄" action
                                print("刪除聊天記錄 selected")
                            },
                            .default(Text("解除配對")) {
                                // Handle "解除配對" action
                                print("解除配對 selected")
                            },
                            .cancel(Text("取消"))
                        ]
                    )
                }
            }
            .frame(height: 60)
            .background(Color.white)
            
            Divider() // Divider line
            
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    ForEach(messages.indices, id: \.self) { index in
                        let message = messages[index]
                        let showTime = index == 0 || messages[index].time != messages[index - 1].time

                        // Special check for the specific text message
                        if message.text == "她希望可以先聊天，再見面～" {
                            // Display this message as simple Text
                            HStack {
                                Text("她希望")
                                    .foregroundColor(.green) // Set the color for the specific text

                                Text(message.text.replacingOccurrences(of: "她希望", with: "")) // Replace the specific text with an empty string
                                    .foregroundColor(.black) // Default color for the rest of the text
                                
                                Spacer() // Add a Spacer to push the text to the left side
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading) // Align the entire HStack to the left
                            .background(Color.green.opacity(0.1)) // Apply background to the entire HStack
                            .cornerRadius(10) // Apply corner radius to the HStack
                            .padding(.horizontal) // Add horizontal padding around the whole HStack
                        } else {
                            // Display other messages as message bubbles
                            MessageBubbleView(message: message, isCurrentUser: message.isSender, showTime: showTime)
                                .padding(.horizontal)
                                .padding(.top, 5)
                        }
                    }
                }
                .onAppear {
                    // Scroll to the last message when the view appears
                    if let lastIndex = messages.indices.last {
                        scrollViewProxy.scrollTo(lastIndex, anchor: .bottom)
                    }
                }
            }
            
            HStack {
                TextField("輸入聊天內容", text: $newMessageText)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                
                // 替代圖標，如表示 AI 的圖標
                Button(action: {
                    showChatGPTModal = true  // 當按下時顯示 ChatGPT 的彈框
                }) {
                    Image(systemName: "brain.head.profile")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 5)
                }

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding()
                }
            }
            .padding()
        }
        .sheet(isPresented: $showChatGPTModal) {
            ChatGPTView(messages: $messages) // 彈出 ChatGPT 視圖並傳遞 messages
        }
        .navigationBarHidden(true) // Hide the default navigation bar
    }

    private func sendMessage() {
        guard !newMessageText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let newMessage = Message(
            id: UUID(),
            text: newMessageText,
            isSender: true,  // 將此訊息標記為當前使用者發送的
            time: getCurrentTime(),
            isCompliment: false
        )
        messages.append(newMessage)
        
        // Clear the text field
        newMessageText = ""
        
        // Code to send a new message and update the conversation in your data source can be added here
    }
    
    private func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: Date())
    }
}

// PreviewProvider for ChatDetailView
struct ChatDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a dummy chat to preview
        let dummyChat = Chat(id: UUID(), name: "Laiiiiiiii", time: "01:50", unreadCount: 3)
        
        ChatDetailView(chat: dummyChat, messages: .constant([
            Message(id: UUID(), text: "嗨～ 你有在這上面遇到什麼有趣的人嗎？", isSender: true, time: "09/12 15:53", isCompliment: false),
            Message(id: UUID(), text: "你要夠有趣的哈哈哈", isSender: false, time: "09/16 02:09", isCompliment: false),
            Message(id: UUID(), text: "我也不知道耶~", isSender: true, time: "09/20 15:03", isCompliment: false),
            Message(id: UUID(), text: "我喜歡旅遊、追劇、吃日料 ，偶爾小酌，妳平常喜歡做什麼？", isSender: true, time: "09/20 15:03", isCompliment: false),
            Message(id: UUID(), text: "還是像我一樣有趣的哈哈哈", isSender: true, time: "09/20 15:03", isCompliment: false),
            Message(id: UUID(), text: "跳舞跟唱歌", isSender: false, time: "09/21 01:50", isCompliment: false),
            Message(id: UUID(), text: "😂", isSender: false, time: "09/21 01:50", isCompliment: false),
            Message(id: UUID(), text: "吃美食跟看劇", isSender: false, time: "09/21 01:50", isCompliment: false)
        ]), onBack: {
            // Provide an empty closure or action for the onBack parameter
        })
    }
}
