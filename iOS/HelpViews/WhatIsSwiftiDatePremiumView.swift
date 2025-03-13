//
//  WhatIsSwiftiDatePremiumView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import Foundation
import SwiftUI

struct WhatIsSwiftiDatePremiumView: View {
    @Binding var isWhatIsSwiftiDatePremium: Bool // Binding to control the dismissal of WhatIsSwiftiDatePremiumView

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isWhatIsSwiftiDatePremium = false // Dismiss WhatIsSwiftiDatePremiumView and return to HelpView
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
                    // Detailed content of WhatIsSwiftiDatePremiumView
                    Text("什麼是 SwiftiDate Premium？")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("""
                    SwiftiDate Premium 是一項專為追求更多互動可能性的用戶而打造的升級服務。訂閱 SwiftiDate Premium 的用戶，除了享有普通註冊用戶的功能外，還可以使用一系列獨享特權，讓你的交友體驗更加豐富多彩。

                    **SwiftiDate Premium 專享功能：**

                    1. **看看誰喜歡你**：隨時查看有哪些用戶對你右滑或選擇了「喜歡」，直接與他們配對，告別等待。

                    2. **無限次喜歡**：突破每日右滑限制，盡情展現你的心意，對更多感興趣的人表達「喜歡」。

                    3. **每日 5 次免費 Crush**：將你的卡片優先展示給 Crush 對象，讓心儀的她/他更早感受到你的心意。

                    4. **每月 1 次免費 Turbo**：增加曝光度達 10 倍，讓更多用戶能夠注意到你，提升你的配對機會。

                    5. **開啟心動列表**：查看所有你右滑過的人，方便隨時回顧，還可以再次送出 Crush。

                    6. **已讀回執**：確認對方是否已查看你的訊息，讓你掌握交友進度，增強互動信心。

                    7. **滑錯反悔**：如果因手滑錯過了感興趣的人，立即撤銷並重新機會，避免遺憾。

                    8. **Premium 專屬標識**：享有專屬尊貴標誌，增加你在配對中的吸引力，提升 2.5 倍的配對機率。

                    9. **我的解除配對**：查看並找回已解除的配對，再次尋找失去的緣分。

                    **簡單來說，SwiftiDate Premium 就是讓你體驗到一種更有效、更豐富的交友旅程，猶如享受街頭邂逅的無限可能，讓你在眾多選擇中更輕鬆找到心動的她/他。**
                    """)
                    .padding()
                }
            }
        }
        .padding()
    }
}

// Preview for WhatIsSwiftiDatePremiumView
struct WhatIsSwiftiDatePremiumView_Previews: PreviewProvider {
    @State static var isWhatIsSwiftiDatePremium = true // Provide a sample state variable for the preview

    static var previews: some View {
        WhatIsSwiftiDatePremiumView(isWhatIsSwiftiDatePremium: $isWhatIsSwiftiDatePremium) // Use the binding variable in the preview
    }
}
