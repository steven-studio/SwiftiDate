//
//  LookingForView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/8/20.
//

import Foundation
import SwiftUI

struct LookingForView: View {
    @Binding var selectedLookingFor: String?
    @Environment(\.presentationMode) var presentationMode // 用于控制视图的关闭
    
    let options = [
        "終身伴侶",
        "穩定的關係",
        "穩定關係，也接受短期約會",
        "短暫的約會",
        "短期約會，也接受穩定關係",
        "可以聊天的朋友",
        "還沒決定"
    ]
    
    var body: some View {
        VStack {
            Text("你在尋找...？")
                .font(.headline)
                .padding()
            
            ForEach(options, id: \.self) { option in
                Button(action: {
                    selectedLookingFor = option
                    // 埋點：用戶選擇了某個尋找選項
                    AnalyticsManager.shared.trackEvent("lookingfor_option_selected", parameters: [
                        "option": option
                    ])
                    presentationMode.wrappedValue.dismiss() // 选择后关闭页面
                }) {
                    HStack {
                        Text(option)
                            .foregroundColor(selectedLookingFor == option ? .white : .primary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if selectedLookingFor == option {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.white)
                        }
                    }
                    .background(selectedLookingFor == option ? Color.green : Color.clear)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            HStack {
                Button(action: {
                    selectedLookingFor = nil // 清空选择
                    // 埋點：用戶清空尋找選項
                    AnalyticsManager.shared.trackEvent("lookingfor_cleared")
                    presentationMode.wrappedValue.dismiss() // 关闭页面
                }) {
                    Text("清空")
                        .foregroundColor(.primary)
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(10)
                }
                Spacer()
                Button(action: {
                    // 埋點：用戶確認尋找選項
                    AnalyticsManager.shared.trackEvent("lookingfor_confirmed", parameters: [
                        "selected": selectedLookingFor ?? "none"
                    ])
                    presentationMode.wrappedValue.dismiss() // 确定并关闭页面
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
        .onAppear {
            // 埋點：頁面曝光
            AnalyticsManager.shared.trackEvent("lookingfor_view_appear")
        }
    }
}
