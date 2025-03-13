//
//  WhyIsItHardToMatchView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import Foundation
import SwiftUI

struct WhyIsItHardToMatchView: View {
    @Binding var isWhyIsItHardToMatch: Bool // Binding to control the dismissal of WhyIsItHardToMatchView

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isWhyIsItHardToMatch = false // Dismiss WhyIsItHardToMatchView and return to HelpView
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
                    // Introduction about the Swift development and future plans
                    Text("""
                    SwiftiDate 是一款使用 Swift 開發的交友應用程式，因此目前僅有 iOS 用戶可以使用。不過，未來我們可能會開發其他平台的交友應用程式，並且讓這些應用程式與 SwiftiDate 互通。這樣一來，使用 SwiftiDate 的用戶將能夠與其他交友軟體的用戶配對，實現跨平台的交友體驗，畢竟資料庫都可以弄一樣。
                    """)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .padding(.bottom, 10)
                    
                    // Detailed content of WhyIsItHardToMatchView
                    Text("為什麼我很難配對成功？")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("""
                    你可以嘗試以下幾種辦法來增加配對成功率：

                    1. **通過真人認證**：點亮個人卡片右上角的小藍勾，獲得真人認證專屬圖標，讓對方認為你是真的人，這樣他們才會更願意與你互動。畢竟現在交友軟體上假人太多，大家都覺得跟假人互動很浪費時間。
                    
                    2. **拍好看的照片**：將你的主頭像拍得好看一點、有質感一點，最好是有個性一點的單人照片，這樣更容易吸引到更多喜愛。建議上傳更多旅行照或興趣照，讓其他人更瞭解你，但千萬不要從網路上下載，因為這會涉及到侵權問題喔，我可不會幫你負責。

                    3. **完善個人資料**：填寫更多關於你的個資，上傳更多關於你生活樂趣的照片，讓其他人更瞭解你，或許就會有跟你有共同愛好的人喜歡你喔！

                    4. **調整設定**：如果覺得配對很困難，可以嘗試接受大一點的距離或擴大年齡範圍。這樣你會有更多的選項，配對的機會也會提高。

                    5. **多滑動**：多多使用 SwiftiDate，多滑動，你會有更多推薦，其他用戶會更容易看到你，你也就有更多的配對機會啦。
                    """)
                    .padding()
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

// Preview for WhyIsItHardToMatchView
struct WhyIsItHardToMatchView_Previews: PreviewProvider {
    @State static var isWhyIsItHardToMatch = true // Provide a sample state variable for the preview

    static var previews: some View {
        WhyIsItHardToMatchView(isWhyIsItHardToMatch: $isWhyIsItHardToMatch) // Use the binding variable in the preview
    }
}
