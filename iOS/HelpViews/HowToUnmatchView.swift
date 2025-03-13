//
//  HowToUnmatchView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import Foundation
import SwiftUI

struct HowToUnmatchView: View {
    @Binding var isHowToUnmatch: Bool // Binding to control the dismissal of HowToUnmatchView

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isHowToUnmatch = false // Dismiss HowToUnmatchView and return to HelpView
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
            
            // Detailed content of HowToUnmatchView
            Text("如何解除配對？")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            Text("""
            點擊主界面下方的聊天氣泡💬 按鈕進入「聊天」界面，然後：

            1. 點擊你要解除配對的人進入聊天界面；在聊天介面點擊右上角的三點按鈕 ···，選擇「解除配對」，即可徹底刪除該好友。

            2. 也可以在聊天列表頁中你要解除配對的人那裡左滑，選擇「解除配對」，即可徹底刪除該好友。

            注意：解除配對後不可恢復，如果你還想重新找回好友，可以升級成 SwiftiDate Premium，去找回已經解除的配對。
            """)
            .padding()
            
            Spacer()
        }
        .padding()
    }
}

// Preview for HowToUnmatchView
struct HowToUnmatchView_Previews: PreviewProvider {
    @State static var isHowToUnmatch = true // Provide a sample state variable for the preview

    static var previews: some View {
        HowToUnmatchView(isHowToUnmatch: $isHowToUnmatch) // Use the binding variable in the preview
    }
}
