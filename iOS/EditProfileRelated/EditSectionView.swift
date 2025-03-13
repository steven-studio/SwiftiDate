//
//  EditSectionView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/17.
//

import Foundation
import SwiftUI

struct EditSectionView: View {
    @Binding var photos: [String]
    @Binding var deletedPhotos: [String]
    @Binding var aboutMe: String
    @Binding var isShowingVerificationView: Bool
    @EnvironmentObject var userSettings: UserSettings
    @Binding var selectedMeetWillingness: String?
    @Binding var isShowingMeetWillingnessView: Bool
    @Binding var selectedInterests: Set<String>
    @Binding var interestColors: [String: Color]
    @Binding var selectedDegree: String?
    @Binding var selectedSchool: String?
    @Binding var selectedIndustry: String?
    @Binding var selectedJob: String?
    @Binding var showDegreePicker: Bool
    @Binding var showSchoolInput: Bool
    @Binding var showIndustryPicker: Bool
    @Binding var showJobInput: Bool
    let degrees: [String]
    let industries: [String]
    @Binding var selectedHometown: String?
    @Binding var showHometownInput: Bool
    @Binding var selectedLanguages: [String]
    @Binding var showLanguageSelection: Bool
    @Binding var selectedHeight: Int?
    @Binding var showHeightPicker: Bool
    @Binding var selectedZodiac: String
    @Binding var showZodiacPicker: Bool
    @Binding var selectedBloodType: String?
    @Binding var showBloodTypePicker: Bool
    @Binding var selectedLookingFor: String?
    @Binding var showLookingForView: Bool
    @Binding var selectedPet: String?
    @Binding var showPetSelectionView: Bool
    @Binding var selectedFitnessOption: String?
    @Binding var showFitnessOptions: Bool
    @Binding var selectedSmokingOption: String?
    @Binding var showSmokingOptions: Bool
    @Binding var selectedDrinkOption: String?
    @Binding var showDrinkOptions: Bool
    @Binding var selectedVacationOption: String?
    @Binding var showVacationOptions: Bool
    @Binding var selectedDietPreference: String?
    @Binding var showDietPreferences: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                // 照片區域
                PhotoSection(photos: $photos, deletedPhotos: $deletedPhotos)
                
                // 智慧照片曝光
                SmartPhotoToggle()
                
                // 認證狀態
                VerificationStatusView(isShowingVerificationView: $isShowingVerificationView, photos: $photos)
                    .environmentObject(userSettings) // Provide the UserSettings environment object
                
                // 關於我
                AboutMeSection(aboutMe: $aboutMe)
                
                // 見面意願
                MeetWillingnessSection(
                    selectedMeetWillingness: $selectedMeetWillingness,
                    isShowingMeetWillingnessView: $isShowingMeetWillingnessView
                )
                
                // 興趣標籤
                InterestsView(
                    interests: Array(selectedInterests.shuffled().prefix(6)),
                    selectedInterests: $selectedInterests,
                    interestColors: $interestColors  // 傳遞 interestColors 作為 @Binding
                )
                
                // 教育和工作
                EducationAndWorkView(
                    selectedDegree: $selectedDegree,
                    selectedSchool: $selectedSchool,
                    selectedIndustry: $selectedIndustry,
                    selectedJob: $selectedJob,
                    showDegreePicker: $showDegreePicker,
                    showSchoolInput: $showSchoolInput,
                    showIndustryPicker: $showIndustryPicker,
                    showJobInput: $showJobInput,
                    degrees: degrees,
                    industries: industries
                )
                
                // 基本資料
                BasicInfoView(
                    selectedHometown: $selectedHometown,
                    showHometownInput: $showHometownInput,
                    selectedLanguages: $selectedLanguages,
                    showLanguageSelection: $showLanguageSelection,
                    selectedHeight: $selectedHeight,
                    showHeightPicker: $showHeightPicker,
                    selectedZodiac: $selectedZodiac,
                    showZodiacPicker: $showZodiacPicker,
                    selectedBloodType: $selectedBloodType,
                    showBloodTypePicker: $showBloodTypePicker
                )
                
                // 生活方式
                LifestyleView(
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
            }
        }
        .background(Color.gray.opacity(0.1)) // 设置背景颜色为淡灰色
    }
}


// 添加 PreviewProvider
struct EditSectionView_Previews: PreviewProvider {
    @State static var mockPhotos = ["photo1", "photo2", "photo3", "photo4", "photo5", "photo6"]
    @State static var mockDeletedPhotos: [String] = []
    @State static var mockAboutMe = "能見面左右滑謝謝🙏\n一起吃日料吧🍣\n抽水煙也可以💨"
    @State static var mockIsShowingVerificationView = false
    @State static var mockSelectedMeetWillingness: String? = nil
    @State static var mockIsShowingMeetWillingnessView = false
    @State static var mockSelectedInterests: Set<String> = ["Coding", "Music", "Travel"]
    @State static var mockInterestColors: [String: Color] = [:]
    @State static var mockSelectedDegree: String? = "碩士及以上"
    @State static var mockSelectedSchool: String? = "台灣大學"
    @State static var mockSelectedIndustry: String? = "學生"
    @State static var mockSelectedJob: String? = "自由接案者"
    @State static var mockShowDegreePicker = false
    @State static var mockShowSchoolInput = false
    @State static var mockShowIndustryPicker = false
    @State static var mockShowJobInput = false
    @State static var mockDegrees = ["高中", "職校/專科", "學士", "碩士及以上", "其他學歷"]
    @State static var mockIndustries = [
        "藝術/設計", "建築", "航空/交通運輸", "商業/金融", "傳播/媒體", "文創產業",
        "時尚/模特", "健身/體育", "自由業", "教育培訓", "工程技術", "政府機關",
        "醫療/醫藥", "律政行業", "市場營銷", "製造業", "NGO/慈善事業", "公眾關係",
        "銷售/零售業", "媒體傳播/自媒體", "社會工作者", "學生", "科技行業/科學研究",
        "旅遊業", "其他：新創/創業", "其他：自營企業", "其他行業"
    ]
    @State static var mockSelectedHometown: String? = "台中"
    @State static var mockShowHometownInput = false
    @State static var mockSelectedLanguages: [String] = ["中文"]
    @State static var mockShowLanguageSelection = false
    @State static var mockSelectedHeight: Int? = 180
    @State static var mockShowHeightPicker = false
    @State static var mockSelectedZodiac: String = "巨蟹座"
    @State static var mockShowZodiacPicker = false
    @State static var mockSelectedBloodType: String? = "O型"
    @State static var mockShowBloodTypePicker = false
    @State static var mockSelectedLookingFor: String? = "穩定的關係"
    @State static var mockShowLookingForView = false
    @State static var mockSelectedPet: String? = "沒有寵物"
    @State static var mockShowPetSelectionView = false
    @State static var mockSelectedFitnessOption: String? = "經常健身"
    @State static var mockShowFitnessOptions = false
    @State static var mockSelectedSmokingOption: String? = "不抽煙"
    @State static var mockShowSmokingOptions = false
    @State static var mockSelectedDrinkOption: String? = "只在社交場合"
    @State static var mockShowDrinkOptions = false
    @State static var mockSelectedVacationOption: String? = "時間自己掌控"
    @State static var mockShowVacationOptions = false
    @State static var mockSelectedDietPreference: String? = "其他飲食偏好"
    @State static var mockShowDietPreferences = false

    static var previews: some View {
        EditSectionView(
            photos: $mockPhotos,
            deletedPhotos: $mockDeletedPhotos,
            aboutMe: $mockAboutMe,
            isShowingVerificationView: $mockIsShowingVerificationView,
            selectedMeetWillingness: $mockSelectedMeetWillingness,
            isShowingMeetWillingnessView: $mockIsShowingMeetWillingnessView,
            selectedInterests: $mockSelectedInterests,
            interestColors: $mockInterestColors,
            selectedDegree: $mockSelectedDegree,
            selectedSchool: $mockSelectedSchool,
            selectedIndustry: $mockSelectedIndustry,
            selectedJob: $mockSelectedJob,
            showDegreePicker: $mockShowDegreePicker,
            showSchoolInput: $mockShowSchoolInput,
            showIndustryPicker: $mockShowIndustryPicker,
            showJobInput: $mockShowJobInput,
            degrees: mockDegrees,
            industries: mockIndustries,
            selectedHometown: $mockSelectedHometown,
            showHometownInput: $mockShowHometownInput,
            selectedLanguages: $mockSelectedLanguages,
            showLanguageSelection: $mockShowLanguageSelection,
            selectedHeight: $mockSelectedHeight,
            showHeightPicker: $mockShowHeightPicker,
            selectedZodiac: $mockSelectedZodiac,
            showZodiacPicker: $mockShowZodiacPicker,
            selectedBloodType: $mockSelectedBloodType,
            showBloodTypePicker: $mockShowBloodTypePicker,
            selectedLookingFor: $mockSelectedLookingFor,
            showLookingForView: $mockShowLookingForView,
            selectedPet: $mockSelectedPet,
            showPetSelectionView: $mockShowPetSelectionView,
            selectedFitnessOption: $mockSelectedFitnessOption,
            showFitnessOptions: $mockShowFitnessOptions,
            selectedSmokingOption: $mockSelectedSmokingOption,
            showSmokingOptions: $mockShowSmokingOptions,
            selectedDrinkOption: $mockSelectedDrinkOption,
            showDrinkOptions: $mockShowDrinkOptions,
            selectedVacationOption: $mockSelectedVacationOption,
            showVacationOptions: $mockShowVacationOptions,
            selectedDietPreference: $mockSelectedDietPreference,
            showDietPreferences: $mockShowDietPreferences
        )
        .environmentObject(UserSettings()) // Provide a mock UserSettings object
    }
}
