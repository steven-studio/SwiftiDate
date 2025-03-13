//
//  StatisticsSectionView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/17.
//

import Foundation
import SwiftUI

struct StatisticsSectionView: View {
    @Binding var selectedTab: Int
    @Binding var isShowingTurboView: Bool
    @EnvironmentObject var userSettings: UserSettings // 使用 EnvironmentObject 來訪問全局設置
    
    var body: some View {
        HStack(spacing: 50) {
            Button(action: {
                selectedTab = 0 // 設定 selectedTab 為 0 以顯示「喜歡我的人」
                isShowingTurboView = true // 顯示 TurboView
            }) {
                VStack {
                    Text(userSettings.globalLikesMeCount >= 99 ? "99+" : "\(userSettings.globalLikesMeCount)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black) // 設置文字顏色為黑色
                    Text("喜歡我")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            Button(action: {
                selectedTab = 1 // 設定 selectedTab 為 1 以顯示「我的心動對象」
                isShowingTurboView = true // 顯示 TurboView
            }) {
                VStack {
                    Text(userSettings.globalLikeCount > 99 ? "99+" : "\(userSettings.globalLikeCount)") // 顯示根據 like count 決定的數字
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black) // 設置文字顏色為黑色
                    Text("我喜歡")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            VStack {
                Text("5")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black) // 設置文字顏色為黑色
                Text("精選")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal)
    }
}
