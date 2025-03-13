//
//  RestorePurchaseView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import SwiftUI

struct RestorePurchaseView: View {
    @Binding var isRestorePurchaseView: Bool // Binding to control the dismissal of RestorePurchaseView

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isRestorePurchaseView = false // Dismiss RestorePurchaseView and return to HelpView
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
                    // Detailed content of RestorePurchaseView
                    Text("支付完成後，特權未生效怎麼辦？")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("""
                    如果您已經支付成功，但 SwiftiDate Premium 特權仍未生效，請按照以下步驟嘗試恢復購買：

                    1. 打開 SwiftiDate App，進入「設置」界面。
                    2. 在設置中，找到並點擊「恢復購買」選項。
                    3. 確認恢復購買操作後，系統將會檢查您的購買記錄並重新激活您的 SwiftiDate Premium 特權。

                    如果上述步驟仍無法解決問題，請嘗試以下操作：

                    - 確保您的手機已連接到穩定的網絡環境。
                    - 檢查您的 App Store 賬號是否與您購買 SwiftiDate Premium 時使用的賬號一致。
                    - 嘗試重新啟動 SwiftiDate App 或重新登錄您的賬號。

                    如果問題仍未解決，或者支付未成功，您可以聯繫 SwiftiDate 客服，我們將竭誠為您提供幫助。

                    此外，SwiftiDate 的原始碼已經上傳至 GitHub，歡迎用戶查看並幫助我們排查問題，尋找解決方案。您可以在 GitHub 上提交 Issue 或查看我們的 FAQ，謝謝您的支持！
                    """)
                    .padding()
                }
            }
        }
        .padding()
    }
}

// Preview for RestorePurchaseView
struct RestorePurchaseView_Previews: PreviewProvider {
    @State static var isRestorePurchaseView = true // Provide a sample state variable for the preview

    static var previews: some View {
        RestorePurchaseView(isRestorePurchaseView: $isRestorePurchaseView) // Use the binding variable in the preview
    }
}
