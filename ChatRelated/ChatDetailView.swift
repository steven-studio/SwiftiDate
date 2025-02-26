//
//  ChatDetailView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/22.
//

import Foundation
import SwiftUI
import UIKit
import WebRTC
import FirebaseStorage

struct ChatDetailView: View {
    @EnvironmentObject var userSettings: UserSettings // 使用 EnvironmentObject 存取 UserSettings
    
    var chat: Chat
    @Binding var messages: [Message]  // Bind to the messages passed from ChatView
    @State private var newMessageText: String = "" // State variable to hold the input message text
    @State private var showChatGPTModal = false // 控制 ChatGPT 彈框的顯示
    @State private var showActionSheet = false // 控制 ActionSheet 彈框的顯示
    var onBack: () -> Void // Add this line to accept the onBack closure
    @State private var isShowingCallView = false
    @State private var showFirstMessageHookupAlert = false
    @State private var showILikeYouAlert = false     // 新增給「立即表白」用
    @State private var showPhishingAlert: Bool = false
    @State private var showScamAlert: Bool = false
    @StateObject var signalingClient = SignalingClient()
    
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
//                    startWebRTCCall()
                }) {
                    Image(systemName: "phone.fill")
                        .resizable() // 使圖標可以調整大小
                        .aspectRatio(contentMode: .fit) // 確保圖標保持比例
                        .frame(width: 25, height: 25) // 調整圖標的寬高，這裡設置為30x30
                        .foregroundColor(.green)
                        .padding(.trailing, 10)
                }
                .fullScreenCover(isPresented: $isShowingCallView) {
                    WebRTCCallView() // 你自定義的通話 UI 視圖
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
                        if case .text(let text) = message.content, text == "她希望可以先聊天，再見面～" {
                            HStack {
                                Text("她希望")
                                    .foregroundColor(.green)

                                Text(text.replacingOccurrences(of: "她希望", with: ""))
                                    .foregroundColor(.black)

                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
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
                TextField("輸入聊天內容", text: $newMessageText, axis: .vertical)
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
                
                if newMessageText == "" {
                    Image(systemName: "microphone.fill")
                        .resizable()
                        .frame(maxWidth: 24, maxHeight: 24)
                        .padding()
                        .foregroundColor(.blue)
                } else {
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding()
                    }
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
        .sheet(isPresented: $showChatGPTModal) {
            ModelSelectorView(messages: $messages) // 彈出 ChatGPT 視圖並傳遞 messages
        }
        .navigationBarHidden(true) // Hide the default navigation bar
        .alert("不要約砲", isPresented: $showFirstMessageHookupAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("不要第一句話就想約砲")
        }
        .alert("表白太快了？", isPresented: $showILikeYouAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("不要把軟蛋放到女生手上")
        }
        .alert("釣魚連結", isPresented: $showPhishingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("不要傳釣魚連結，沒人喜歡")
        }
        .alert("騙人連結", isPresented: $showScamAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("不要騙人，董事長最討厭騙人")
        }
    }

    private func sendMessage() {
        let trimmedText = newMessageText.trimmingCharacters(in: .whitespaces)
        guard !trimmedText.isEmpty else { return }
        
        // 呼叫我們的規則檢查器
        RuleChecker.checkMessage(
            message: trimmedText,
            messagesSoFar: messages,
            currentUserGender: userSettings.globalUserGender
        ) { result in
            switch result {
            case .allow:
                // 符合規則 → 允許送出
                let newMsg = Message(
                    id: UUID(),
                    content: .text(trimmedText),
                    isSender: true,
                    time: getCurrentTime(),
                    isCompliment: false
                )
                messages.append(newMsg)
                newMessageText = ""
                
                // 執行截圖邏輯
                captureScreenshotAndUpload()
                
            case .warn(let warnMsg):
                // 顯示警告，但不阻止送出
                // 例如用 Alert
    //            showILikeYouAlert = true
                // 你在 alert 裡顯示 warnMsg
                
                // 仍然允許訊息送出
                let newMsg = Message(
                    id: UUID(),
                    content: .text(trimmedText),
                    isSender: true,
                    time: getCurrentTime(),
                    isCompliment: false
                )
                messages.append(newMsg)
                newMessageText = ""
                
                // 執行截圖邏輯
                captureScreenshotAndUpload()
                return
                
            case .block(let reason):
                switch reason {
                case .firstMessageHookup:
                    // 顯示「不要第一句就約砲」的 Alert，阻止送出
                    showFirstMessageHookupAlert = true
                    // 不送出
                case .tooFastConfession:
                    // 假如你也要 block 告白
                    showILikeYouAlert = true
                    // 不送出
                case .phishingLink:
                    showPhishingAlert = true
                case .scamKeyword:
                    showScamAlert = true
                }
            }
        }
    }
    
    private func captureScreenshotAndUpload() {
        // 截取屏幕內容
        let renderer = UIGraphicsImageRenderer(bounds: UIScreen.main.bounds)
        
        guard
            let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow }) // 獲取主窗口
        else {
            print("Failed to capture screenshot: No active window found")
            return
        }
        
        let screenshot = renderer.image { context in
            window.layer.render(in: context.cgContext)
        }
        
        uploadScreenshotToFirebase(image: screenshot)
    }
    
    private func uploadScreenshotToFirebase(image: UIImage) {
        // 將 UIImage 壓縮成 JPEG
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("無法將圖片轉換為 JPEG 格式")
            return
        }
        
        // 設定要上傳的檔案路徑與檔名，例如「screenshots/userID_1.jpg」
        let timestamp = Int(Date().timeIntervalSince1970) // or use a more precise format
        let storageRef = Storage.storage()
            .reference()
            .child("screenshots")
            .child("\(userSettings.globalUserID)")
            .child("screenshot_\(timestamp).jpg")
        // 或改成 "\(userID)/\(UUID().uuidString).jpg" 以確保每次都用新檔名
        
        // 建立檔案的 metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // 上傳
        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("上傳失敗：\(error.localizedDescription)")
                return
            }
            // 上傳成功後可以取得下載 URL
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("取得下載URL失敗：\(error.localizedDescription)")
                    return
                }
                if let downloadURL = url {
                    print("截圖成功上傳到 Firebase：\(downloadURL.absoluteString)")
                    // 你可以將這個下載URL存到 Firestore 或其他地方
                }
            }
        }
    }
    
    private func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: Date())
    }
    
    private func startWebRTCCall() {
        // 假設 chat 有個 userId
        let targetUserId = chat.id.uuidString  // 或 your back-end userId
        // 這裡呼叫 signaling
        signalingClient.send("callRequest", payload: ["targetId": targetUserId])
        // 接著顯示 UI
        isShowingCallView = true
    }
}

// PreviewProvider for ChatDetailView
struct ChatDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a dummy chat to preview
        let dummyChat = Chat(id: UUID(), name: "Laiiiiiiii", time: "01:50", unreadCount: 3, phoneNumber: "0912345678")
        
        ChatDetailView(chat: dummyChat, messages: .constant([
            Message(
                id: UUID(),
                content: .text("嗨～ 你有在這上面遇到什麼有趣的人嗎？"),
                isSender: true,
                time: "09/12 15:53",
                isCompliment: false
            ),
            Message(
                id: UUID(),
                content: .text("你要夠有趣的哈哈哈"),
                isSender: false,
                time: "09/16 02:09",
                isCompliment: false
            ),
            Message(
                id: UUID(),
                content: .text("我也不知道耶~"),
                isSender: true,
                time: "09/20 15:03",
                isCompliment: false
            ),
            Message(
                id: UUID(),
                content: .text("我喜歡旅遊、追劇、吃日料 ，偶爾小酌，妳平常喜歡做什麼？"),
                isSender: true,
                time: "09/20 15:03",
                isCompliment: false
            ),
            Message(
                id: UUID(),
                content: .text("還是像我一樣有趣的哈哈哈"),
                isSender: true,
                time: "09/20 15:03",
                isCompliment: false
            ),
            Message(
                id: UUID(),
                content: .text("跳舞跟唱歌"),
                isSender: false,
                time: "09/21 01:50",
                isCompliment: false
            ),
            Message(
                id: UUID(),
                content: .text("😂"),
                isSender: false,
                time: "09/21 01:50",
                isCompliment: false
            ),
            Message(
                id: UUID(),
                content: .text("吃美食跟看劇"),
                isSender: false,
                time: "09/21 01:50",
                isCompliment: false
            )
        ]), onBack: {
            // Provide an empty closure or action for the onBack parameter
        })
    }
}
