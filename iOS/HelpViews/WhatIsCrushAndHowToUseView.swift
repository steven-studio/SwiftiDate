//
//  WhatIsCrushAndHowToUseView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import Foundation
import SwiftUI

struct WhatIsCrushAndHowToUseView: View {
    @Binding var isWhatIsCrushAndHowToUseView: Bool // Binding to control the dismissal of WhatIsCrushAndHowToUseView

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isWhatIsCrushAndHowToUseView = false // Dismiss WhatIsCrushAndHowToUseView and return to HelpView
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
                    // Detailed content of WhatIsCrushAndHowToUseView
                    Text("「Crush」是什麼？如何使用？")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("""
                    如果你對某個人一見鍾情，就發送「Crush」讓她/他知道吧！

                    SwiftiDate Premium 用戶每天都有免費的 Crush，點擊滑卡頁面的綠色鑽石💎 按鈕，把你的 Crush 送給你特別喜歡的用戶，她/他們將立刻注意到你——你的卡片將對她/他進行 Highlight 顯示，並優先於其他用戶顯示在最前面。此時如果對方右滑，即可立即配對！

                    **請注意，列表中顯示的用戶不包括：**

                    - 已配對的用戶
                    - 照片未通過審核的用戶
                    - 被封鎖的用戶
                    - 已註銷的用戶
                    - 不符合你搜索性別和年齡的用​戶

                    同樣的，在這個界面也可以選擇「我喜歡的人」選項卡，查看你右滑過的人。 發送Crush可以讓你們的邂逅機率提高5倍哦！
                    """)
                    .padding()
                }
            }
        }
        .padding()
    }
}

// Preview for WhatIsCrushAndHowToUseView
struct WhatIsCrushAndHowToUseView_Previews: PreviewProvider {
    @State static var isWhatIsCrushAndHowToUseView = true // Provide a sample state variable for the preview

    static var previews: some View {
        WhatIsCrushAndHowToUseView(isWhatIsCrushAndHowToUseView: $isWhatIsCrushAndHowToUseView) // Use the binding variable in the preview
    }
}
