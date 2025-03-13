//
//  PersonalityView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/30.
//

import Foundation
import UIKit
import SwiftUI

// 定義一個資料模型來包含每個 MBTI 的數據
struct Personality {
    var name: String
    var traits: [String]
    var description: String
    var characterImageName: String
}

// 主視圖
struct PersonalityView: View {
    var personality: Personality
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color.pink.opacity(0.3), Color.purple.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                // Top-right close button
                HStack {
                    Spacer()
                    Button(action: {
                        // 埋點：使用者點擊關閉按鈕
                        AnalyticsManager.shared.trackEvent("personality_view_close_pressed", parameters: [
                            "personality": personality.name
                        ])
                        // 此處添加關閉動作，例如 dismiss 或呼叫回傳閉包
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                
                // Character image
                Image(personality.characterImageName) // Use the image name from the personality data
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding(.top, -20)
                
                // Title and Subtitle
                VStack(spacing: 5) {
                    Text("她在感情中是：")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text(personality.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    // Trait tags
                    HStack(spacing: 10) {
                        ForEach(personality.traits, id: \.self) { trait in
                            TagView(text: trait, color: .blue)
                        }
                    }
                    
                    Text("如何與她相處")
                        .font(.headline)
                        .foregroundColor(.purple)
                        .padding(.top)
                }
                
                // Description Text
                Text(personality.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .foregroundColor(.gray)
                
                Spacer()
                
                // Button
                Button(action: {
                    // 埋點：點擊「測測看」按鈕
                    AnalyticsManager.shared.trackEvent("personality_test_button_pressed", parameters: [
                        "personality": personality.name
                    ])
                    // 執行測試行動，例如導向下一頁
                }) {
                    Text("測測看")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(25)
                }
                .padding(.bottom, 30)
            }
            .padding()
        }
        .onAppear {
            // 埋點：頁面曝光
            AnalyticsManager.shared.trackEvent("personality_view_appear", parameters: [
                "personality": personality.name
            ])
        }
    }
}

// Custom tag view for displaying colored tags
struct TagView: View {
    var text: String
    var color: Color

    var body: some View {
        Text(text)
            .font(.caption)
            .padding(8)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(10)
    }
}

// 預覽
struct PersonalityView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePersonality = Personality(
            name: "全能賢者 (INTP)",
            traits: ["邏輯", "敏銳", "慢熱", "理性", "規劃"],
            description: "“全能賢者 (INTP)”來說，能認可自己的邏輯是另一半的必要條件...",
            characterImageName: "characterImage" // Replace with your actual image name
        )
        
        PersonalityView(personality: samplePersonality)
            .previewDevice("iPhone 15")
    }
}
