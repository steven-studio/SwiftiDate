//
//  LanguageSelectionView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/8/20.
//

import Foundation
import SwiftUI

struct LanguageSelectionView: View {
    @Binding var selectedLanguages: [String] // 绑定到已选择的语言数组
    let allLanguages = [
        "English",
        "ภาษาไทย",
        "Bahasa Melayu",
        "Bahasa Indonesia",
        "中文",
        "粵語",
        "閩南語",
        "客家話",
        "Русский", // 俄語
        "සිංහල", // 僧伽羅語
        "हिन्दी", // 印地語
        "ગુજરાતી", // 古吉拉特語
        "Türkçe", // 土耳其語
        "বাংলা", // 孟加拉語
        "Bisaya", // 比萨亚语
        "नेपाली", // 尼泊尔语
        "עברית", // 希伯来语
        "Ελληνικά", // 希腊语
        "Deutsch", // 德语
        "Italiano", // 意大利语
        "Kiswahili", // 斯瓦希里语
        "ਪੰਜਾਬੀ", // 旁遮普语
        "日本語", // 日语
        "संस्कृतम्", // 梵语
        "Français", // 法语
        "فارسی", // 波斯语
        "తెలుగు", // 泰卢固语
        "தமிழ்", // 泰米尔语
        "Basa Jawa", // 爪哇语
        "မြန်မာဘာသာ", // 缅甸语
        "ພາສາລາວ", // 老挝语
        "Filipino", // 菲律宾语
        "Português", // 葡萄牙语
        "Монгол", // 蒙古语
        "Español", // 西班牙语
        "Tiếng Việt", // 越南语
        "العربية", // 阿拉伯语
        "অসমীয়া", // 阿萨姆语
        "한국어", // 韩语
        "मराठी", // 马拉地语
        "ភាសាខ្មែរ"  // 高棉语
    ]

    var body: some View {
        VStack {
            Text("你會說哪些語言？")
                .font(.headline)
                .padding()

            List(allLanguages, id: \.self) { language in
                HStack {
                    Text(language)
                    Spacer()
                    if selectedLanguages.contains(language) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.gray)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if let index = selectedLanguages.firstIndex(of: language) {
                        selectedLanguages.remove(at: index)
                        // 埋點：取消選中語言
                        AnalyticsManager.shared.trackEvent("language_deselected", parameters: [
                            "language": language
                        ])
                    } else {
                        selectedLanguages.append(language)
                        // 埋點：選中語言
                        AnalyticsManager.shared.trackEvent("language_selected", parameters: [
                            "language": language
                        ])
                    }
                }
            }
            .listStyle(PlainListStyle())
            
            Spacer()

            HStack {
                Button("清空") {
                    selectedLanguages.removeAll() // 清空所有选择
                    // 埋點：清空所有語言選擇
                    AnalyticsManager.shared.trackEvent("languages_cleared")
                }
                .padding()
                
                Spacer()
                
                Button("確定") {
                    // 埋點：確認語言選擇，並傳入選中數量
                    AnalyticsManager.shared.trackEvent("languages_confirmed", parameters: [
                        "selected_count": selectedLanguages.count
                    ])
                    // 关闭语言选择界面
                    if let windowScene = UIApplication.shared.connectedScenes
                        .filter({ $0.activationState == .foregroundActive })
                        .first as? UIWindowScene,
                       let window = windowScene.windows.first {
                        
                        window.rootViewController?.dismiss(animated: true, completion: nil)
                    }
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .padding()
    }
}
