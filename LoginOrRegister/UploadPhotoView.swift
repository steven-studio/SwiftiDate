//
//  UploadPhotoView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/3.
//

import Foundation
import SwiftUI
import PhotosUI
import FirebaseAuth

struct UploadPhotoView: View {
    @EnvironmentObject var appState: AppState // ✅ 讓 UploadPhotoView 存取 appState
    @EnvironmentObject var userSettings: UserSettings // ✅ 存取用戶設置
    @Binding var selectedCountryCode: String
    @Binding var phoneNumber: String
    
    // ✅ 六個照片框 (初始 nil)
    @State private var selectedImages: [UIImage?] = Array(repeating: nil, count: 6) // ✅ 六個照片框
    @State private var selectedImage: UIImage?
    @State private var faceDetected: Bool = false
    @State private var detectionMessage: String = ""
    @State private var selectedIndex = 0 // ✅ 追蹤當前點擊的上傳框索引
    
    @State private var showActionSheet = false // ✅ 控制是否顯示選擇方式（拍照 or 相簿）
    @State private var showImagePicker = false
    @State private var showCropView = false
    @State private var showCameraPicker = false
    @State private var showNicknameInputView = false
    
    // 假設用於裁切的暫存圖片
    @State private var imageToCrop: UIImage?
    
    @State private var isUploading = false
    
    // 建立屬性字串
    var attributedText: AttributedString {
        var text = AttributedString("請選擇一張")
        text.foregroundColor = .gray  // 設定灰色
        
        var greenText = AttributedString("最能凸顯你個人魅力的照片")
        greenText.foregroundColor = .green  // 設定綠色
        
        text.append(greenText)
        
        var text2 = AttributedString("來讓大家認識你吧～")
        text2.foregroundColor = .gray
        
        text.append(text2)
        
        return text
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // 返回上一頁前追蹤返回事件
                    AnalyticsManager.shared.trackEvent("UploadPhoto_BackTapped", parameters: nil)
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.gray.opacity(0.5)) // 設置文字顏色為黑色
                        .padding(.leading)
                }
                Spacer()
            }
            .padding(.top)
            
            Text("上傳你的個人照片")
                .font(.title)
                .bold()
                .padding(40)
            
            // MARK: - 大框 + Plus + 按鈕
            ZStack {
                // 背景外框
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                    .frame(width: 230, height: 320)
                    .foregroundColor(Color.gray.opacity(0.2))
                    .background(Color.gray.opacity(0.05))
                
                if let firstImage = selectedImages[0] {
                    // 已上傳照片時，顯示照片
                    Image(uiImage: firstImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 230, height: 320)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(alignment: .topTrailing) {
                            removePhotoButton(index: 0)
                                .offset(x: -5, y: 5)
                        }
                } else {
                    // 尚未上傳，顯示「＋」與「上傳照片」按鈕
                    VStack {
                        Spacer()
                        
                        Button {
                            selectedIndex = 0
                            showActionSheet = true
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color.green) // 圓形背景顏色，可根據需求調整
                                    .frame(width: 50, height: 50)
                                Image(systemName: "plus")
                                    .font(.system(size:    30, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            selectedIndex = 0
                            showActionSheet = true
                        } label: {
                            Text("上傳照片")
                                .foregroundColor(.white)
                                .padding(.horizontal, 60)
                                .padding(.vertical, 12)
                                .background(Color.green)
                                .cornerRadius(25)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .cornerRadius(10)
                    }
                    .padding()  // 可視需要調整
                    // 讓 VStack 填滿 ZStack 的空間
                    .frame(width: 230, height: 320)
                }
            }
            
            Text(attributedText)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()

            // ✅ 繼續按鈕（僅在至少上傳 1 張照片時可用）
            Button(action: {
                AnalyticsManager.shared.trackEvent("UploadPhoto_ContinueTapped", parameters: ["uploadedCount": selectedImages.compactMap { $0 }.count])
                FirebasePhotoManager.shared.uploadAllPhotos()
                completeVerification()
                
                // 假設只要上傳至少一張照片就可以進入暱稱畫面
                if selectedImages.contains(where: { $0 != nil }) {
                    showNicknameInputView = true
                }
            }) {
                Text("繼續")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedImages.contains(where: { $0 != nil }) ? Color.green : Color.gray)
                    .foregroundColor(.white)
                    .frame(width: 300)
                    .cornerRadius(25)
            }
            .disabled(!selectedImages.contains(where: { $0 != nil })) // ✅ 至少上傳 1 張照片才能繼續
            .padding()
        }
        .padding()
        // MARK: - 畫面出現時記錄事件
        .onAppear {
            AnalyticsManager.shared.trackEvent("UploadPhotoView_Appeared", parameters: nil)
        }
        // MARK: - 選擇相簿
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage)
                .onDisappear {
                    // ✅ 使用者關閉相簿後，若有選擇到照片就存到 selectedImages
                    if let newlyPickedImage = selectedImage {
                        AnalyticsManager.shared.trackEvent("UploadPhoto_ImageSelected", parameters: ["source": "photoLibrary", "index": selectedIndex])

                        PhotoUtility.addImageToPhotos(newlyPickedImage, to: userSettings)
                        
                        // 使用者從相簿選完照片
                        imageToCrop = newlyPickedImage
                        showCropView = true
                        
                        print("✅ 用戶選了照片，並已存本地檔案名: \(newlyPickedImage)")
                        // 若想要此時就同步上傳，也可在這裡呼叫 uploadPhoto(…)
                    }
                }
        }
        
        .sheet(isPresented: $showCropView) {
            if let imageToCrop = imageToCrop {
                CropViewControllerWrapper(image: Binding(
                    get: { imageToCrop },
                    set: { newImage in
                        // 這裡會在裁切完成後回傳新圖
                        self.imageToCrop = newImage
                        self.selectedImages[selectedIndex] = newImage
                    }
                )) { croppedImage in
                    // 當裁切完成後（或點擊確定上傳）
                    self.selectedImages[selectedIndex] = croppedImage
                    // 你也可以在這裡進行臉部偵測或上傳
                }
            }
        }
        
        // MARK: - 拍照
        .fullScreenCover(isPresented: $showCameraPicker) { // ✅ 讓使用者拍照
            ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
                .onDisappear {
                    if let newlyTaken = selectedImage {
                        selectedImages[selectedIndex] = newlyTaken
                        AnalyticsManager.shared.trackEvent("UploadPhoto_ImageSelected", parameters: ["source": "camera", "index": selectedIndex])

                        PhotoUtility.addImageToPhotos(newlyTaken, to: userSettings)
                        print("✅ 用戶拍照成功, 存本地檔案名: \(newlyTaken)")
                    }
                }
        }
        
        // MARK: - 選擇照片來源
        .actionSheet(isPresented: $showActionSheet) { // ✅ 彈出選擇方式
            ActionSheet(
                title: Text("選擇照片來源"),
                buttons: [
                    .default(Text("拍照")) {
                        AnalyticsManager.shared.trackEvent("UploadPhoto_CameraOptionSelected", parameters: ["index": selectedIndex])
                        showCameraPicker = true
                    },
                    .default(Text("從相簿選擇")) {
                        AnalyticsManager.shared.trackEvent("UploadPhoto_PhotoLibraryOptionSelected", parameters: ["index": selectedIndex])
                        showImagePicker = true
                    },
                    .cancel()
                ]
            )
        }
        
        .fullScreenCover(isPresented: $showNicknameInputView) {
            // 這裡放你要顯示的暱稱輸入畫面
            NicknameInputView()
                .environmentObject(appState)       // 如果需要傳遞給 NicknameInputView
                .environmentObject(userSettings)   // 如果需要
        }
    }
    
    // MARK: - 移除照片按鈕 (若需要的話)
    func removePhotoButton(index: Int) -> some View {
        // 可能要先判斷 userSettings.photos 是否有對應
        Button(action: {
            // 從 userSettings.photos 中刪除
            if index < userSettings.photos.count {
                let photoName = userSettings.photos[index]
                removePhoto(photoName: photoName)
                AnalyticsManager.shared.trackEvent("UploadPhoto_RemoveTapped", parameters: ["index": index, "photoName": photoName])
            }
            // 移除當前 selectedImages
            selectedImages[index] = nil
        }) {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30) // 這裡可以調整你想要的大小
                .foregroundColor(.white)
                .background(Color.red)
                .clipShape(Circle())
        }
        .offset(x: 5, y: -5)
    }

    // 移除照片邏輯
    func removePhoto(photoName: String) {
        if let idx = userSettings.photos.firstIndex(of: photoName) {
            userSettings.photos.remove(at: idx)
            userSettings.loadedPhotosString = userSettings.photos.joined(separator: ",")
            // 若要同時刪除本地檔案
            PhotoUtility.deleteImageFromLocalStorage(named: photoName)
            
            print("❌ 已移除照片: \(photoName)")
        }
    }

    // ✅ 點擊「繼續」後，設定 appState.isLoggedIn = true
    private func completeVerification() {
        print("✅ 驗證完成，進入主畫面")
        appState.isLoggedIn = true
        
        // 將手機號碼 & 國碼寫入 userSettings
        userSettings.globalPhoneNumber = phoneNumber
        userSettings.globalCountryCode = selectedCountryCode
        
        // ✅ 這裡新增把使用者資訊存到 Firestore 的動作
        saveUserDataToFirestore()
        AnalyticsManager.shared.trackEvent("UploadPhoto_VerificationComplete", parameters: ["uploadedCount": selectedImages.compactMap { $0 }.count])
    }
    
    // MARK: - 寫入使用者資料到 Firestore
    private func saveUserDataToFirestore() {
        // 1. 拿到 userID (假設你有使用 Firebase Auth，會有 `Auth.auth().currentUser?.uid`)
        guard let userID = Auth.auth().currentUser?.uid else {
            print("❌ 尚未登入 Firebase Auth，無法取得 userID")
            return
        }
        
        // 2. 準備要寫入的資料字典 (示範)
        let userData: [String: Any] = [
            "aboutMe": userSettings.aboutMe,
            "crushCount": userSettings.globalCrushCount,
            "isPremiumUser": userSettings.isPremiumUser,
            "isProfilePhotoVerified": userSettings.isProfilePhotoVerified,
            "isSupremeUser": userSettings.isSupremeUser,
            "isUserVerified": userSettings.globalIsUserVerified,
            "likeCount": 0,
            "likesMeCount": 0,
            // ... 你想要存的其它 key-value
            "phoneNumber": userSettings.globalPhoneNumber,
            "praiseCount": 0,
            "selectedBloodType": "",
            "selectedDegree": "",
            "selectedDietPreference": "",
            "selectedDrinkOption": "",
            "selectedFitnessOption": "",
            "selectedGender": userSettings.globalSelectedGender,
            "selectedHeight": 0.0,
            "selectedHometown": "",
            "selectedIndustry": "",
            "selectedInterests": [],
            "selectedJob": "",
            "selectedLanguages": [],
            "selectedLookingFor": "",
            "selectedMeetWillingness": "",
            "selectedPet": "",
            "selectedSchool": "",
            "selectedSmokingOption": "",
            "selectedVacationOption": "",
            "selectedZodiac": "",
            "storedGender": userSettings.globalUserGender,
            "turboCount": 0,
            "userName": "",
            // ...
            // 你也可以加入照片 URL 的清單
        ]
        
        // 3. 呼叫 FirestoreManager 進行資料庫存取
        FirestoreManager.shared.saveUserData(userID: userID, data: userData) { result in
            switch result {
            case .success():
                print("✅ 成功寫入/更新使用者資料：\(userID)")
            case .failure(let error):
                print("❌ 寫入使用者資料失敗: \(error.localizedDescription)")
            }
        }
    }
}

struct UploadPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        UploadPhotoView(
            selectedCountryCode: .constant("+886"), // ✅ 測試台灣區碼
            phoneNumber: .constant("0972516868")  // ✅ 測試手機號碼
        )
        .environmentObject(AppState())
        .environmentObject(UserSettings())
        .previewDevice("iPhone 16 Pro Max") // ✅ 指定裝置模擬
    }
}
