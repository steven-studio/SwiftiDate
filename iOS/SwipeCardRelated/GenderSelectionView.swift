//
//  GenderSelectionView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/11.
//

import SwiftUI

struct GenderSelectionView: View {
    @Binding var selectedGender: String
    @Binding var showGenderSelection: Bool // 控制返回

    var body: some View {
        VStack {
            // 標題
            ZStack {
                // 返回按鈕，放在左側
                HStack {
                    Button(action: {
                        // 點擊返回時也記錄事件
                        AnalyticsManager.shared.trackEvent("GenderSelection_BackTapped", parameters: nil)
                        showGenderSelection = false // 返回到上一頁
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.gray)
                            .padding()
                    }
                    .accessibility(identifier: "backButton")  // <-- 加上這行
                    Spacer() // 用 Spacer 把按鈕推到左側
                }
                
                // 中間的標題
                Text("篩選")
                    .font(.title2)
            }
            .frame(maxWidth: .infinity) // 讓ZStack佔滿整個寬度
            
            HStack {
                Text("女生")
                Spacer()
                if selectedGender == "女生" {
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                }
            }
            .padding()
            .onTapGesture {
                selectedGender = "女生"
                AnalyticsManager.shared.trackEvent("GenderSelected", parameters: ["gender": "女生"])
            }

            HStack {
                Text("男生")
                Spacer()
                if selectedGender == "男生" {
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                }
            }
            .padding()
            .onTapGesture {
                selectedGender = "男生"
                AnalyticsManager.shared.trackEvent("GenderSelected", parameters: ["gender": "男生"])
            }

            HStack {
                Text("不限")
                Spacer()
                if selectedGender == "不限" {
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                }
            }
            .padding()
            .onTapGesture {
                selectedGender = "不限"
                AnalyticsManager.shared.trackEvent("GenderSelected", parameters: ["gender": "不限"])
            }
            
            HStack {
                Text("不想滑")
                Spacer()
                if selectedGender == "不想滑" {
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                }
            }
            .padding()
            .onTapGesture {
                selectedGender = "不想滑"
                AnalyticsManager.shared.trackEvent("GenderSelected", parameters: ["gender": "不想滑"])
            }
            
            Spacer() // 使用 Spacer 將所有元素推至頂部
        }
    }
}

// 增加預覽
struct GenderSelectionView_Previews: PreviewProvider {
    @State static var selectedGender = "女生" // 預設的性別選擇
    @State static var showGenderSelection = true // 控制頁面顯示
    
    static var previews: some View {
        GenderSelectionView(selectedGender: $selectedGender, showGenderSelection: $showGenderSelection)
    }
}
