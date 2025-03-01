//
//  EditProfileView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/8/18.
//

import Foundation
import SwiftUI
import FirebaseStorage
import FirebaseFirestore

// Enum for ProfileTab
enum ProfileTab: String {
    case edit = "編輯"
    case preview = "預覽"
}

// Safe array access extension
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct EditProfileView: View {
    @EnvironmentObject var userSettings: UserSettings // 使用 EnvironmentObject 存取 UserSettings
    
    @State private var selectedTab: ProfileTab = .edit
    @Binding var photos: [String] // Change photos to a Binding variable
    @State private var deletedPhotos: [String] = [] // 用來存放被刪除的照片URL
    @State private var aboutMe = "能見面左右滑謝謝🙏\n一起吃日料吧🍣\n抽水煙也可以💨"
    @State private var currentPhotoIndex = 0
    @State private var isShowingVerificationView = false // 新增這個變量來控制驗證頁面的顯示

    @State private var selectedDegree: String? = "碩士及以上"  // 改为可选类型
    @State private var showDegreePicker = false // 新增
    let degrees = ["高中", "職校/專科", "學士", "碩士及以上", "其他學歷"] // 新增

    @State private var selectedSchool: String? = "台灣大學" // 新增
    @State private var showSchoolInput = false // 新增
    
    @State private var selectedIndustry: String? = "學生" // 新增
    @State private var showIndustryPicker = false // 新增
    
    @State private var selectedJob: String? = "自由接案者"
    @State private var showJobInput = false
    
    @State private var selectedHometown: String? = "台中"  // 当前选中的家乡
    @State private var showHometownInput = false  // 是否显示输入视图
    
    @State private var selectedLanguages: [String] = ["中文"]
    @State private var showLanguageSelection = false
    
    @State private var selectedHeight: Int? = 180
    @State private var showHeightPicker = false
    
    @State private var selectedZodiac: String = "巨蟹座"
    @State private var showZodiacPicker = false
    
    @State private var selectedBloodType: String? = "O型"
    @State private var showBloodTypePicker = false
    
    @State private var selectedLookingFor: String? = "穩定的關係"
    @State private var showLookingForView = false

    @State private var selectedPet: String? = "沒有寵物"
    @State private var showPetSelectionView = false

    @State private var selectedFitnessOption: String? = "經常健身"
    @State private var showFitnessOptions = false

    @State private var selectedSmokingOption: String? = "不抽煙"
    @State private var showSmokingOptions = false

    @State private var selectedDrinkOption: String? = "只在社交場合"
    @State private var showDrinkOptions = false

    @State private var selectedVacationOption: String? = "時間自己掌控"
    @State private var showVacationOptions = false

    @State private var selectedDietPreference: String? = "其他飲食偏好"
    @State private var showDietPreferences = false

    @State private var selectedMeetWillingness: String? = nil  // 用來存儲選中的見面意願
    @State private var isShowingMeetWillingnessView = false  // 新增：控制是否顯示 MeetWillingnessView
    
    let industries = [
        "藝術/設計", "建築", "航空/交通運輸", "商業/金融", "傳播/媒體", "文創產業",
        "時尚/模特", "健身/體育", "自由業", "教育培訓", "工程技術", "政府機關",
        "醫療/醫藥", "律政行業", "市場營銷", "製造業", "NGO/慈善事業", "公眾關係",
        "銷售/零售業", "媒體傳播/自媒體", "社會工作者", "學生", "科技行業/科學研究",
        "旅遊業", "其他：新創/創業", "其他：自營企業", "其他行業"
    ]
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedInterests: Set<String> = []  // 用來追蹤選中的標籤
    @State private var interestColors: [String: Color] = [:]  // 新增 interestColors 變量
    
    // Custom initializer with optional selectedInterests
    init(photos: Binding<[String]>, selectedInterests: Set<String> = []) {
        _photos = photos // Initialize with the binding
        _selectedInterests = State(initialValue: selectedInterests)
        _interestColors = State(initialValue: [:]) // 初始化為空字典
    }

    var body: some View {
        NavigationView {
            VStack {
                ProfileTabPicker(selectedTab: $selectedTab)

                if selectedTab == .edit {
                    // 編輯界面
                    EditSectionView(
                        photos: $photos,
                        deletedPhotos: $deletedPhotos,
                        aboutMe: $aboutMe,
                        isShowingVerificationView: $isShowingVerificationView,
                        selectedMeetWillingness: $selectedMeetWillingness,
                        isShowingMeetWillingnessView: $isShowingMeetWillingnessView,
                        selectedInterests: $selectedInterests,
                        interestColors: $interestColors,
                        selectedDegree: $selectedDegree,
                        selectedSchool: $selectedSchool,
                        selectedIndustry: $selectedIndustry,
                        selectedJob: $selectedJob,
                        showDegreePicker: $showDegreePicker,
                        showSchoolInput: $showSchoolInput,
                        showIndustryPicker: $showIndustryPicker,
                        showJobInput: $showJobInput,
                        degrees: degrees,
                        industries: industries,
                        selectedHometown: $selectedHometown,
                        showHometownInput: $showHometownInput,
                        selectedLanguages: $selectedLanguages,
                        showLanguageSelection: $showLanguageSelection,
                        selectedHeight: $selectedHeight,
                        showHeightPicker: $showHeightPicker,
                        selectedZodiac: $selectedZodiac,
                        showZodiacPicker: $showZodiacPicker,
                        selectedBloodType: $selectedBloodType,
                        showBloodTypePicker: $showBloodTypePicker,
                        selectedLookingFor: $selectedLookingFor,
                        showLookingForView: $showLookingForView,
                        selectedPet: $selectedPet,
                        showPetSelectionView: $showPetSelectionView,
                        selectedFitnessOption: $selectedFitnessOption,
                        showFitnessOptions: $showFitnessOptions,
                        selectedSmokingOption: $selectedSmokingOption,
                        showSmokingOptions: $showSmokingOptions,
                        selectedDrinkOption: $selectedDrinkOption,
                        showDrinkOptions: $showDrinkOptions,
                        selectedVacationOption: $selectedVacationOption,
                        showVacationOptions: $showVacationOptions,
                        selectedDietPreference: $selectedDietPreference,
                        showDietPreferences: $showDietPreferences
                    )
                    .environmentObject(userSettings) // 傳遞 EnvironmentObject
                } else {
                    PreviewSectionView(photos: $photos, currentPhotoIndex: $currentPhotoIndex, aboutMe: aboutMe, selectedZodiac: selectedZodiac, selectedJob: selectedJob)
                }
            }
            .navigationBarTitle("編輯個人資料", displayMode: .inline)
            .navigationBarItems(
                leading: backButton,
                trailing: saveButton
            )
        }
    }
    
    // "返回" 按鈕的行為
    private var backButton: some View {
        Button(action: handleBack) {
            HStack {
                Image(systemName: "chevron.left")
                    .font(.headline)
            }
        }
    }
    
    // "保存" 按鈕的行為
    private var saveButton: some View {
        Button("保存", action: handleSave)
    }
    
    // 處理 "返回" 的邏輯
    private func handleBack() {
        // 1. 可先埋點，代表使用者按下了返回、未做保存
        AnalyticsManager.shared.trackEvent("edit_profile_back_clicked")
        
        // 將 deletedPhotos 中的照片移回到 photos
        deletedPhotos.sort(by: >) // 逆序排序
        photos.append(contentsOf: deletedPhotos)

        // 更新 loadedPhotosString 以包含最新的照片列表
        userSettings.loadedPhotosString = photos.joined(separator: ",")

        // 清空 deletedPhotos
        deletedPhotos.removeAll()

        // Custom action to go back
        presentationMode.wrappedValue.dismiss()
    }
    
    // 處理 "保存" 的邏輯
    private func handleSave() {
        print("handleSave called")
        AnalyticsManager.shared.trackEvent("edit_profile_save_clicked", parameters: [
            "photos_count": photos.count,
            "deleted_count": deletedPhotos.count,
            "aboutMe_length": aboutMe.count,
            "interests_count": selectedInterests.count
            // ...其他欄位
        ])
        
        // 遍歷 deletedPhotos，逐一從 Firebase 刪除
        for photoURL in deletedPhotos {
            deletePhotoFromFirebase(photoURL: photoURL)
        }

        // 上傳新添加的照片到 Firebase
        uploadNewPhotosToFirebase()
        
        // 保存用戶資料到 Firestore
        saveUserProfileToFirestore()

        // 完成後返回到上一頁
        presentationMode.wrappedValue.dismiss()
    }
    
    // 上傳新照片到 Firebase 的函數
    func uploadNewPhotosToFirebase() {
        let storage = Storage.storage()
        let userID = userSettings.globalUserID // 假設從 UserSettings 取得用戶 ID
        let storageRef = storage.reference().child("user_photos/\(userID)")

        // 找出需要上傳的照片
        for (index, photoName) in photos.enumerated() {
            let expectedPhotoName = "photo\(index + 1)" // 期待的照片名稱格式
            
            if !isPhotoAlreadyUploaded(photoName: photoName) {
                // 如果照片還沒有上傳過
                if let localImage = PhotoUtility.loadImageFromLocalStorage(named: photoName),
                   let imageData = localImage.jpegData(compressionQuality: 0.8) {
                    
                    let photoRef = storageRef.child("\(expectedPhotoName).jpeg") // Firebase 儲存名稱
                    
                    let uploadTask = photoRef.putData(imageData, metadata: nil) { (metadata, error) in
                        if let error = error {
                            print("Failed to upload photo: \(error.localizedDescription)")
                        } else {
//                            print("Photo \(expectedPhotoName) uploaded successfully.")
                        }
                    }
                    
                    // 可選：監聽上傳進度
                    uploadTask.observe(.progress) { snapshot in
                        _ = 100.0 * Double(snapshot.progress?.completedUnitCount ?? 0) / Double(snapshot.progress?.totalUnitCount ?? 0)
//                        print("Upload is \(percentComplete)% complete.")
                    }
                }
            }
        }
    }

    // 檢查照片是否已經上傳的輔助函數
    func isPhotoAlreadyUploaded(photoName: String) -> Bool {
        // 假設所有 Firebase 上傳的照片都以 "photo" 開頭
        return photoName.starts(with: "photo")
    }
    
    // 將用戶資料保存到 Firestore
    func saveUserProfileToFirestore() {
        let db = Firestore.firestore() // 初始化 Firestore 參考
        let userID = userSettings.globalUserID // 從 UserSettings 取得用戶 ID

        // 創建字典，將所有變量作為鍵值對存儲
        let userData: [String: Any] = [
            "aboutMe": aboutMe,
            "selectedDegree": selectedDegree ?? "",
            "selectedSchool": selectedSchool ?? "",
            "selectedIndustry": selectedIndustry ?? "",
            "selectedJob": selectedJob ?? "",
            "selectedHometown": selectedHometown ?? "",
            "selectedLanguages": selectedLanguages,
            "selectedHeight": selectedHeight ?? 0,
            "selectedZodiac": selectedZodiac,
            "selectedBloodType": selectedBloodType ?? "",
            "selectedLookingFor": selectedLookingFor ?? "",
            "selectedPet": selectedPet ?? "",
            "selectedFitnessOption": selectedFitnessOption ?? "",
            "selectedSmokingOption": selectedSmokingOption ?? "",
            "selectedDrinkOption": selectedDrinkOption ?? "",
            "selectedVacationOption": selectedVacationOption ?? "",
            "selectedDietPreference": selectedDietPreference ?? "",
            "selectedMeetWillingness": selectedMeetWillingness ?? "",
            "selectedInterests": Array(selectedInterests)
        ]

        // 將資料寫入到 users 集合中的特定用戶文件
        print("Attempting to write to Firestore")
        db.collection("users").document(userID).setData(userData) { error in
            if let error = error {
                print("Failed to save user profile to Firestore: \(error.localizedDescription)")
                
                // Log additional error details if available
                if let nsError = error as NSError? {
                    print("Error code: \(nsError.code)")
                    print("Error domain: \(nsError.domain)")
                    print("Error user info: \(nsError.userInfo)")
                }
            } else {
                print("User profile saved successfully to Firestore.")
            }
        }
    }
    
    // 刪除 Firebase Storage 中的照片
    func deletePhotoFromFirebase(photoURL: String) {
        // 創建 Storage 引用
        let storageRef = Storage.storage().reference(forURL: photoURL)
        
        // 調用 delete 方法來刪除圖片
        storageRef.delete { error in
            if let error = error {
                print("Failed to delete photo: \(error.localizedDescription)")
            } else {
                print("Photo deleted successfully from Firebase: \(photoURL)")
                
                // 同時刪除本地存儲中的圖片
                if let imageName = self.extractImageName(from: photoURL) {
                    PhotoUtility.deleteImageFromLocalStorage(named: imageName)
                }
            }
        }
    }

    // 從 Firebase URL 中提取圖片名稱
    func extractImageName(from url: String) -> String? {
        return URL(string: url)?.lastPathComponent
    }
}

struct EditProfileView_Previews: PreviewProvider {
    @State static var mockPhotos = ["photo1", "photo2", "photo3", "photo4", "photo5", "photo6"]
    
    static var previews: some View {
        EditProfileView(photos: $mockPhotos, selectedInterests: ["我喜歡Cosply", "咒術迴戰", "死神", "基本可以做到訊息秒回", "是個理性的人", "有上進心", "我是巨蟹座"]) // Pass selectedInterests first
            .environmentObject(UserSettings()) // 提供一個 mock 的 UserSettings 環境物件
    }
}
