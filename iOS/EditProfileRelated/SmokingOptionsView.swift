//
//  SmokingOptionsView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/8/20.
//

import Foundation
import SwiftUI

struct SmokingOptionsView: View {
    @Binding var selectedSmokingOption: String?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("你抽煙嗎？")
                .font(.headline)
                .padding()
            
            // List of smoking options
            ForEach(["只在社交場合", "在喝酒時抽煙", "不抽煙", "經常", "有時候"], id: \.self) { option in
                Button(action: {
                    selectedSmokingOption = option
                    AnalyticsManager.shared.trackEvent("smoking_option_selected", parameters: [
                        "option": option
                    ])
                }) {
                    Text(option)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedSmokingOption == option ? Color.green : Color.clear)
                        .foregroundColor(selectedSmokingOption == option ? .white : .primary)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            // Clear and Confirm buttons
            HStack {
                Button(action: {
                    selectedSmokingOption = nil // Clear the selection
                    AnalyticsManager.shared.trackEvent("smoking_option_cleared")
                }) {
                    Text("清空")
                        .foregroundColor(.primary)
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(10)
                }
                Spacer()
                Button(action: {
                    AnalyticsManager.shared.trackEvent("smoking_option_confirmed", parameters: [
                        "option": selectedSmokingOption ?? "none"
                    ])
                    presentationMode.wrappedValue.dismiss() // Dismiss the view
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
