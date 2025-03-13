//
//  WhoLikedMeView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import Foundation
import SwiftUI

struct WhoLikedMeView: View {
    @Binding var isWhoLikedMeView: Bool // Binding to control the dismissal of WhoLikedMeView

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isWhoLikedMeView = false // Dismiss WhoLikedMeView and return to HelpView
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
            
            // Detailed content of WhoLikedMeView
            Text("我能查看誰喜歡了我嗎？")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 10)
                        
            Text("""
            你可以付費升級為 SwiftiDate Premium 或 Supreme，獲得「看看誰喜歡你」的特權，查看在 SwiftiDate 上有哪些用戶喜歡了你，並可以直接與她/他們配對。SwiftiDate 還會每日為你精選出最受歡迎的用戶，快去試試你跟她/他們是否是吸引你的類型吧！
            """)
            .padding()

            Spacer()
        }
        .padding()
    }
}

// Preview for WhoLikedMeView
struct WhoLikedMeView_Previews: PreviewProvider {
    @State static var isWhoLikedMeView = true // Provide a sample state variable for the preview

    static var previews: some View {
        WhoLikedMeView(isWhoLikedMeView: $isWhoLikedMeView) // Use the binding variable in the preview
    }
}
