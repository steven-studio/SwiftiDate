//
//  AdaptiveAchievementCardView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/5.
//

import Foundation
import SwiftUI

struct AdaptiveAchievementCardView: View {
    var title: String
    var count: Int
    var color: Color
    var action: (() -> Void)?
    
    var body: some View {
        GeometryReader { geometry in
            // 使用 geometry.size 取得可用的寬度與高度
            VStack {
                Text(title)
                    .font(.system(size: geometry.size.width * 0.15))
                    .fontWeight(.bold)
                Text("\(count)")
                    .font(.system(size: geometry.size.width * 0.25))
                    .fontWeight(.bold)
                Button(action: {
                    action?()
                }) {
                    Text("獲取更多")
                        .font(.system(size: geometry.size.width * 0.12))
                        .foregroundColor(.gray)
                        .padding(5)
                        .background(Color.white)
                        .cornerRadius(5)
                }
                .accessibilityIdentifier("AdaptiveAchievementCard_GetMoreButton_\(title)")
            }
            // 根據 GeometryReader 傳遞的尺寸動態調整 frame
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(color.opacity(0.2))
            .cornerRadius(10)
        }
        // 可以根據需要設定 GeometryReader 的固定大小或是使用彈性佈局
        .frame(width: 100, height: 100)
    }
}
