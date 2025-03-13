//
//  HowToUseWhoLikedMeAndCrushListView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import Foundation
import SwiftUI

struct HowToUseWhoLikedMeAndCrushListView: View {
    @Binding var isHowToUseWhoLikedMeAndCrushListView: Bool // Binding to control the dismissal of HowToUseWhoLikedMeAndCrushListView

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isHowToUseWhoLikedMeAndCrushListView = false // Dismiss HowToUseWhoLikedMeAndCrushListView and return to HelpView
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
                    // Detailed content of HowToUseWhoLikedMeAndCrushListView
                    Text("如何使用「看看誰喜歡你」與「開啟心動列表」功能？")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("""
                    購買了 SwiftiDate Premium 的用戶，可以直接查看喜歡了自己的用戶。你可以點擊主界面下方的星星✨ 按鈕進入「看看誰喜歡你」界面，查看已經喜歡了你的用戶。對於這些用戶，左滑後將永久消失，右滑則直接配對。

                    **請注意，列表中顯示的用戶不包括：**
                    
                    - 已配對的用戶
                    - 照片未通過審核的用戶
                    - 被封鎖的用戶
                    - 已註銷的用戶
                    - 不符合你搜索性別和年齡的用戶

                    同樣的，在這個界面也可以選擇「我喜歡的人」選項卡，查看你右滑過的人。 發送 Crush 可以讓你們的邂逅機率提高 5 倍哦！
                    """)
                    .padding()
                }
            }
        }
        .padding()
    }
}

// Preview for HowToUseWhoLikedMeAndCrushListView
struct HowToUseWhoLikedMeAndCrushListView_Previews: PreviewProvider {
    @State static var isHowToUseWhoLikedMeAndCrushListView = true // Provide a sample state variable for the preview

    static var previews: some View {
        HowToUseWhoLikedMeAndCrushListView(isHowToUseWhoLikedMeAndCrushListView: $isHowToUseWhoLikedMeAndCrushListView) // Use the binding variable in the preview
    }
}
