//
//  SafetyCenterView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/10.
//

import Foundation
import SwiftUI

struct SafetyCenterView: View {
    @Binding var showSafetyCenterView: Bool // 透過 Binding 傳入是否顯示 SafetyCenterView 的狀態
    @Binding var photos: [String] // 新增 photos 的 Binding
    @State private var showSafetyTestView = false
    @State private var showSafetyTipsView = false // 新增控制安全提示顯示的 state
    @State private var showRealNameVerificationView = false // 控制是否顯示真人認證的畫面
    @State private var showReportConditionsView = false // 新增控制檢舉頁面的狀態
    @State private var showHowToReportView = false // 新增控制如何檢舉頁面的狀態
    @State private var showReportAftermathView = false // 新增控制檢舉後發生什麼頁面的狀態
    @State private var showMeetingGuideView = false // New state variable for "相約見面"

    @EnvironmentObject var userSettings: UserSettings // 使用 @EnvironmentObject 從外部傳入的 UserSettings
    
    var body: some View {
        if showSafetyTestView {
            SafetyTestView(showSafetyTestView: $showSafetyTestView)
        } else if showSafetyTipsView { // 當點擊安全提示後，顯示安全提示畫面
            SafetyTipsView(showSafetyTipsView: $showSafetyTipsView) // 使用新視圖來顯示安全提示內容
        } else if showRealNameVerificationView {
            RealNameVerificationView(showRealNameVerificationView: $showRealNameVerificationView)
        } else if showReportConditionsView { // 當點擊檢舉提示時顯示的畫面
            ReportConditionsView(showReportConditionsView: $showReportConditionsView)
        } else if showHowToReportView { // 當點擊 "如何檢舉" 時，顯示這個畫面
            HowToReportView(showHowToReportView: $showHowToReportView) // 使用新的 HowToReportView
        } else if showReportAftermathView { // 當點擊檢舉後會發生什麼？時顯示的畫面
            ReportAftermathView(showReportAftermathView: $showReportAftermathView)
        } else if showMeetingGuideView { // New conditional block for "相約見面"
            MeetingGuideView(showMeetingGuideView: $showMeetingGuideView) // New view for "相約見面"
        } else {
            mainContentView
                .onAppear {
                    AnalyticsManager.shared.trackEvent("safety_center_view_appear")
                }
        }
    }
    
    var mainContentView: some View {
        ScrollView {
            VStack(alignment: .leading) { // Change alignment to leading
                // 將返回按鈕和標題放在同一個 HStack 中
                ZStack {
                    // 中間的標題
                    HStack {
                        Spacer() // Push title to the center
                        
                        Text("安全中心")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Spacer() // Keep title centered by adding another spacer
                    }
                    .padding() // Overall padding for the HStack
                    
                    // 左上角的返回按鈕
                    HStack {
                        Button(action: {
                            AnalyticsManager.shared.trackEvent("safety_center_back_pressed")
                            showSafetyCenterView = false
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.gray) // 設置按鈕顏色
                        }
                        .padding(.leading) // 添加內邊距以確保按鈕不會緊貼邊緣
                        
                        Spacer() // This will push the button to the left
                    }
                }

                Spacer()
                
                // Align the text and image to the left using HStack
                HStack {
                    VStack(alignment: .leading) {
                        Text("你好呀~ \(userSettings.globalUserName)") // 使用 userSettings 的 globalUserName
                            .font(.title)
                            .fontWeight(.bold)

                        Text("讓 SwiftiDate 來守護你的安全！")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.leading) // Padding for the text

                    Spacer()

                    if let photoName = userSettings.photos.first, let image = PhotoUtility.loadImageFromLocalStorage(named: photoName) {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 100, height: 133)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .padding(.trailing)
                    } else {
                        // Default placeholder image
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 133)
                            .foregroundColor(.gray)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .padding(.trailing)
                    }
                }
                .padding(.bottom, 20)
                
                SafetyOptionView(
                    icon: "lightbulb.fill",
                    title: "安全意識小測驗",
                    subtitle: "測測看你的交友安全意識",
                    backgroundColor: Color(red: 240/255, green: 250/255, blue: 255/255),
                    iconColor: .blue
                ) {
                    AnalyticsManager.shared.trackEvent("safety_test_option_tapped")
                    showSafetyTestView = true
                }
                .padding(.bottom, 10)
                
                SafetyOptionView(
                    icon: "bell.fill",
                    title: "安全須知",
                    subtitle: "溫馨提醒",
                    backgroundColor: Color(red: 255/255, green: 240/255, blue: 240/255),
                    iconColor: .pink,
                    action: {
                        AnalyticsManager.shared.trackEvent("safety_tips_option_tapped")
                        showSafetyTipsView = true // 點擊後顯示安全提示視圖
                    }
                )
                .padding(.bottom, 10)
                
//                    NavigationLink(destination: Text("反詐騙中心")) {
//                        VStack(alignment: .leading, content: {
//                            Text("反詐騙中心")
//                                .font(.headline)
//                                .foregroundColor(.black) // Title text color
//                                .padding(.leading) // Add leading padding to align with the rest of the content
//
//                            HStack {
//                                // Image for the icon on the left
//                                Image(systemName: "shield.fill")
//                                    .resizable()
//                                    .frame(width: 50, height: 50) // Adjust the size of the icon
//                                    .foregroundColor(.green) // Change color of the icon
//
//                                Text("提升反詐騙意識")
//                                    .font(.subheadline)
//                                    .foregroundColor(.gray) // Subtitle text color
//
//                                Spacer() // Pushes everything to the left
//
//                                Image(systemName: "chevron.right")
//                                    .foregroundColor(.green) // Arrow color
//                                    .padding(.trailing, 10)
//                            }
//                            .padding(25) // Padding around the HStack content
//                            .background(Color(red: 240/255, green: 255/255, blue: 240/255)) // Light green background color
//                            .cornerRadius(15) // Rounded corners
//                            .shadow(radius: 1) // Add a slight shadow for depth
//                            .padding(.horizontal, 16) // Add padding from the left and right screen edges
//                        })
//                        .padding(.bottom, 10) // Add bottom padding to the entire VStack
//                    }
                
                SafetyOptionView(
                    icon: "checkmark.seal.fill",
                    title: "安全及認證",
                    subtitle: "真人認證",
                    backgroundColor: Color(red: 240/255, green: 250/255, blue: 255/255),
                    iconColor: .blue,
                    action: {
                        AnalyticsManager.shared.trackEvent("real_name_verification_option_tapped")
                        showRealNameVerificationView = true // 點擊後顯示真人認證畫面
                    }
                )
                .padding(.bottom, 10)
                
                VStack {
                    // 檢舉
                    Section(header: Text("檢舉")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading) // Set alignment to leading
                                .padding(.leading, 16)) {
                        HStack {
                            Text("什麼情況下應該檢舉")
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .padding(.trailing, 10)
                        }
                        .padding(35)
                        .background(Color(red: 255/255, green: 255/255, blue: 200/255)) // Light yellow background color
                        .cornerRadius(15)
                        .shadow(radius: 1)
                        .padding(.horizontal, 16)
                        .onTapGesture {
                            AnalyticsManager.shared.trackEvent("report_conditions_tapped")
                            showReportConditionsView = true // 點擊後顯示檢舉提示頁面
                        }

                        HStack {
                            Text("如何檢舉")
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .padding(.trailing, 10)
                        }
                        .padding(35)
                        .background(Color(red: 255/255, green: 255/255, blue: 200/255)) // Light yellow background color
                        .cornerRadius(15)
                        .shadow(radius: 1)
                        .padding(.horizontal, 16)
                        .onTapGesture {
                            AnalyticsManager.shared.trackEvent("how_to_report_tapped")
                            showHowToReportView = true // 點擊後顯示如何檢舉頁面
                        }
                                    
                        HStack {
                            Text("檢舉後會發生什麼？")
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .padding(.trailing, 10)
                        }
                        .padding(35)
                        .background(Color(red: 255/255, green: 255/255, blue: 200/255)) // Light yellow background color
                        .cornerRadius(15)
                        .shadow(radius: 1)
                        .padding(.horizontal, 16)
                        .onTapGesture {
                            AnalyticsManager.shared.trackEvent("report_aftermath_tapped")
                            showReportAftermathView = true // 點擊後顯示如何檢舉頁面
                        }
                    }
                    .padding(.bottom, 10) // Section bottom padding
                }
                .padding(.bottom, 20) // This padding will work for the whole VStack

                Spacer()
                
                // "相約見面" Section
                SafetyOptionView(
                    icon: "person.2.fill",
                    title: "相約見面",
                    subtitle: "相約見面",
                    backgroundColor: Color(red: 255/255, green: 240/255, blue: 240/255),
                    iconColor: .cyan,
                    action: {
                        AnalyticsManager.shared.trackEvent("meeting_guide_tapped")
                        showMeetingGuideView = true // Navigate to "相約見面" view
                    }
                )
                .padding(.bottom, 10)
            }
        }
    }
}

struct SafetyOptionView: View {
    var icon: String
    var title: String
    var subtitle: String
    var backgroundColor: Color
    var iconColor: Color
    var action: () -> Void

    var body: some View {
        Text(title).font(.headline).foregroundColor(.black).padding(.leading)
        
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(iconColor)
                
                Text(subtitle).font(.subheadline).foregroundColor(.gray)

                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .padding(.trailing, 10)
            }
            .padding(25)
            .background(backgroundColor)
            .cornerRadius(15)
            .shadow(radius: 1)
            .padding(.horizontal, 16)
        }
    }
}

struct SafetyCenterView_Previews: PreviewProvider {
    @State static var mockPhotos = ["photo1", "photo2"] // 假設的照片名稱陣列
    
    static var previews: some View {
        NavigationView {
            SafetyCenterView(showSafetyCenterView: .constant(true), photos: $mockPhotos) // 傳入 photos 的綁定變數
                .environmentObject(UserSettings()) // 加入 UserSettings 的環境物件
        }
    }
}
