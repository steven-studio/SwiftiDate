//
//  HowToDeleteMessagesView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import Foundation
import SwiftUI

struct HowToDeleteMessagesView: View {
    @Binding var isHowToDeleteMessages: Bool // Binding to control the dismissal of HowToDeleteMessagesView

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isHowToDeleteMessages = false // Dismiss HowToDeleteMessagesView and return to HelpView
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
                    // Detailed content of HowToDeleteMessagesView
                    Text("可以刪除傳出去的訊息嗎？")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("""
                    當你想要刪除單則聊天訊息時，可以長按需要刪除的訊息內容，並在彈出的提示中選擇「撤回」，即可刪除該則訊息。

                    注意：被撤回的聊天訊息會從雙方的聊天記錄中刪除。

                    你也可以選擇清空聊天記錄：

                    1. 點擊主界面下方的聊天氣泡💬 按鈕進入「聊天」界面；
                    
                    2. 點擊你要清空聊天記錄的配對好友；
                    
                    3. 在聊天界面點擊右上角的三點按鈕 ···，選擇「刪除聊天記錄」。

                    注意：清空聊天記錄後不可恢復，因為已經從資料庫刪除了。
                    """)
                    .padding()
                }
            }
        }
        .padding()
    }
}

// Preview for HowToDeleteMessagesView
struct HowToDeleteMessagesView_Previews: PreviewProvider {
    @State static var isHowToDeleteMessages = true // Provide a sample state variable for the preview

    static var previews: some View {
        HowToDeleteMessagesView(isHowToDeleteMessages: $isHowToDeleteMessages) // Use the binding variable in the preview
    }
}
