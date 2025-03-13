//
//  HowToEnablePremiumBadgeView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import Foundation
import SwiftUI

struct HowToEnablePremiumBadgeView: View {
    @Binding var isHowToEnablePremiumBadgeView: Bool // Binding to control the dismissal of HowToEnablePremiumBadgeView

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isHowToEnablePremiumBadgeView = false // Dismiss HowToEnablePremiumBadgeView and return to HelpView
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
                    // Detailed content of HowToEnablePremiumBadgeView
                    Text("如何開啟 Premium 專屬標誌？")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("""
                    開啓專屬標誌，讓別人知道你是尊貴的菁英會員！

                    只需按照以下步驟操作：

                    1. 點選主界面右上角的齒輪⚙️ 進入「設定」界面。
                    2. 勾選「開啟Premium尊貴標識」，你就可以看到頭像上代表 Premium 用戶專屬的小皇冠👑 啦！

                    訂閱 SwiftiDate Premium 的用戶才能使用這項功能，趕快享受這份尊榮，讓你的個人檔案更加出眾吧！
                    """)
                    .padding()
                }
            }
        }
        .padding()
    }
}

// Preview for HowToEnablePremiumBadgeView
struct HowToEnablePremiumBadgeView_Previews: PreviewProvider {
    @State static var isHowToEnablePremiumBadgeView = true // Provide a sample state variable for the preview

    static var previews: some View {
        HowToEnablePremiumBadgeView(isHowToEnablePremiumBadgeView: $isHowToEnablePremiumBadgeView) // Use the binding variable in the preview
    }
}
