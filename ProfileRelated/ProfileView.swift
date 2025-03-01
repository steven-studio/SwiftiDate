//
//  ProfileView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/8/18.
//

import Foundation
import SwiftUI
import FirebaseStorage

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userSettings: UserSettings // 使用 EnvironmentObject 存取 UserSettings
    
    @State private var userRankPercentage: Double = 25.4
    @State private var isShowingInfoPopup = false // State to show/hide the popup
    @State private var isShowingTurboView = false
    @State private var selectedTab: Int = 0 // State to control which tab is selected in TurboView
    @Binding var contentSelectedTab: Int // Use a binding variable for selectedTab from ContentView
    @State private var profileSelectedTab: Int = 0 // State to control which tab is selected in ProfileView
    @State private var isShowingTurboPurchaseView = false // State variable to control the sheet presentation
    @State private var isShowingCrushPurchaseView = false // State variable to control Crush sheet presentation
    @State private var isShowingPraisePurchaseView = false // State variable to control Praise sheet presentation
    @State private var isShowingEditProfileView = false // State to show EditProfileView
    @State private var showSettingsView = false // State variable to control Settings View presentation
    @State private var showSafetyCenterView = false // 控制 SafetyCenterView 的顯示
    @State private var showHealthDataSectionView = false
    
    // Local debug variable for Supreme status
    @State private var isSupreme = false // Modify this to test different scenarios

    var body: some View {
        if showSettingsView {
            SettingsView(
                showSettingsView: $showSettingsView,
                contentSelectedTab: $contentSelectedTab // 新增這個參數
            )
            .environmentObject(appState)
            .environmentObject(userSettings) // 如果需要也可以帶
            .onAppear {
                AnalyticsManager.shared.trackEvent("profile_view_settings_appear")
            }
        } else if showSafetyCenterView {
            SafetyCenterView(showSafetyCenterView: $showSafetyCenterView, photos: $userSettings.photos) // 如果全局变量为 true，则显示 SafetyCenterView
                .environmentObject(userSettings)
                .onAppear {
                    AnalyticsManager.shared.trackEvent("profile_view_safety_center_appear")
                }
        } else {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        // 头像及基本信息
                        ProfileHeaderView(
                            isShowingEditProfileView: $isShowingEditProfileView,
                            photos: $userSettings.photos // 傳遞綁定的照片屬性
                        )
                        
                        // 统计信息
                        StatisticsSectionView(selectedTab: $selectedTab, isShowingTurboView: $isShowingTurboView)
                            .environmentObject(userSettings) // 傳遞 EnvironmentObject
                            .fullScreenCover(isPresented: $isShowingTurboView) {
                                TurboView(contentSelectedTab: $contentSelectedTab, turboSelectedTab: $selectedTab, showBackButton: true, onBack: {
                                    isShowingTurboView = false // 當返回按鈕被按下時，關閉 fullScreenCover
                                })
                            }
                        
                        if userSettings.isProfilePhotoVerified {
                            // 成就进度条
                            VerifiedProfileProgressView(userRankPercentage: userRankPercentage, isShowingInfoPopup: $isShowingInfoPopup)
                        } else {
                            UnverifiedProfilePlaceholderView(photos: userSettings.photos) // 使用 userSettings.photos
                        }
                        
                        // Turbo, Crush, 讚美
                        AchievementSectionView(
                            isShowingTurboPurchaseView: $isShowingTurboPurchaseView,
                            isShowingCrushPurchaseView: $isShowingCrushPurchaseView,
                            isShowingPraisePurchaseView: $isShowingPraisePurchaseView
                        )
                        .environmentObject(userSettings)
                        
                        // Display Supreme banner if the user has purchased Supreme
                        if userSettings.isSupremeUser {
                            SupremeBannerView()
                        } else {
                            PremiumCardTabView(selectedTab: $profileSelectedTab)
                        }
                        
                        ServiceSectionContainer(isSupreme: .constant(userSettings.isSupremeUser))
                    }
                    .environmentObject(userSettings)
                }
                
                // 使用新的 TopRightActionButtons 组件
                TopRightActionButtons(showSettingsView: $showSettingsView, showSafetyCenterView: $showSafetyCenterView)
                
                // Show dimmed background and popup when isShowingInfoPopup is true
                if isShowingInfoPopup {
                    Color.black.opacity(0.4) // Dimmed background
                        .edgesIgnoringSafeArea(.all) // Make it cover the entire screen
                    InfoPopupView(isShowing: $isShowingInfoPopup, userRankPercentage: userRankPercentage)
                }
            }
            .onAppear {
                AnalyticsManager.shared.trackEvent("profile_view_appear", parameters: [
                    "user_name": userSettings.globalUserName,
                    "is_verified": userSettings.globalIsUserVerified,
                    "is_supreme": userSettings.isSupremeUser
                ])
            }
        }
    }
}

struct AchievementCardView: View {
    var title: String
    var count: Int
    var color: Color
    var action: (() -> Void)? // Optional action closure
    
    var body: some View {
        VStack {
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
            Text("\(count)")
                .font(.title)
                .fontWeight(.bold)
            Button(action: {
                action?() // Execute the action if provided
            }) {
                Text("獲取更多")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(5)
                    .background(Color.white)
                    .cornerRadius(5)
            }
        }
        .frame(width: 100, height: 100)
        .background(color.opacity(0.2))
        .cornerRadius(10)
    }
}

struct ProfileView_Previews: PreviewProvider {
    @State static var mockSelectedTab = 4 // Create a mock State for the binding
    
    static var previews: some View {
        NavigationView {
            ProfileView(contentSelectedTab: $mockSelectedTab) // Pass the binding for preview
                .environmentObject(UserSettings()) // Add a mock EnvironmentObject for UserSettings
                .environmentObject(AppState()) // 加入 AppState
        }
    }
}
