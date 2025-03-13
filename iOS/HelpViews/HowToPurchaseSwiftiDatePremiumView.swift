//
//  HowToPurchaseSwiftiDatePremiumView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import Foundation
import SwiftUI

struct HowToPurchaseSwiftiDatePremiumView: View {
    @Binding var isHowToPurchaseSwiftiDatePremium: Bool // Binding to control the dismissal of HowToPurchaseSwiftiDatePremiumView

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isHowToPurchaseSwiftiDatePremium = false // Dismiss HowToPurchaseSwiftiDatePremiumView and return to HelpView
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
                    // Detailed content of HowToPurchaseSwiftiDatePremiumView
                    Text("如何購買 SwiftiDate Premium？")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("""
                    1. 點擊主界面下方的人物👤 進入「個人資料」界面，點擊黃色的 SwiftiDate Premium 方塊；
                    
                    2. 在彈出的 SwiftiDate Premium 購買頁面選擇【1/3/12個月】的會員類型；
                    
                    3. 點擊「繼續」按鈕；
                    
                    4. 支付成功後即完成 SwiftiDate Premium 的購買，成為尊貴的 SwiftiDate Premium 用戶。
                    """)
                    .padding()
                    .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

// Preview for HowToPurchaseSwiftiDatePremiumView
struct HowToPurchaseSwiftiDatePremiumView_Previews: PreviewProvider {
    @State static var isHowToPurchaseSwiftiDatePremium = true // Provide a sample state variable for the preview

    static var previews: some View {
        HowToPurchaseSwiftiDatePremiumView(isHowToPurchaseSwiftiDatePremium: $isHowToPurchaseSwiftiDatePremium) // Use the binding variable in the preview
    }
}
