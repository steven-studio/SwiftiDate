//
//  WhatIsSwiftiDateView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import Foundation
import SwiftUI

struct WhatIsSwiftiDateView: View {
    @Binding var isWhatIsSwiftiDate: Bool // Binding to control the dismissal of WhatIsSwiftiDateView

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isWhatIsSwiftiDate = false // Dismiss WhatIsSwiftiDateView and return to HelpView
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
            
            // Detailed content of WhatIsSwiftiDateView
            Text("SwiftiDate 是什麼？")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            HStack {
                Spacer() // This will push the image to the center
                Image("what_is_swiftidate") // Updated to a more meaningful image name
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.bottom, 20)
                Spacer() // This will ensure the image remains centered
            }
            
            Text("""
            SwiftiDate 是一款專為年輕 iOS 用戶打造的交友應用程式，完全由 Swift 開發。這是一個能讓你認識新朋友並找到歸屬感的社交平台。在 SwiftiDate 中，你可以輕鬆瀏覽其他用戶的照片、個人資料和興趣，右滑送出你的喜歡，尋找心儀的對象。如果你和另一位用戶互相喜歡，你們就會成功配對，開啟屬於你們的聊天之旅！

            為了讓你更快找到理想的另一半，我們鼓勵你善用 Crush 和 讚美 功能，增強與對方互動的機會，展現你的誠意與魅力！快來 SwiftiDate，找到那個讓你心動的他/她吧！
            """)
            .padding()

            Spacer()
        }
        .padding()
    }
}

// Preview for WhatIsSwiftiDateView
struct WhatIsSwiftiDateView_Previews: PreviewProvider {
    @State static var isWhatIsSwiftiDate = true // Provide a sample state variable for the preview

    static var previews: some View {
        WhatIsSwiftiDateView(isWhatIsSwiftiDate: $isWhatIsSwiftiDate) // Use the binding variable in the preview
    }
}
