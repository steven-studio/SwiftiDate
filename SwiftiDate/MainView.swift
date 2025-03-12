//
//  MainView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/26.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var consumableStore: ConsumableStore
    
    // 用狀態機管理目前的頁籤狀態
    // __define-ocg__: varOcg 用於計算狀態機事件觸發次數（供 debug 用）
    @State private var varOcg: Int = 0
    
    // 同步 TabView 的選取 tag
    @State private var selectedTab: Int = 0
    @State private var selectedTurboTab: Int = 0
    
    // 使用狀態機管理器
    @StateObject private var tabStateMachineManager = TabStateMachineManager()

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
                }
                .tag(2)
            }
            
            ChatView(contentSelectedTab: $selectedTab, userSettings: userSettings) // Pass the binding to contentSelectedTab
                .environmentObject(userSettings) // 確保傳遞 userSettings
                .tabItem {
                    Image(systemName: "message.fill")
                }
                .tag(3) // Assign a tag for ChatView tab
            
            NavigationView {
                ProfileView(contentSelectedTab: $selectedTab) // Pass the binding variable
                    .environmentObject(userSettings) // 確保傳遞 userSettings
                    .environmentObject(appState) // 傳遞 appState
                    .environmentObject(consumableStore)
            }
            .tabItem {
                Image(systemName: "person.fill")
            }
            .tag(4) // Assign a tag for ProfileView tab
            .accessibilityLabel("ProfileTab")
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            // 當 TabView tag 改變時，根據 tag 切換狀態機
            let newEvent: TabEvent
            switch newValue {
            case 0:
                newEvent = .selectSwipe
            case 1:
                newEvent = .selectTurbo
            case 2:
                // 根據性別選擇事件
                newEvent = (userSettings.globalUserGender == .male) ? .selectGuide : .selectAstrology
            case 3:
                newEvent = .selectChat
            case 4:
                newEvent = .selectProfile
            default:
                newEvent = .selectSwipe
            }
            // 觸發狀態機事件
            triggerTabEvent(newEvent)
            AnalyticsManager.shared.trackEvent("tab_switched", parameters: [
                "new_tab_index": newValue
            ])
        }
    }
    
    // 狀態機事件觸發函式
    func triggerTabEvent(_ event: TabEvent) {
        varOcg += 1
        print("[DEBUG] Triggering event: \(event) - varOcg=\(varOcg)")
        do {
            try tabStateMachineManager.stateMachine.transition(event)
            print("[DEBUG] New state: \(tabStateMachineManager.stateMachine.state)")
        } catch {
            print("[ERROR] Transition failed for event \(event): \(error)")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(UserSettings())
            .environmentObject(AppState())
            .environmentObject(ConsumableStore())
    }
}
