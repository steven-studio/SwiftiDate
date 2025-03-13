//
//  ReportUserView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import Foundation
import SwiftUI

struct ReportUserView: View {
    @Binding var isReportUserView: Bool // Binding to control the dismissal of ReportUserView

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isReportUserView = false // Dismiss ReportUserView and return to HelpView
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                
                Text("SwiftiDate 幫助")
                    .font(.headline)
                    .padding(.leading, 5)
                
                Spacer()
            }
            .padding()
            
            Divider()
            
            // Scrollable content
            ScrollView {
                VStack(alignment: .leading) {
                    // Detailed content of ReportUserView
                    Text("如何檢舉用戶？")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("""
                    要檢舉有不良行為的用戶，請按照以下步驟操作：

                    **當用戶是你已經配對的人時：**

                    1. 點擊主界面下方的聊天氣泡💬 按鈕進入「聊天」界面；
                    2. 點擊你所想要檢舉的人；
                    3. 在聊天界面點擊右上角的三點按鈕 ···，選擇「匿名檢舉與封鎖」；
                    4. 選擇檢舉原因並提供佐證，點擊提交，即可進行檢舉。

                    **當用戶是你尚未配對的人時：**

                    5. 點擊用戶卡片，進入用戶資料界面；
                    6. 在資料界面點擊右上角的三點按鈕 ···，選擇「匿名檢舉與封鎖」；
                    7. 選擇檢舉原因並提供佐證，點擊提交，即可進行檢舉。

                    **注意**：請確保你的檢舉是符合事實的，建議附帶截圖一併提交。濫用檢舉功能將可能影響正常使用。一旦提交檢舉，被檢舉的用戶將從你的配對列表中永久刪除，無法恢復。
                    
                    **如果對方在其他聯絡方式對你進行勒索或騷擾**，請務必將該聯絡方式的截圖一併提供作為檢舉的佐證，這樣我們可以更有效地處理此問題，確保平台安全。
                    """)
                    .padding()
                }
            }
        }
        .padding()
    }
}

// Preview for ReportUserView
struct ReportUserView_Previews: PreviewProvider {
    @State static var isReportUserView = true // Provide a sample state variable for the preview

    static var previews: some View {
        ReportUserView(isReportUserView: $isReportUserView) // Use the binding variable in the preview
    }
}
