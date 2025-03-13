//
//  HeightPickerView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/8/20.
//

import Foundation
import SwiftUI

struct HeightPickerView: View {
    @Binding var selectedHeight: Int?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("你的身高是？")
                .font(.headline)
                .padding()
            
            Spacer()

            Picker(selection: Binding(
                get: { selectedHeight ?? 170 },
                set: { selectedHeight = $0 }
            ), label: Text("選擇你的身高")) {
                ForEach(140..<220) { height in
                    Text("\(height) cm").tag(height)
                }
            }
            .labelsHidden()
            .pickerStyle(WheelPickerStyle())
            
            HStack {
                Button(action: {
                    selectedHeight = nil // 清空选择
                }) {
                    Text("清空")
                        .foregroundColor(.primary)
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(10)
                }
                Spacer()
                Button(action: {
                    AnalyticsManager.shared.trackEvent("update_height", parameters: [
                        "height": selectedHeight ?? 0
                    ])
                    presentationMode.wrappedValue.dismiss() // 关闭页面
                }) {
                    Text("確定")
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
    }
}
