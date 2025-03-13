//
//  HowToUseIncognitoModeView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import SwiftUI

struct HowToUseIncognitoModeView: View {
    @Binding var isHowToUseIncognitoModeView: Bool // Binding to control the dismissal of HowToUseIncognitoModeView

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isHowToUseIncognitoModeView = false // Dismiss HowToUseIncognitoModeView and return to HelpView
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
                    // Detailed content of HowToUseIncognitoModeView
                    Text("如何使用「隱身模式」功能？")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("""
                    如果你想要在 SwiftiDate 中隱藏自己，讓只有你喜歡過的人能看到你的卡片，請按照以下步驟開啟隱身模式：

                    1. 點擊主界面右上角的控制板圖示，進入「篩選」界面。
                    2. 在「篩選」界面中，找到「隱私設定」部分。
                    3. 開啟「隱身模式」選項，即可隱藏自己的卡片。這樣一來，只有你主動右滑過的用戶才能看到你，其他用戶將無法看到你的卡片。

                    **注意：** 開啟隱身模式後，你的曝光率會降低，因此建議你積極主動地右滑自己感興趣的用戶，以增加配對的機會。
                    """)
                    .padding()
                }
            }
        }
        .padding()
    }
}

// Preview for HowToUseIncognitoModeView
struct HowToUseIncognitoModeView_Previews: PreviewProvider {
    @State static var isHowToUseIncognitoModeView = true // Provide a sample state variable for the preview

    static var previews: some View {
        HowToUseIncognitoModeView(isHowToUseIncognitoModeView: $isHowToUseIncognitoModeView) // Use the binding variable in the preview
    }
}
