//
//  HowToReportView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/10.
//

import Foundation
import SwiftUI

struct HowToReportView: View {
    @Binding var showHowToReportView: Bool

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // 記錄返回事件並回到上一個視圖
                    AnalyticsManager.shared.trackEvent("HowToReport_BackTapped", parameters: nil)
                    showHowToReportView = false
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                        .padding()
                }
                Spacer()
            }

            Spacer()
            
            Image(systemName: "magnifyingglass.circle.fill")
                .resizable()
                .frame(width: 120, height: 120)
                .foregroundColor(.yellow)
                .padding()
            
            Text("如何檢舉")
                .font(.title)
                .fontWeight(.bold)
            
            Text("""
                你可以隨時檢舉讓你覺得不安全的用戶，無論是否與其配對。
                檢舉已配對的用戶：
                - 點擊主介面下方的聊天氣泡，按鈕進入「聊天」介面；
                - 點擊你想檢舉的人；
                - 點擊介面右上角的三點按鈕，選擇「匿名檢舉和封鎖」；
                檢舉尚未配對的用戶：
                - 點擊用戶卡片，進入用戶資料介面；
                檢舉是完全匿名的，SwiftiDate 不會向被檢舉的用戶透露任何細節。
                """)
                .font(.body)
                .foregroundColor(.gray)
                .padding()
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            AnalyticsManager.shared.trackEvent("HowToReportView_Appeared", parameters: nil)
        }
    }
}

struct HowToReportView_Previews: PreviewProvider {
    @State static var showHowToReportView = true

    static var previews: some View {
        HowToReportView(showHowToReportView: $showHowToReportView)
    }
}
