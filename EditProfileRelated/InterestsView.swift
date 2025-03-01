//
//  InterestsView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/8/18.
//

import Foundation
import SwiftUI

struct InterestsView: View {
    let interests: [String]
    @Binding var selectedInterests: Set<String>  // 傳遞已選擇的興趣
    @Binding var interestColors: [String: Color]  // 改為 @Binding
    @State private var showInterestSelection = false // 控制 sheet 的狀態

    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10),  // 第一列
        GridItem(.flexible(), spacing: 10)   // 第二列
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // 把 "興趣" Title 放在白色框框外
            Text("興趣")
                .font(.headline)
                .padding(.bottom, 5)
                .padding(.horizontal) // 添加水平间距，使标题与内容对齐

            // 使用 TapGesture 來顯示 Sheet 視圖
            VStack {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(interests, id: \.self) { interest in
                        Text(interest)
                            .font(.subheadline)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            // 使用 interestColors 來設置背景顏色
                            .background(interestColors[interest]?.opacity(0.2) ?? Color.gray.opacity(0.2)) // 預設顏色為灰色，透明度0.2
                            .cornerRadius(20)
                            .foregroundColor(.black) // 確保文字顏色不會變
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // 我的標籤
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "tag.fill")
                            .foregroundColor(.gray)
                        Text("我的標籤")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("新增")
                            .font(.headline)
                            .foregroundColor(.green)
                        Image(systemName: "chevron.right") // 添加向右的箭头
                            .foregroundColor(.gray)
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                }
                .padding()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
            .padding(.horizontal)
            .onTapGesture {
                showInterestSelection = true // 點擊時顯示 sheet
                // 埋點：使用者點擊興趣區以打開選擇頁面
                AnalyticsManager.shared.trackEvent("interest_selection_sheet_opened")
            }
            .sheet(isPresented: $showInterestSelection) {
                InterestSelectionView(selectedInterests: $selectedInterests, interestColors: $interestColors) // 彈出的視圖
            }
            .onAppear {
                // 埋點：頁面曝光，記錄使用者何時進入 InterestsView
                AnalyticsManager.shared.trackEvent("interests_view_appear")
            }
        }
        .padding(.horizontal)
    }
}

struct InterestsView_Previews: PreviewProvider {
    @State static var selectedInterests: Set<String> = ["閱讀", "運動", "音樂"]
    @State static var interestColors: [String: Color] = [
        "閱讀": .blue,
        "運動": .green,
        "音樂": .orange
    ]

    static var previews: some View {
        InterestsView(
            interests: ["閱讀", "運動", "音樂", "旅行", "攝影", "美食"],
            selectedInterests: $selectedInterests,
            interestColors: $interestColors
        )
    }
}
