//
//  ReportAftermathView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/10.
//

import Foundation
import SwiftUI

struct ReportAftermathView: View {
    @Binding var showReportAftermathView: Bool
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // 點擊返回按鈕前記錄事件
                    AnalyticsManager.shared.trackEvent("ReportAftermath_BackTapped", parameters: nil)
                    showReportAftermathView = false
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding()
            
            Spacer()

            // 此處放入你要顯示的檢舉後的內容
            Image("report_aftermath_cone") // 使用你的圖片名稱
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200) // 根據需要調整大小
                .padding()

            Text("檢舉後會發生什麼？")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)

            Text("""
            感謝你對 SwiftiDate 平台的努力，你的檢舉會讓 SwiftiDate 平台更加安全喔~

            在用戶提交檢舉之後：SwiftiDate 會派專人審核，認真處理。

            - 被檢舉的人會從你的滑卡列表、配對列表消失；
            - 你會收到來自小助手的訊息，通知你處理結果。
            """)
                .font(.body)
                .multilineTextAlignment(.leading)
                .padding()
            
            Spacer()
        }
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            AnalyticsManager.shared.trackEvent("ReportAftermathView_Appeared", parameters: nil)
        }
    }
}

struct ReportAftermathView_Previews: PreviewProvider {
    @State static var showReportAftermathView = true // 預覽中綁定的狀態變數
    
    static var previews: some View {
        ReportAftermathView(showReportAftermathView: $showReportAftermathView)
    }
}
