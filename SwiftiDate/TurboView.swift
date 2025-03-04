//
//  TurboView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import Foundation
import SwiftUI

struct TurboView: View {
    @EnvironmentObject var userSettings: UserSettings
    
    // Binding to control the ContentView's selectedTab
    @Binding var contentSelectedTab: Int
    
    // State to manage TurboView's own tabs
    @Binding var turboSelectedTab: Int

    var showBackButton: Bool = false
    @State private var showConfirmationPopup = false

    var onBack: (() -> Void)? // Closure for back action

    var body: some View {
        ZStack {
            VStack {
                ZStack(alignment: .topLeading) {
                    // Custom Navigation Bar with chevron.left button
                    HStack {
                        if showBackButton {
                            Button(action: {
                                AnalyticsManager.shared.trackEvent("turbo_view_back_pressed")
                                onBack?() // 執行返回操作
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.gray)
                            }
                            .padding(.leading, 16) // 增加一點左邊的間距
                        }

                        Spacer() // 把BackButton推到左邊
                    }
                    
                    // Top Tab Selection
                    HStack {
                        Button(action: {
                            turboSelectedTab = 0
                            AnalyticsManager.shared.trackEvent("turbo_tab_changed", parameters: ["tab": "喜歡我的人"])
                        }) {
                            Text("喜歡我的人")
                                .font(.headline)
                                .foregroundColor(turboSelectedTab == 0 ? .green : .gray)
                                .frame(maxWidth: .infinity) // 讓按鈕自適應空間
                        }
                                            
                        Button(action: {
                            turboSelectedTab = 1
                            AnalyticsManager.shared.trackEvent("turbo_tab_changed", parameters: ["tab": "我的心動對象"])
                        }) {
                            Text("我的心動對象")
                                .font(.headline)
                                .foregroundColor(turboSelectedTab == 1 ? .green : .gray)
                                .frame(maxWidth: .infinity) // 讓按鈕自適應空間
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                }

                // The selected line
                HStack(spacing: 0) {
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width / 2, height: 2) // Set the width to half the screen size
                        .foregroundColor(.green)
                        .alignmentGuide(.leading) { d in
                            turboSelectedTab == 0 ? 0 : -UIScreen.main.bounds.width / 2
                        }
                }
                .frame(width: UIScreen.main.bounds.width, alignment: turboSelectedTab == 0 ? .leading : .trailing)

                Spacer().frame(height: 20)
                
                if turboSelectedTab == 0 {
                    // The featured card section (每日精選)
                    FeaturedCardView()

                    Spacer().frame(height: 20)
                    
                    // Main image
                    Image("turbo_view_image") // Replace with your image asset name
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                    
                    // Description text
                    Text("開啟Turbo，將你直接置頂到所有人的前面！輕鬆提升10倍配對成功率")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    
                    // Action button
                    Button(action: {
                        if userSettings.globalTurboCount > 0 {
                            AnalyticsManager.shared.trackEvent("turbo_start_button_pressed", parameters: ["globalTurboCount": userSettings.globalTurboCount])
                            showConfirmationPopup = true
                        }
                    }) {
                        HStack {
                            Image(systemName: "bolt.fill")
                            
                            Text("馬上開始")
                                .fontWeight(.bold)
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [.pink, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 60)
                    }
                    .padding(.vertical, 20)

                    Spacer()
                    
                    Button(action: {
                        if userSettings.globalTurboCount > 0 {
                            AnalyticsManager.shared.trackEvent("turbo_icon_button_pressed", parameters: ["globalTurboCount": userSettings.globalTurboCount])
                            showConfirmationPopup = true
                        }
                    }) {
                        Image(systemName: "bolt.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [.pink, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                } else {
                    if userSettings.globalLikeCount == 0 { // Access globalLikeCount from UserSettings
                        VStack {
                            Spacer()
                            Image(systemName: "cube.box")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                            Text("你還沒有送出喜歡，快去滑動吧")
                                .foregroundColor(.gray)
                                .padding(.top, 16)
                            
                            Button(action: {
                                AnalyticsManager.shared.trackEvent("turbo_go_to_swipe_pressed")
                                onBack?() // Dismiss TurboView
                                contentSelectedTab = 0 // Navigate to the SwipeCardView
                            }) {
                                Text("去滑卡")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.green)
                                    .cornerRadius(10)
                                    .padding(.horizontal, 60)
                            }
                            Spacer()
                        }
                    } else {
                        Spacer()
                    }
                }
            }
            
            // Confirmation popup overlay using ZStack
            if showConfirmationPopup {
                Color.black.opacity(0.8) // Background with high opacity
                    .edgesIgnoringSafeArea(.all) // Cover the entire screen
                
                VStack(spacing: 20) {
                    // Profile image
                    Image("photo1") // Replace with your actual image
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 4)
                        )
                    
                    Text("確認要立即使用Turbo嗎？")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Button(action: {
                        // 埋點：用戶確認使用Turbo
                        AnalyticsManager.shared.trackEvent("turbo_confirmation_accepted", parameters: ["globalTurboCount": userSettings.globalTurboCount])
                        showConfirmationPopup = false
                    }) {
                        Text("確認使用")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(gradient: Gradient(colors: [.pink, .purple]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(25)
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        // 埋點：用戶取消Turbo確認
                        AnalyticsManager.shared.trackEvent("turbo_confirmation_cancelled")
                        showConfirmationPopup = false
                    }) {
                        Text("取消")
                            .font(.title2)
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .padding(.horizontal, 40)
            }
        }
    }
}

// MARK: - TurboView Preview
struct TurboView_Previews: PreviewProvider {
    @State static var contentSelectedTab = 1 // For ContentView's TabView
    @State static var turboSelectedTab = 1 // For TurboView's internal tabs

    static var previews: some View {
        TurboView(contentSelectedTab: $contentSelectedTab, turboSelectedTab: $turboSelectedTab, showBackButton: false)
            .previewDevice("iPhone 15 Pro")
            .environmentObject(UserSettings())
    }
}
