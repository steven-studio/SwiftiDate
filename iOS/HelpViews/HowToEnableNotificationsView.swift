//
//  HowToEnableNotificationsView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import SwiftUI

struct HowToEnableNotificationsView: View {
    @Binding var isHowToEnableNotificationsView: Bool // Binding to control the dismissal of HowToEnableNotificationsView

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isHowToEnableNotificationsView = false // Dismiss HowToEnableNotificationsView and return to the previous view
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
                    // Detailed content of HowToEnableNotificationsView
                    Text("如何收到 SwiftiDate 的訊息提醒？")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("""
                    為了確保你能及時收到 SwiftiDate 的訊息通知，請按照以下步驟進行設定：

                    **iOS用戶：**

                    1. 打開【iPhone 設定】
                    2. 點擊【通知】
                    3. 找到並選擇【SwiftiDate】
                    4. 開啟【允許通知】的選項

                    設定完成後，你就能收到來自 SwiftiDate 的訊息提醒，確保你不會錯過任何重要的訊息！
                    """)
                    .padding()
                }
            }
        }
        .padding()
    }
}

// Preview for HowToEnableNotificationsView
struct HowToEnableNotificationsView_Previews: PreviewProvider {
    @State static var isHowToEnableNotificationsView = true // Provide a sample state variable for the preview

    static var previews: some View {
        HowToEnableNotificationsView(isHowToEnableNotificationsView: $isHowToEnableNotificationsView) // Use the binding variable in the preview
    }
}
