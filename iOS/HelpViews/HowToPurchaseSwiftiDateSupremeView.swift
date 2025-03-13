//
//  HowToPurchaseSwiftiDateSupremeView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import SwiftUI

struct HowToPurchaseSwiftiDateSupremeView: View {
    @Binding var isHowToPurchaseSwiftiDateSupremeView: Bool // Binding to control the dismissal of HowToPurchaseSwiftiDateSupremeView

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isHowToPurchaseSwiftiDateSupremeView = false // Dismiss HowToPurchaseSwiftiDateSupremeView and return to the previous view
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
                    // Detailed content of HowToPurchaseSwiftiDateSupremeView
                    Text("如何購買 SwiftiDate Supreme？")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("""
                    若您希望升級為 SwiftiDate Supreme 尊貴用戶，請按照以下步驟操作：

                    1. 點擊主界面下方的人物👤按鈕，進入「個人資料」界面，找到並點擊黑色的「SwiftiDate Supreme」方塊。

                    2. 在彈出的 SwiftiDate Supreme 購買頁面，選擇您希望的訂閱類型，包含【1個月】、【3個月】、或【12個月】的選項。

                    3. 選擇好訂閱方案後，點擊「繼續」按鈕。

                    4. 完成付款操作後，您的 SwiftiDate Supreme 特權將立即生效，您將成為尊貴的 SwiftiDate Supreme 用戶，享受更多專屬功能與優待。

                    如果您在購買過程中遇到任何問題，請隨時聯繫 SwiftiDate 客服，我們將為您提供協助。
                    """)
                    .padding()
                }
            }
        }
        .padding()
    }
}

// Preview for HowToPurchaseSwiftiDateSupremeView
struct HowToPurchaseSwiftiDateSupremeView_Previews: PreviewProvider {
    @State static var isHowToPurchaseSwiftiDateSupremeView = true // Provide a sample state variable for the preview

    static var previews: some View {
        HowToPurchaseSwiftiDateSupremeView(isHowToPurchaseSwiftiDateSupremeView: $isHowToPurchaseSwiftiDateSupremeView) // Use the binding variable in the preview
    }
}
