//
//  HowToUseAdvancedFilteringView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import SwiftUI

struct HowToUseAdvancedFilteringView: View {
    @Binding var isHowToUseAdvancedFilteringView: Bool // Binding to control the dismissal of HowToUseAdvancedFilteringView

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isHowToUseAdvancedFilteringView = false // Dismiss HowToUseAdvancedFilteringView and return to HelpView
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
                    // Detailed content of HowToUseAdvancedFilteringView
                    Text("如何使用「高級篩選」功能？")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("""
                    想要更精準地找到符合你喜好的對象嗎？「高級篩選」功能可以幫助你！

                    1. 首先，打開 SwiftiDate App 並進入滑卡頁面。
                    2. 在滑卡頁面最上方，點擊 SwiftiDate 旁邊的「定製」按鈕，進入篩選頁面。
                    3. 在篩選頁面中，點擊「高級篩選」按鈕，即可進入自訂頁面。
                    4. 在自訂頁面中，你可以根據自己的喜好設定篩選標準，包括身高、學歷、交友目的、生活風格等條件。
                    5. 完成篩選設定後，點擊「確定」或「完成」按鈕，你的高級篩選設定將會生效，滑卡頁面將根據你的設定篩選出符合條件的用戶。

                    使用高級篩選功能，可以更精準地找到符合你期待的對象，提升你的配對成功率。趕快試試看吧！
                    """)
                    .padding()
                }
            }
        }
        .padding()
    }
}

// Preview for HowToUseAdvancedFilteringView
struct HowToUseAdvancedFilteringView_Previews: PreviewProvider {
    @State static var isHowToUseAdvancedFilteringView = true // Provide a sample state variable for the preview

    static var previews: some View {
        HowToUseAdvancedFilteringView(isHowToUseAdvancedFilteringView: $isHowToUseAdvancedFilteringView) // Use the binding variable in the preview
    }
}
