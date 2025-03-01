//
//  BasicInfoView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/16.
//

import Foundation
import SwiftUI

struct BasicInfoRowView<Icon: View>: View {
    let label: String
    let value: String?
    let icon: Icon
    let isValueEmpty: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            icon
                .foregroundColor(.gray)
            Text(label)
                .font(.headline)
            Spacer()
            Text(isValueEmpty ? "新增" : value ?? "")
                .font(.subheadline)
                .foregroundColor(isValueEmpty ? .green : .gray)
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .onTapGesture {
            onTap()
        }
    }
}

struct BasicInfoView: View {
    @Binding var selectedHometown: String?
    @Binding var showHometownInput: Bool
    @Binding var selectedLanguages: [String]
    @Binding var showLanguageSelection: Bool
    @Binding var selectedHeight: Int?
    @Binding var showHeightPicker: Bool
    @Binding var selectedZodiac: String
    @Binding var showZodiacPicker: Bool
    @Binding var selectedBloodType: String?
    @Binding var showBloodTypePicker: Bool
    
    var body: some View {
        // 基本資料
        VStack(alignment: .leading) {
            Text("基本資料")
                .font(.headline)
                .padding(.bottom, 5)
            
            BasicInfoRowView(
                label: "來自",
                value: selectedHometown,
                icon: Image(systemName: "house.fill"),
                isValueEmpty: selectedHometown == nil,
                onTap: {
                    showHometownInput = true
                    AnalyticsManager.shared.trackEvent("tap_edit_hometown")
                }
            )
            .sheet(isPresented: $showHometownInput) {
                HometownInputView(selectedHometown: $selectedHometown)
            }
            
            BasicInfoRowView(
                label: "語言",
                value: selectedLanguages.joined(separator: ", "),
                icon: Image(systemName: "globe"),
                isValueEmpty: selectedLanguages.isEmpty,
                onTap: {
                    showLanguageSelection = true
                    AnalyticsManager.shared.trackEvent("tap_edit_language")
                }
            )
            .sheet(isPresented: $showLanguageSelection) {
                LanguageSelectionView(selectedLanguages: $selectedLanguages)
            }
            
            BasicInfoRowView(
                label: "身高",
                value: "\(selectedHeight ?? 170) cm",
                icon: Image(systemName: "ruler.fill"),
                isValueEmpty: selectedHeight == nil,
                onTap: {
                    showHeightPicker = true
                    AnalyticsManager.shared.trackEvent("tap_edit_height")
                }
            )
            .sheet(isPresented: $showHeightPicker) {
                HeightPickerView(selectedHeight: $selectedHeight)
            }
            
            BasicInfoRowView(
                label: "星座",
                value: selectedZodiac,
                icon: Image("zodiac_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24), // Adjust size as needed
                isValueEmpty: selectedZodiac.isEmpty,
                onTap: {
                    showZodiacPicker = true
                    AnalyticsManager.shared.trackEvent("tap_edit_zodiac")
                }
            )
            .sheet(isPresented: $showZodiacPicker) {
                ZodiacPickerView(selectedZodiac: $selectedZodiac)
            }
            
            BasicInfoRowView(
                label: "血型",
                value: selectedBloodType ?? "新增",
                icon: Image("blood_type_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24), // 调整大小以适应你的设计
                isValueEmpty: selectedBloodType == nil,
                onTap: {
                    showBloodTypePicker = true
                    AnalyticsManager.shared.trackEvent("tap_edit_blood_type")
                }
            )
            .sheet(isPresented: $showBloodTypePicker) {
                BloodTypePickerView(selectedBloodType: $selectedBloodType)
            }
        }
        .padding(.horizontal)
    }
}

struct BasicInfoView_Previews: PreviewProvider {
    @State static var mockSelectedHometown: String? = "台中"
    @State static var mockShowHometownInput = false
    @State static var mockSelectedLanguages: [String] = ["中文"]
    @State static var mockShowLanguageSelection = false
    @State static var mockSelectedHeight: Int? = 175
    @State static var mockShowHeightPicker = false
    @State static var mockSelectedZodiac = "巨蟹座"
    @State static var mockShowZodiacPicker = false
    @State static var mockSelectedBloodType: String? = "O型"
    @State static var mockShowBloodTypePicker = false

    static var previews: some View {
        BasicInfoView(
            selectedHometown: $mockSelectedHometown,
            showHometownInput: $mockShowHometownInput,
            selectedLanguages: $mockSelectedLanguages,
            showLanguageSelection: $mockShowLanguageSelection,
            selectedHeight: $mockSelectedHeight,
            showHeightPicker: $mockShowHeightPicker,
            selectedZodiac: $mockSelectedZodiac,
            showZodiacPicker: $mockShowZodiacPicker,
            selectedBloodType: $mockSelectedBloodType,
            showBloodTypePicker: $mockShowBloodTypePicker
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
