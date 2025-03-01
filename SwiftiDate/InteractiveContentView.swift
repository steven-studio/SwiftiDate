//
//  InteractiveContentView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/22.
//

import Foundation
import SwiftUI
import FirebaseDatabase

struct InteractiveContentView: View {
    var onBack: () -> Void // Closure to handle back navigation
    @Binding var messages: [Message]  // Bind to the messages passed from ChatView
    @State private var newMessageText: String = "" // State variable to hold the input message text
    
    var body: some View {
        VStack {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    // 埋點：返回按鈕被點擊
                    AnalyticsManager.shared.trackEvent("interactive_content_back_pressed")
                    onBack() // Call the onBack closure when the button is pressed
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                }

                Spacer() // Pushes the back button to the left
                
                Text("戀人卡指南") // Title for the view (Change to your preferred title)
                    .font(.headline)
                
                Spacer() // Ensures the title is centered
            }
            .frame(height: 60)
            .background(Color.white)
            
            Divider() // Divider line under the custom navigation bar
            
            // Main content
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    
                    // Text message example
                    Text("戀人卡每天都會有不同的題目等你來回答！選擇相同答案的兩個人即可直接配對成功～")
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    
                    // An image
                    Image("exampleImage")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width - 40, height: 200)
                        .clipped()
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    // Another informational block with an embedded button
                    VStack(alignment: .leading, spacing: 5) {
                        Text("《滑卡指南》")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Text("👉 點擊卡片可以看到更多資訊哦～")
                            .font(.subheadline)
                            .foregroundColor(.green)
                        
                        Text("❤️ @玩玩，來找到真正適合自己的配對！")
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    
                    // "Continue" button
                    Button(action: {
                        // 埋點：點擊「繼續」按鈕返回聊天列表
                        AnalyticsManager.shared.trackEvent("interactive_content_continue_pressed")
                        onBack() // Call onBack when pressing "Continue" button to go back
                    }) {
                        Text("繼續")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            
            HStack {
                TextField("輸入聊天內容", text: $newMessageText, axis: .vertical)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                
                Button(action: {
                    // 埋點：點擊發送訊息按鈕
                    AnalyticsManager.shared.trackEvent("interactive_message_send_button_pressed", parameters: [
                        "message_length": newMessageText.count
                    ])
                    sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding()
                }
            }
            .padding(2)
            
            HStack {
                
                Spacer()
                
                Image("gif")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue) // 將圖標設為藍色
                
                Spacer()
                
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue) // 將圖標設為藍色
                
                Spacer()
                
                Image(systemName: "map")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue) // 將圖標設為藍色

                Spacer()
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom) // 讓鍵盤彈出時，輸入列能跟著上移
        .navigationBarHidden(true) // Hide the default navigation bar
        .onAppear {
            // 埋點：頁面曝光
            AnalyticsManager.shared.trackEvent("interactive_content_view_appear", parameters: [
                "message_count": messages.count
            ])
        }
    }
    
    private func sendMessage() {
        guard !newMessageText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        // 埋點：在發送訊息之前上報事件
        AnalyticsManager.shared.trackEvent("interactive_message_send", parameters: [
            "message_length": newMessageText.count
        ])
        
        let newMessage = Message(
            id: UUID(),
            content: .text(newMessageText),  // 將文字包裝為 .text
            isSender: true,  // 將此訊息標記為當前使用者發送的
            time: getCurrentTime(),
            isCompliment: false
        )
        messages.append(newMessage)
        newMessageText = "" // 清空輸入框

        // 執行截圖邏輯
//        captureScreenshotAndUpload()
        // 將此訊息再 POST 給電腦上的本機伺服器
        uploadMessageToLocalServer(message: newMessage)
        
        // 2) 寫入 Firebase
        uploadMessageToFirebase(message: newMessage)
    }
    
    func uploadMessageToLocalServer(message: Message) {
        // 將要上傳的資料組成 JSON
        guard case let .text(txt) = message.content else { return }
        
        // 以 isSender 判斷這是否當前使用者的發送人
        let senderName = message.isSender ? userSettings.globalUserName : "Other"
        let senderID   = userSettings.globalUserID  // or maybe you want different logic if isSender == false
        
        let json: [String: Any] = [
            "content": txt,
            "senderName": senderName,
            "senderID": senderID,
            "time": message.time
        ]
        
        guard let url = URL(string: "https://5591-114-25-68-44.ngrok-free.app/saveMessage"),
              let httpBody = try? JSONSerialization.data(withJSONObject: json, options: []) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error uploading message: \(error)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("Server responded with status code: \(httpResponse.statusCode)")
            }
        }
        task.resume()
    }
    
    func uploadMessageToFirebase(message: Message) {
        // 範例使用 Realtime Database
        // 需先 import FirebaseDatabase
        
        let ref = Database.database().reference()
        
        // 假設要以 "messages/{autoId}" 儲存
        // 也可自訂 userID, chatID
        let messagesRef = ref.child("messages").childByAutoId()

        guard case let .text(txt) = message.content else { return }
        
        let data: [String: Any] = [
            "content": txt,
            "isSender": message.isSender,
            "time": message.time
        ]
        
        messagesRef.setValue(data) { error, _ in
            if let error = error {
                print("Firebase upload error: \(error)")
            } else {
                print("Message successfully stored in Firebase.")
            }
        }
    }
    
    private func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: Date())
    }
}

// MARK: - Preview
struct InteractiveContentView_Previews: PreviewProvider {
    static var previews: some View {
        InteractiveContentView(onBack: {
            // 這裡可以留空或填入你想測試的動作
        }, messages: .constant([]))
    }
}
