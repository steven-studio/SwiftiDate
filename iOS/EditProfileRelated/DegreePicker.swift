//
//  DegreePicker.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/8/18.
//

import Foundation
import SwiftUI

struct DegreePicker: View {
    // 原本的 @Binding 屬性維持不變
    var analyticsManager: AnalyticsManagerProtocol = AnalyticsManager.shared
    
    @Binding var selectedDegree: String?
    let degrees: [String]

    @Environment(\.presentationMode) var presentationMode  // 用于关闭 sheet
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // 埋點：點擊右上角的關閉按鈕
                    analyticsManager.trackEvent("degree_picker_dismissed", parameters: nil)
                    presentationMode.wrappedValue.dismiss()  // 点击关闭按钮时关闭 sheet
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                        .padding()
                }
                Spacer()
            }
            
            Text("你的教育程度是？")
                .font(.headline)
                .padding()

            ForEach(degrees, id: \.self) { degree in
                Button(action: {
                    selectedDegree = degree
                    // 埋點：使用者選擇學歷
                    analyticsManager.trackEvent("degree_selected", parameters: [
                        "degree": degree
                    ])
                }) {
                    Text(degree)
                        .foregroundColor(selectedDegree == degree ? .white : .primary)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedDegree == degree ? Color.green : Color.clear)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }

            Spacer()

            HStack {
                Button(action: {
                    selectedDegree = nil
                    // 埋點：使用者點擊取消 (清空)
                    analyticsManager.trackEvent("degree_selection_canceled", parameters: nil)
                }) {
                    Text("取消")
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
            analyticsManager.trackEvent("degree_picker_view_appear", parameters: nil)
        }
    }
}

struct DegreePicker_Previews: PreviewProvider {
    static var previews: some View {
        DegreePicker(selectedDegree: .constant(nil), degrees: ["高中", "職校/專科", "學士", "碩士及以上", "其他學歷"])
    }
}
