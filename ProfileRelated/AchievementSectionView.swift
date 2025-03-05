//
//  AchievementSectionView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/17.
//

import Foundation
import SwiftUI

struct AchievementSectionView: View {
    @EnvironmentObject var userSettings: UserSettings
    @Binding var isShowingTurboPurchaseView: Bool
    @Binding var isShowingCrushPurchaseView: Bool
    @Binding var isShowingPraisePurchaseView: Bool

    var body: some View {
        HStack(spacing: 20) {
            AdaptiveAchievementCardView(title: "TURBO", count: userSettings.globalTurboCount, color: Color.purple) {
                // 埋點：點擊TURBO卡片
                AnalyticsManager.shared.trackEvent("achievement_card_turbo_tapped")
                isShowingTurboPurchaseView = true
            }
            AdaptiveAchievementCardView(title: "CRUSH", count: userSettings.globalCrushCount, color: Color.green) {
                // 埋點：點擊CRUSH卡片
                AnalyticsManager.shared.trackEvent("achievement_card_crush_tapped")
                isShowingCrushPurchaseView = true
            }
            AdaptiveAchievementCardView(title: "讚美", count: userSettings.globalPraiseCount, color: Color.orange) {
                // 埋點：點擊讚美卡片
                AnalyticsManager.shared.trackEvent("achievement_card_praise_tapped")
                isShowingPraisePurchaseView = true
            }
        }
        .padding(.horizontal)
        .sheet(isPresented: $isShowingTurboPurchaseView) {
            TurboPurchaseView()
        }
        .sheet(isPresented: $isShowingCrushPurchaseView) {
            CrushPurchaseView()
        }
        .sheet(isPresented: $isShowingPraisePurchaseView) {
            PraisePurchaseView()
        }
    }
}
