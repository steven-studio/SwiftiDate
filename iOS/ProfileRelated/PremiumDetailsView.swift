//
//  PremiumDetailsView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/18.
//

import Foundation
import SwiftUI

enum PremiumType: Identifiable {
    case premium
    case supreme
    
    var id: String {
        switch self {
        case .premium:
            return "premium"
        case .supreme:
            return "supreme"
        }
    }
    
    func toSubscriptionType() -> SubscriptionType {
        switch self {
        case .premium:
            return .premium
        case .supreme:
            return .supreme
        }
    }
}

struct FeatureView: View {
    var iconName: String
    var text: String
    var color: Color
    var description: String? = nil // Make description optional
    var subscriptionType: SubscriptionType // Add subscription type to determine the text color

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(color)
            VStack(alignment: .leading) {
                Text(text)
                    .font(.headline)
                    .foregroundColor(textColor()) // Use the textColor function to set the color
                if let description = description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
    }
    
    // Helper function to determine text color based on subscription type
    private func textColor() -> Color {
        switch subscriptionType {
        case .premium:
            return .black
        case .supreme:
            return .gold
        }
    }
}

struct PremiumDetailsView: View {
    @Binding var selectedTab: PremiumType // Use Binding to pass the state from parent
    @Environment(\.presentationMode) var presentationMode // Environment variable to dismiss the view
    
    var body: some View {
        VStack(spacing: 20) {
            topBar
            tabSelector

            // Display content based on selected tab
            if selectedTab == .premium {
                PremiumContent()
            } else if selectedTab == .supreme {
                SupremeContent()
            }
            
            Spacer()
            
            // Continue button
            continueButton
                .padding(.horizontal)
                .padding(.bottom, 20)
        }
        .padding()
        .background(selectedTab == .premium ? Color.yellow.opacity(0.1) : Color.black)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            AnalyticsManager.shared.trackEvent("premium_details_view_appear", parameters: [
                "selected_tab": selectedTab.id
            ])
        }
    }
    
    // Top Bar with Close Button
    private var topBar: some View {
        // Close button at the top left
        HStack {
            Button(action: {
                AnalyticsManager.shared.trackEvent("premium_details_close_pressed")
                presentationMode.wrappedValue.dismiss() // Dismiss the view when tapped
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.black)
                    .padding()
            }
            Spacer() // Push the close button to the left
        }
    }
    
    // Custom Tab Selector for Premium and Supreme
    private var tabSelector: some View {
        // Custom Tab Selector
        HStack {
            // Premium Tab Button
            TabButton(
                title: "Premium",
                isSelected: selectedTab == .premium,
                color: .yellow,
                unselectedColor: .platinum,
                action: {
                    selectedTab = .premium
                    AnalyticsManager.shared.trackEvent("premium_details_tab_changed", parameters: ["tab": "premium"])
                }
            )
            
            // Divider between the buttons
            Rectangle()
                .frame(width: 1, height: 30)
                .foregroundColor(.gold)
                .padding(.horizontal)
            
            // Supreme Tab Button
            TabButton(
                title: "Supreme",
                isSelected: selectedTab == .supreme,
                color: .gold,
                unselectedColor: .black,
                action: {
                    selectedTab = .supreme
                    AnalyticsManager.shared.trackEvent("premium_details_tab_changed", parameters: ["tab": "supreme"])
                }
            )
        }
    }
    
    // Continue button view
    private var continueButton: some View {
        Button(action: {
            AnalyticsManager.shared.trackEvent("premium_details_continue_pressed", parameters: ["selected_tab": selectedTab.id])
            print("繼續 button tapped")
            // 在這裡處理繼續按鈕的動作
        }) {
            Text("繼續")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(selectedTab == .premium ? Color.yellow : Color.gold)
                .cornerRadius(10)
        }
    }
}

// Separate view for Premium content
struct PremiumContent: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "crown.fill")
                .resizable()
                .frame(width: 40, height: 40) // Adjust the width and height to match the size of the large title
                .foregroundColor(.yellow) // Set the color to gold
            Text("開通 SwiftiDate Premium 看看誰喜歡你，與對方立即配對聊天！")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
            
            SubscriptionScrollView(subscriptionType: .premium) // For Premium subscription
                .padding()
            
            featureListView(for: .premium)
        }
    }
}

// Separate view for Supreme content
struct SupremeContent: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "crown.fill")
                .resizable()
                .frame(width: 40, height: 40) // Adjust the width and height to match the size of the large title
                .foregroundColor(.gold) // Set the color to gold
            Text("開通 SwiftiDate Supreme 看看誰喜歡你，與對方立即配對聊天！")
                .font(.headline)
                .foregroundColor(.gold) // Use the custom gold color
                .multilineTextAlignment(.center)
                .padding()
            
            SubscriptionScrollView(subscriptionType: .supreme) // For Supreme subscription
                .padding()
            
            featureListView(for: .supreme)
        }
    }
}

// Helper function to generate the feature list view
@ViewBuilder
private func featureListView(for type: PremiumType) -> some View {
    ScrollView {
        VStack(alignment: .leading, spacing: 10) {
            Text(type == .premium ? "SwiftiDate Premium 專屬特權" : "SwiftiDate Supreme 專屬特權")
                .font(.headline)
                .foregroundColor(type == .premium ? .black : .gold)
                .padding(.bottom, 10)
            
            // List of features based on type
            ForEach(features(for: type)) { feature in
                FeatureView(
                    iconName: feature.iconName,
                    text: feature.text,
                    color: feature.color,
                    description: feature.description,
                    subscriptionType: type.toSubscriptionType() // Convert PremiumType to SubscriptionType
                )
            }
        }
        .padding()
    }
    .frame(maxHeight: 250)
    .background(
        RoundedRectangle(cornerRadius: 10)
            .stroke(
                type == .premium ? Color.gray.opacity(0.5) : Color.gold.opacity(0.5),
                lineWidth: type == .premium ? 1 : 2 // Set lineWidth based on type
            )
    )
}

// Reusable Tab Button Component
struct TabButton: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let unselectedColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .italic()
                .foregroundColor(isSelected ? color : unselectedColor)
                .underline(isSelected, color: color)
                .padding(.horizontal)
        }
    }
}

// Model for feature
struct Feature: Identifiable {
    let id = UUID()
    let iconName: String
    let text: String
    let color: Color
    let description: String?
}

// Function to return the list of features for a given type
private func features(for type: PremiumType) -> [Feature] {
    if type == .premium {
        return [
            Feature(iconName: "flame.fill", text: "無限右滑", color: .orange, description: nil),
            Feature(iconName: "heart.fill", text: "看看誰喜歡你", color: .pink, description: nil),
            Feature(iconName: "arrow.uturn.left", text: "無限反悔", color: .orange, description: nil),
            Feature(iconName: "bolt.fill", text: "每月1次免費Turbo", color: .purple, description: nil),
            Feature(iconName: "gift.fill", text: "每天 5 個免費Crush", color: .green, description: nil),
            Feature(iconName: "envelope.open.fill", text: "已讀回執", color: .blue, description: nil),
            Feature(iconName: "repeat.circle.fill", text: "配對恢復", color: .cyan, description: "重新與你取消配對的人再次配對"),
            Feature(iconName: "list.bullet", text: "開啟心動列表", color: .orange, description: "查看你右滑過的人，等不到回應時可以馬上送出Crush"),
            Feature(iconName: "star.fill", text: "尊貴專屬標識", color: .yellow, description: "幫你提升2.5倍的配對成功率，還可以低調隱藏。"),
            Feature(iconName: "smiley.fill", text: "不限次數的「緣分合盤」解讀", color: .purple, description: "看看你們的緣分到底有多深"),
            // Add more features if needed
        ]
    } else {
        return [
            Feature(iconName: "location.fill", text: "解鎖附近的人", color: .gold, description: nil),
            Feature(iconName: "star.circle.fill", text: "無限次使用高級篩選", color: .gold, description: "一次篩選出最符合你興趣偏好的人，馬上開始聊天！"),
            Feature(iconName: "message.fill", text: "每日 3 次讚美機會", color: .gold, description: "遇到心儀的對象，可以直接按讚美對方，無需配對"),
            Feature(iconName: "heart.circle.fill", text: "每日精選", color: .gold, description: "給優質用戶發送按讚，快速配對"),
            Feature(iconName: "eye.slash.fill", text: "隱身模式", color: .gold, description: nil),
            Feature(iconName: "headphones.circle.fill", text: "24小時專屬客服", color: .gold, description: nil),
            Feature(iconName: "heart.fill", text: "看看誰喜歡你", color: .gold, description: nil),
            Feature(iconName: "flame.fill", text: "無限右滑", color: .gold, description: nil),
            Feature(iconName: "bolt.fill", text: "每天 5 個免費 Crush", color: .gold, description: nil),
            Feature(iconName: "envelope.open.fill", text: "已讀回執", color: .gold, description: nil),
            Feature(iconName: "arrow.2.squarepath", text: "配對恢復", color: .gold, description: "重新與你取消配對的人再一次配對"),
            Feature(iconName: "text.badge.plus", text: "開啟心動列表", color: .gold, description: "查看你右滑過的人，等不到回應時可以馬上送出 Crush"),
            Feature(iconName: "crown.fill", text: "尊貴專屬標識", color: .gold, description: "幫你提升 2.5 倍的配對成功率，還可以低調隱藏"),
            Feature(iconName: "eye.fill", text: "不限次數的「緣分合盤」解讀", color: .gold, description: "看看你們的緣分到底有多深")
        ]
    }
}

// MARK: - Preview
struct PremiumDetailsView_Previews: PreviewProvider {
    @State static var selectedTab: PremiumType = .premium

    static var previews: some View {
        Group {
            // Preview for Premium
            PremiumDetailsView(selectedTab: $selectedTab)
                .previewDisplayName("Premium Details")

            // Preview for Supreme
            PremiumDetailsView(selectedTab: .constant(.supreme)) // Using constant binding for Supreme
                .previewDisplayName("Supreme Details")
        }
    }
}
