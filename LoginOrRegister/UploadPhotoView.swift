//
//  UploadPhotoView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/3.
//

import Foundation
import SwiftUI
import PhotosUI

struct UploadPhotoView: View {
    @EnvironmentObject var appState: AppState // ✅ 讓 UploadPhotoView 存取 appState
    @EnvironmentObject var userSettings: UserSettings // ✅ 存取用戶設置
    @Binding var selectedCountryCode: String
    @Binding var phoneNumber: String
    @State private var selectedImages: [UIImage?] = Array(repeating: nil, count: 6) // ✅ 六個照片框
    @State private var selectedImage: UIImage?
    @State private var selectedIndex = 0 // ✅ 追蹤當前點擊的上傳框索引
    @State private var showActionSheet = false // ✅ 控制是否顯示選擇方式（拍照 or 相簿）
    @State private var showImagePicker = false
    @State private var showCameraPicker = false
    @State private var isUploading = false

    var body: some View {
        VStack {
            Text("上傳照片")
                .font(.title)
                .padding()
            
            // ✅ 六個上傳框
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                ForEach(0..<6, id: \.self) { index in
                    Button(action: {
                        selectedIndex = index
                        showImagePicker = true
                    }) {
                        ZStack {
                            if let image = selectedImages[index] {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 133)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            } else {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                                    .frame(width: 100, height: 133)
                                    .overlay(
                                        VStack {
                                            Image(systemName: "plus")
                                                .font(.system(size: 24))
                                                .foregroundColor(.gray)
                                            Text("上傳")
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                        }
                                    )
                            }
                        }
                    }
                }
            }
            .padding()

            // ✅ 繼續按鈕（僅在至少上傳 1 張照片時可用）
            Button(action: completeVerification) {
                Text("繼續")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedImages.contains(where: { $0 != nil }) ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(!selectedImages.contains(where: { $0 != nil })) // ✅ 至少上傳 1 張照片才能繼續
            .padding()
        }
        .padding()
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage)
        }
        .fullScreenCover(isPresented: $showCameraPicker) { // ✅ 讓使用者拍照
            ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
        }
        .actionSheet(isPresented: $showActionSheet) { // ✅ 彈出選擇方式
            ActionSheet(
                title: Text("選擇照片來源"),
                buttons: [
                    .default(Text("拍照")) { showCameraPicker = true },
                    .default(Text("從相簿選擇")) { showImagePicker = true },
                    .cancel()
                ]
            )
        }
    }

    private func uploadPhoto() {
        guard let selectedImage = selectedImages[selectedIndex] else {
            print("❌ 沒有選擇圖片")
            return
        }

        isUploading = true

        let url = URL(string: "https://your-api.com/upload-photo")! // ✅ 替換為你的後端 API
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // ✅ 將 UIImage 轉換為 Data（JPEG 格式）
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
            print("❌ 圖片轉換失敗")
            return
        }

        // ✅ 建立 multipart/form-data 格式的 body
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"photo.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        // ✅ 發送圖片到後端
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isUploading = false
            }

            if let error = error {
                print("❌ 上傳失敗: \(error.localizedDescription)")
                return
            }

            print("✅ 照片上傳成功！")
        }.resume()
    }
    
    // ✅ 點擊「繼續」後，設定 appState.isLoggedIn = true
    private func completeVerification() {
        print("✅ 驗證完成，進入主畫面")
        appState.isLoggedIn = true
        userSettings.globalPhoneNumber = phoneNumber
        userSettings.globalCountryCode = selectedCountryCode
    }
}

struct UploadPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        UploadPhotoView(
            selectedCountryCode: .constant("+886"), // ✅ 測試台灣區碼
            phoneNumber: .constant("0972516868")  // ✅ 測試手機號碼
        )
        .previewDevice("iPhone 15 Pro") // ✅ 指定裝置模擬
    }
}
