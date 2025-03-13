//
//  WhatIsSwiftiDatePremiumDiscountPolicyView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import SwiftUI

struct WhatIsSwiftiDatePremiumDiscountPolicyView: View {
    @Binding var isWhatIsSwiftiDatePremiumDiscountPolicyView: Bool // Binding to control the dismissal of the view

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isWhatIsSwiftiDatePremiumDiscountPolicyView = false // Dismiss the view and return to HelpView
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
                    // Detailed content of WhatIsSwiftiDatePremiumDiscountPolicyView
                    Text("SwiftiDate Premium 的價格有優惠嗎？")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("""
                    SwiftiDate Premium 的價格將根據不同的市場和地區進行定價，優惠政策可能會因區域而有所不同，請以您所在地區的收費界面上的標價為準。

                    我們建議您在購買前查看 SwiftiDate App 內的 Premium 購買頁面，瞭解目前提供的優惠價格或折扣信息。

                    SwiftiDate Premium 可能會不定期舉辦促銷活動，讓用戶以更優惠的價格享受尊貴會員特權，請密切關注 SwiftiDate 官方公告，或者查看 App 內的消息通知，以免錯過任何優惠活動。

                    如果您對價格或優惠政策有任何疑問，歡迎聯繫 SwiftiDate 客服，我們將竭誠為您服務。
                    """)
                    .padding()
                }
            }
        }
        .padding()
    }
}

// Preview for WhatIsSwiftiDatePremiumDiscountPolicyView
struct WhatIsSwiftiDatePremiumDiscountPolicyView_Previews: PreviewProvider {
    @State static var isWhatIsSwiftiDatePremiumDiscountPolicyView = true // Provide a sample state variable for the preview

    static var previews: some View {
        WhatIsSwiftiDatePremiumDiscountPolicyView(isWhatIsSwiftiDatePremiumDiscountPolicyView: $isWhatIsSwiftiDatePremiumDiscountPolicyView) // Use the binding variable in the preview
    }
}
