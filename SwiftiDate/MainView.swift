//
//  MainView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/26.
//

import Foundation
import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userSettings: UserSettings

    @State private var selectedTab: Int = 0 // Add this to track the selected tab
    @State private var selectedTurboTab: Int = 0 // Add this to track the selected tab for TurboView
    
    var body: some View {
        TabView(selection: $selectedTab) { // Bind TabView selection to selectedTab
            SwipeCardView()
                .tabItem {
                    Image(systemName: "heart.fill")
                }
                .tag(0) // Assign a tag for SwipeCardView tab
            
            // Pass the selectedTab to TurboView
            TurboView(contentSelectedTab: $selectedTab, turboSelectedTab: $selectedTurboTab, showBackButton: false) // Match the parameter name here
                .tabItem {
                    Image(systemName: "star.fill")
                }
                .tag(1) // Assign a tag for TurboView tab

            // Only show UserGuideView if the user is male
            if userSettings.globalUserGender == .male { // Use globalUserGender for the gender check
                NavigationView {
                    UserGuideView()
                }
                .tabItem {
                    Image(systemName: "questionmark.circle.fill")
                }
                .tag(2) // Assign a tag for UserGuideView tab
            } else {
                NavigationView {
                    AstrologyView() // ✅ 針對女性用戶顯示命理學相關內容
                }
                .tabItem {
                    Image(systemName: "moon.stars.fill") // 使用更符合命理學的 SF Symbol
                    Text("星座占卜")
                }
                .tag(2)
            }
            
            ChatView(contentSelectedTab: $selectedTab) // Pass the binding to contentSelectedTab
                .environmentObject(userSettings) // 確保傳遞 userSettings
                .tabItem {
                    Image(systemName: "message.fill")
                }
                .tag(3) // Assign a tag for ChatView tab
            
            NavigationView {
                ProfileView(contentSelectedTab: $selectedTab) // Pass the binding variable
                    .environmentObject(userSettings) // 確保傳遞 userSettings
                    .environmentObject(appState) // 傳遞 appState
            }
            .tabItem {
                Image(systemName: "person.fill")
            }
            .tag(4) // Assign a tag for ProfileView tab
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(UserSettings())
            .environmentObject(AppState()) // 加入 AppState
    }
}
