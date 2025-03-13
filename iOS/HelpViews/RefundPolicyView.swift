//
//  RefundPolicyView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import SwiftUI

struct RefundPolicyView: View {
    @Binding var isRefundPolicyView: Bool // Binding to control the dismissal of RefundPolicyView

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isRefundPolicyView = false // Dismiss RefundPolicyView and return to HelpView
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
                    // Detailed content of RefundPolicyView
                    Text("已經成功續訂 SwiftiDate Premium，還可以退款嗎？")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("""
                    如果您未在訂閱期結束的至少 24 小時前取消訂閱，則 SwiftiDate 將會繼續扣款，一旦扣款成功，我們會為特權用戶開通下一個計費週期的訂閱服務。根據我們的政策，已成功付款並開通或續訂的服務，SwiftiDate 將不予以退款。

                    為了避免自動續費，建議您在訂閱期結束前至少 24 小時內取消自動訂閱。具體操作方法可參考「如何取消自動續費」的指南。

                    如果您在購買過程中遇到問題，或者對於服務有任何疑問，歡迎隨時聯繫 SwiftiDate 客服，我們將竭誠為您提供幫助。

                    感謝您的理解與支持！
                    """)
                    .padding()
                }
            }
        }
        .padding()
    }
}

// Preview for RefundPolicyView
struct RefundPolicyView_Previews: PreviewProvider {
    @State static var isRefundPolicyView = true // Provide a sample state variable for the preview

    static var previews: some View {
        RefundPolicyView(isRefundPolicyView: $isRefundPolicyView) // Use the binding variable in the preview
    }
}
