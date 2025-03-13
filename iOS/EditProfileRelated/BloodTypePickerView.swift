//
//  BloodTypePickerView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/8/20.
//

import Foundation
import SwiftUI

struct BloodTypePickerView: View {
    @Binding var selectedBloodType: String?
    @Environment(\.presentationMode) var presentationMode // 用于控制视图的关闭

    let bloodTypes = ["A型", "B型", "AB型", "O型", "其他血型"]

    var body: some View {
        VStack {
            Text("你的血型是？")
                .font(.headline)
                .padding()

            ForEach(bloodTypes, id: \.self) { bloodType in
                Button(action: {
                    selectedBloodType = bloodType
                    // 埋點：選擇血型
                    AnalyticsManager.shared.trackEvent("blood_type_selected", parameters: [
                        "blood_type": bloodType
                    ])
                    presentationMode.wrappedValue.dismiss() // 选择后关闭页面
                }) {
                    HStack {
                        Text(bloodType)
                            .foregroundColor(selectedBloodType == bloodType ? .white : .primary)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedBloodType == bloodType ? Color.green : Color.clear)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }

            Spacer()

            HStack {
                Button(action: {
                    selectedBloodType = nil // 清空输入
                    AnalyticsManager.shared.trackEvent("blood_type_cleared")
                }) {
                    Text("清空")
                        .foregroundColor(.primary)
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(10)
                }
                Spacer()
                Button(action: {
                    AnalyticsManager.shared.trackEvent("blood_type_confirmed", parameters: [
                        "blood_type": selectedBloodType ?? "none"
                    ])
                    presentationMode.wrappedValue.dismiss() // 关闭页面
                }) {
                    Text("确定")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .padding()
        .onAppear {
            // 埋點：頁面曝光
            AnalyticsManager.shared.trackEvent("blood_type_picker_view_appear")
        }
    }
}
