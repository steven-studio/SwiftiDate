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
                                    .overlay(removePhotoButton(index: index), alignment: .topTrailing) // 對齊至右上角
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
                                    .onTapGesture {
                                        showActionSheet = true
                                    }
                            }
                        }
                    }
                }
            }
            .padding()

            // ✅ 繼續按鈕（僅在至少上傳 1 張照片時可用）
            Button(action: {
                AnalyticsManager.shared.trackEvent("UploadPhoto_ContinueTapped", parameters: ["uploadedCount": selectedImages.compactMap { $0 }.count])
                FirebasePhotoManager.shared.uploadAllPhotos()
                completeVerification()
            }) {
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
                        selectedImages[selectedIndex] = newlyPickedImage
                        AnalyticsManager.shared.trackEvent("UploadPhoto_ImageSelected", parameters: ["source": "photoLibrary", "index": selectedIndex])

                        PhotoUtility.addImageToPhotos(newlyPickedImage, to: userSettings)
                        
                        print("✅ 用戶選了照片，並已存本地檔案名: \(newlyPickedImage)")
                        // 若想要此時就同步上傳，也可在這裡呼叫 uploadPhoto(…)
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
            "aboutMe": userSettings.aboutMe ?? "default about me",
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
