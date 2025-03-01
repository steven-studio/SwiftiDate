//
//  TopRightActionButtons.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/17.
//

import Foundation
import SwiftUI

struct TopRightActionButtons: View {
    @Binding var showSettingsView: Bool
    @Binding var showSafetyCenterView: Bool
//    @Binding var showHealthDataSectionView: Bool
    
    var body: some View {
        // Gear icon in the top-right corner
        VStack {
            HStack {
                Spacer()
                
                // 將 shield.fill 圖標放入 Button
                Button(action: {
                    AnalyticsManager.shared.trackEvent("top_right_safety_center_pressed")
                    showSafetyCenterView = true
                }) {
                    Image(systemName: "shield.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.gray) // Set the color to match the design
                        .padding(.trailing, 10)
                }
                
                Button(action: {
                    AnalyticsManager.shared.trackEvent("top_right_settings_pressed")
                    showSettingsView = true
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                        .padding()
                        .foregroundColor(.gray)
                }
                
//                Button(action: {
//                    showHealthDataSectionView = true
//                }) {
//                    Image(systemName: "figure.walk")
//                        .font(.title2)
//                        .padding()
//                        .foregroundColor(.gray)
//                }
            }
            Spacer()
        }
    }
}
