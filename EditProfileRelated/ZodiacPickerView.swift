//
//  ZodiacPickerView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/8/20.
//

import Foundation
import SwiftUI

struct ZodiacPickerView: View {
    @Binding var selectedZodiac: String
    @Environment(\.presentationMode) var presentationMode

    let zodiacSigns = [
        ("牡羊座", "aries"),
        ("金牛座", "taurus"),
        ("雙子座", "gemini"),
        ("巨蟹座", "cancer"),
        ("獅子座", "leo"),
        ("處女座", "virgo"),
        ("天秤座", "libra"),
        ("天蠍座", "scorpio"),
        ("射手座", "sagittarius"),
        ("摩羯座", "capricorn"),
        ("水瓶座", "aquarius"),
        ("雙魚座", "pisces")
    ]

    var body: some View {
        VStack {
            Text("你的星座是？")
                .font(.headline)
                .padding()

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                ForEach(zodiacSigns, id: \.0) { zodiac, imageName in
                    Button(action: {
                        // 埋點：使用者選擇了某個星座
                        AnalyticsManager.shared.trackEvent("zodiac_selected", parameters: [
                            "zodiac": zodiac
                        ])
                        selectedZodiac = zodiac
                        presentationMode.wrappedValue.dismiss() // 选择后关闭页面
                    }) {
                        VStack {
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                            Text(zodiac)
                                .font(.caption)
                        }
                        .padding()
                        .background(selectedZodiac == zodiac ? Color.green.opacity(0.2) : Color.clear)
                        .cornerRadius(10)
                    }
                }
            }
            .padding()

            Spacer()

            HStack {
                Button(action: {
                    AnalyticsManager.shared.trackEvent("zodiac_cleared")
                    selectedZodiac = ""
                    presentationMode.wrappedValue.dismiss() // 清空选择后关闭页面
                }) {
                    Text("清空")
                        .foregroundColor(.primary)
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(10)
                }

                Spacer()

                Button(action: {
                    AnalyticsManager.shared.trackEvent("zodiac_picker_confirm")
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
        .onAppear {
            AnalyticsManager.shared.trackEvent("zodiac_picker_view_appear")
        }
    }
}
