//
//  SafetyTipsView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/10.
//

import Foundation
import SwiftUI

struct SafetyTipsView: View {
    @Binding var showSafetyTipsView: Bool // 傳入是否顯示安全提示視圖的狀態

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // 返回到上個頁面並記錄事件
                    AnalyticsManager.shared.trackEvent("SafetyTips_BackTapped", parameters: nil)
                    showSafetyTipsView = false
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                }
                .padding()

                Spacer()
            }
            
            Spacer()

            Image(systemName: "lightbulb.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.pink)
                .padding()

            Text("安全提示")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("""
            SwiftiDate 努力於打造一個安全、愉快的交友環境，對於詐騙、騷擾等行為零容忍。以下是 SwiftiDate 給你的安全提示：
            
            - 請不要透漏個人隱私信息
            
            - 僅在 SwiftiDate 平台上聊天
            
            - 如果對方提出可疑要求，立即檢舉
            """)
                .font(.body)
                .multilineTextAlignment(.leading)
                .padding()

            Spacer()

            Button(action: {
                // 返回到安全中心並記錄事件
                AnalyticsManager.shared.trackEvent("SafetyTips_Dismissed", parameters: nil)
                showSafetyTipsView = false
            }) {
                Text("好的")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal, 30)
            }

            Spacer()
        }
        .background(Color.white.ignoresSafeArea())
    }
}

struct SafetyTipsView_Previews: PreviewProvider {
    static var previews: some View {
        SafetyTipsView(showSafetyTipsView: .constant(true))
    }
}
