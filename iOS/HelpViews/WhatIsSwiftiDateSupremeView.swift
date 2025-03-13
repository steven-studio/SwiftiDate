//
//  WhatIsSwiftiDateSupremeView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import SwiftUI

struct WhatIsSwiftiDateSupremeView: View {
    @Binding var isWhatIsSwiftiDateSupremeView: Bool // Binding to control the dismissal of WhatIsSwiftiDateSupremeView

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isWhatIsSwiftiDateSupremeView = false // Dismiss WhatIsSwiftiDateSupremeView and return to HelpView
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
                    // Detailed content of WhatIsSwiftiDateSupremeView
                    Text("什麼是 SwiftiDate Supreme？")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("""
                    SwiftiDate Supreme 是針對追求頂級功能的用戶所打造的升級服務，比起 SwiftiDate Premium，SwiftiDate Supreme 為您帶來更多的特權：

                    1. **附近的人**：讓你可以直接與離你最近的人聊天，輕鬆發現身邊的潛在對象，快速建立聯繫。

                    2. **每日 3 次讚美的機會**：每天可以直接向 3 個用戶發送訊息，無需配對即可開始聊天，讓你有更多機會與心儀的對象互動。

                    3. **高級篩選**：針對身高、學歷、交友目的、生活風格等進行進階篩選，精準找到符合你要求的對象，節省尋找的時間。

                    4. **隱身模式**：開啟隱身模式後，只讓你主動喜歡的人看到你，保護你的隱私，讓你的 SwiftiDate 使用體驗更加自由。

                    5. **Premium 會員的所有權益**：SwiftiDate Supreme 用戶同時擁有 SwiftiDate Premium 所有的特權，享受雙倍的尊貴待遇。

                    簡單來說，SwiftiDate Supreme 讓你在尋找理想對象的過程中擁有更大的自主權和更多的機會，提升你在交友上的效率和成功率。
                    """)
                    .padding()
                }
            }
        }
        .padding()
    }
}

// Preview for WhatIsSwiftiDateSupremeView
struct WhatIsSwiftiDateSupremeView_Previews: PreviewProvider {
    @State static var isWhatIsSwiftiDateSupremeView = true // Provide a sample state variable for the preview

    static var previews: some View {
        WhatIsSwiftiDateSupremeView(isWhatIsSwiftiDateSupremeView: $isWhatIsSwiftiDateSupremeView) // Use the binding variable in the preview
    }
}
