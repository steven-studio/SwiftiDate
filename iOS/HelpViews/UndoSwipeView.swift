//
//  UndoSwipeView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import Foundation
import SwiftUI

struct UndoSwipeView: View {
    @Binding var isUndoSwipeView: Bool // Binding to control the dismissal of UndoSwipeView

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isUndoSwipeView = false // Dismiss UndoSwipeView and return to HelpView
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
                    // Detailed content of UndoSwipeView
                    Text("滑錯如何反悔？")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("""
                    如果你不小心左滑(不喜歡)了你心動的對象，導致錯過了與她/他的配對，SwiftiDate Premium 的滑錯反悔功能可以幫助你修正這個小失誤～

                    只需要點擊滑卡頁面的金色旋轉箭頭↪️ 按鈕，錯過的她/他就會重回你的視野啦！

                    注意：只有訂閱了 SwiftiDate Premium 的用戶才可以使用滑錯反悔功能，因此若你希望享有這項特權，請升級為 Premium 會員！
                    """)
                    .padding()
                }
            }
        }
        .padding()
    }
}

// Preview for UndoSwipeView
struct UndoSwipeView_Previews: PreviewProvider {
    @State static var isUndoSwipeView = true // Provide a sample state variable for the preview

    static var previews: some View {
        UndoSwipeView(isUndoSwipeView: $isUndoSwipeView) // Use the binding variable in the preview
    }
}
