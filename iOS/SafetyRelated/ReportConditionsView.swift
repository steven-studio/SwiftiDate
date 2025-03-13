//
//  ReportConditionsView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/10.
//

import Foundation
import SwiftUI

struct ReportConditionsView: View {
    @Binding var showReportConditionsView: Bool

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // 返回按鈕操作，關閉當前視圖
                    showReportConditionsView = false
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                        .padding()
                }
                Spacer()
            }

            Spacer()

            // 標題及說明文字
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .frame(width: 120, height: 120)
                .foregroundColor(.pink)
                .padding()

            Text("什麼情況下我應該檢舉")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 10)

            Text("""
在 SwiftiDate 上，我們最重視的是安全。當你在滑卡或聊天時遇到任何可疑行為或感到不適時，你都可以向 SwiftiDate 尋求協助。

當你遇到以下幾類行為的時候，請務必向 SwiftiDate 檢舉：
- 當有人要求你提供銀行帳戶等資料
- 收到騷擾或威脅
- 詐騙或銷售
- 未經同意，向你發送色情內容
- 頭像、個人資料不真實
""")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .padding()

            Spacer()

            Button(action: {
                // 了解按鈕操作，返回上一頁
                showReportConditionsView = false
            }) {
                Text("了解了")
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
        .onAppear {
            AnalyticsManager.shared.trackEvent("SafetyTipsView_Appeared", parameters: nil)
        }
    }
}

struct ReportConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        ReportConditionsView(showReportConditionsView: .constant(true))
    }
}
