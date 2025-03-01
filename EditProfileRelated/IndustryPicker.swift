//
//  IndustryPicker.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/8/19.
//

import Foundation
import SwiftUI

struct IndustryPicker: View {
    @Binding var selectedIndustry: String?
    let industries: [String]

    var body: some View {
        VStack {
            Text("你的工作行業是？")
                .font(.headline)
                .padding()

            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 10)]) {
                    ForEach(industries, id: \.self) { industry in
                        Button(action: {
                            selectedIndustry = industry
                            // 埋點：使用者選擇了某個行業
                            AnalyticsManager.shared.trackEvent("industry_selected", parameters: [
                                "industry": industry
                            ])
                        }) {
                            Text(industry)
                                .foregroundColor(selectedIndustry == industry ? .white : .primary)
                                .padding()
                                .background(selectedIndustry == industry ? Color.green : Color.clear)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)
            }

            Spacer()

            HStack {
                Button(action: {
                    selectedIndustry = nil // 清空选择
                    // 埋點：清空行業選擇
                    AnalyticsManager.shared.trackEvent("industry_cleared")
                }) {
                    Text("清空")
                        .foregroundColor(.primary)
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(10)
                }
                .padding(.leading)

                Spacer()
            }
            .padding(.bottom)
        }
        .padding()
        .onAppear {
            // 埋點：頁面曝光
            AnalyticsManager.shared.trackEvent("industry_picker_view_appear")
        }
    }
}
