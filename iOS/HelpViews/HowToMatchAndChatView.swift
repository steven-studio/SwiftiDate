//
//  HowToMatchAndChatView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import Foundation
import SwiftUI

struct HowToMatchAndChatView: View {
    @Binding var isHowToMatchAndChat: Bool // Binding to control the dismissal of HowToMatchAndChatView

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isHowToMatchAndChat = false // Dismiss HowToMatchAndChatView and return to HelpView
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                }
                
                Text("SwiftiDate 幫助")
                    .font(.headline)
                    .padding(.leading, 5)
                
                Spacer()
            }
            .padding()
            
            Divider()
            
            // Detailed content of HowToMatchAndChatView
            Text("如何與他人配對、聊天？")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            HStack {
                Spacer() // Add a spacer to push the image to the center
                Image("how_to_match_and_chat") // Replace this with your actual image name
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.bottom, 20)
                Spacer() // Add another spacer to keep the image centered
            }
            
            Text("""
            看到有好感的用戶，你可以右滑表示「喜歡」，如果你和對方互相喜歡即配對成功，並可以開始聊天。配對成功前，雙方都不會知道對方是否喜歡了自己喔。

            你可以點擊主介面下方的聊天氣泡💬 按鈕進入「聊天」界面查看你所有的配對。

            如果你現在還沒有任何配對，請繼續滑動用戶卡片，並確認自己的個人資料是否填寫完善，資料豐富的用戶會更快獲得配對喔！
            """)
            .padding()

            Spacer()
        }
        .padding()
    }
}

// Preview for HowToMatchAndChatView
struct HowToMatchAndChatView_Previews: PreviewProvider {
    @State static var isHowToMatchAndChat = true // Provide a sample state variable for the preview

    static var previews: some View {
        HowToMatchAndChatView(isHowToMatchAndChat: $isHowToMatchAndChat) // Use the binding variable in the preview
    }
}
