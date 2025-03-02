//
//  ProfileTabPicker.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/17.
//

import Foundation
import SwiftUI

// 將切換選項的 Picker 提取到獨立的 View
struct ProfileTabPicker: View {
    @Binding var selectedTab: ProfileTab

    var body: some View {
        Picker("編輯個人資料", selection: $selectedTab) {
            Text(ProfileTab.edit.rawValue).tag(ProfileTab.edit)
            Text(ProfileTab.preview.rawValue).tag(ProfileTab.preview)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        .onChange(of: selectedTab) { newTab in
            print("ProfileTab changed to: \(newTab.rawValue)")
             AnalyticsManager.shared.trackEvent("profile_tab_changed", parameters: ["selected_tab": newTab.rawValue])
        }
        .onAppear {
             AnalyticsManager.shared.trackEvent("profile_tab_picker_view_appear")
        }
    }
}
