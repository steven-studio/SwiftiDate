//
//  HowToCancelSubscriptionView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import Foundation
import SwiftUI

struct HowToCancelSubscriptionView: View {
    @Binding var isHowToCancelSubscriptionView: Bool // Binding to control the dismissal of HowToCancelSubscriptionView

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isHowToCancelSubscriptionView = false // Dismiss HowToCancelSubscriptionView and return to HelpView
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
                    // Detailed content of HowToCancelSubscriptionView
                    Text("如何取消自動續費？")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("""
                    iPhone 手機用戶在開通特權服務的同時，默認您已接受訂閱服務；當然，SwiftiDate Premium 用戶亦可自行取消訂閱服務，具體操作如下：

                    **針對 iPhone 手機用戶：**

                    1. 手動打開 iPhone 手機【設置】；
                    2. 進入【iTunes Store 與 App Store】；
                    3. 點擊【Apple ID】，打開 Apple ID 菜單；
                    4. 選擇【查看 Apple ID】進入 【帳戶設置】頁面；
                    5. 點擊【訂閱】；
                    6. 打開有效的【SwiftiDate Premium】訂閱項，【取消訂閱】即可。

                    **注意**：若您未在訂閱期結束的至少 24 小時前取消訂閱，則 App Store 會按照一定規則繼續進行扣款，一旦扣款成功，SwiftiDate 將為特權用戶開通下一個計費週期的訂閱服務。

                    **針對使用其他付款方式（如信用卡）的用戶：**

                    1. 打開【SwiftiDate】App；
                    2. 點擊主頁的👤按鈕；
                    3. 點擊右上角【設置】；
                    4. 點擊【訂閱管理】；
                    5. 選擇想取消的訂閱；
                    6. 點擊【取消訂閱】按鈕即可。
                    """)
                    .padding()
                }
            }
        }
        .padding()
    }
}

// Preview for HowToCancelSubscriptionView
struct HowToCancelSubscriptionView_Previews: PreviewProvider {
    @State static var isHowToCancelSubscriptionView = true // Provide a sample state variable for the preview

    static var previews: some View {
        HowToCancelSubscriptionView(isHowToCancelSubscriptionView: $isHowToCancelSubscriptionView) // Use the binding variable in the preview
    }
}
