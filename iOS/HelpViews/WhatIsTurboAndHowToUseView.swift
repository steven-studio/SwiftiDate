//
//  WhatIsTurboAndHowToUseView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import Foundation
import SwiftUI

struct WhatIsTurboAndHowToUseView: View {
    @Binding var isWhatIsTurboAndHowToUseView: Bool // Binding to control the dismissal of WhatIsTurboAndHowToUseView

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isWhatIsTurboAndHowToUseView = false // Dismiss WhatIsTurboAndHowToUseView and return to HelpView
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
                    // Detailed content of WhatIsTurboAndHowToUseView
                    Text("「Turbo」是什麼？如何使用？")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("""
                    想要獲得更多被人發現的機會？用「Turbo」來幫你實現吧！

                    SwiftiDate Premium 用戶每個月都將有 1 次免費的 Turbo，在「聊天」界面的「新配對」下點擊顯示「更多配對」的粉色火箭🚀 按鈕，即可在 30 分鐘內獲得 10 倍的優先顯示，快速獲得更多喜歡！
                    """)
                    .padding(.bottom, 10)
                    
                    Text("""
                    使用 Turbo 後，您的卡片會更加顯眼地呈現在其他用戶的視線中，這是提高配對成功率的絕佳機會。記得合理運用這個功能，增加自己的曝光度，讓更多人發現您的魅力！

                    請注意：Turbo 效果持續 30 分鐘，請確保在此期間您已準備好迎接更多的配對機會！
                    """)
                    .padding()
                }
            }
        }
        .padding()
    }
}

// Preview for WhatIsTurboAndHowToUseView
struct WhatIsTurboAndHowToUseView_Previews: PreviewProvider {
    @State static var isWhatIsTurboAndHowToUseView = true // Provide a sample state variable for the preview

    static var previews: some View {
        WhatIsTurboAndHowToUseView(isWhatIsTurboAndHowToUseView: $isWhatIsTurboAndHowToUseView) // Use the binding variable in the preview
    }
}
