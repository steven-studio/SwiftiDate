//
//  HowToUseDailyPraiseOpportunityView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import SwiftUI

struct HowToUseDailyPraiseOpportunityView: View {
    @Binding var isHowToUseDailyPraiseOpportunityView: Bool // Binding to control the dismissal of HowToUseDailyPraiseOpportunityView

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isHowToUseDailyPraiseOpportunityView = false // Dismiss HowToUseDailyPraiseOpportunityView and return to HelpView
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
                    // Detailed content of HowToUseDailyPraiseOpportunityView
                    Text("如何使用「每日 3 次的讚美機會」功能？")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("""
                    點擊滑卡頁面中間的金色聊天氣泡💬 按鈕即完成讚美配對，接下來好好跟對方打個招呼吧！不打招呼的話配對會消失哦！
                    """)
                    .padding()
                }
            }
        }
        .padding()
    }
}

// Preview for HowToUseDailyPraiseOpportunityView
struct HowToUseDailyPraiseOpportunityView_Previews: PreviewProvider {
    @State static var isHowToUseDailyPraiseOpportunityView = true // Provide a sample state variable for the preview

    static var previews: some View {
        HowToUseDailyPraiseOpportunityView(isHowToUseDailyPraiseOpportunityView: $isHowToUseDailyPraiseOpportunityView) // Use the binding variable in the preview
    }
}
