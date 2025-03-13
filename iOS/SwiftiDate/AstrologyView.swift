//
//  AstrologyView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/1/31.
//

import Foundation
import SwiftUI

struct AstrologyView: View {
    let zodiacSigns = [
        "♈️ 牡羊座", "♉️ 金牛座", "♊️ 雙子座", "♋️ 巨蟹座",
        "♌️ 獅子座", "♍️ 處女座", "♎️ 天秤座", "♏️ 天蠍座",
        "♐️ 射手座", "♑️ 摩羯座", "♒️ 水瓶座", "♓️ 雙魚座"
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("🔮 今日星座運勢")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)

                // 每個星座顯示當日運勢
                ForEach(zodiacSigns, id: \.self) { sign in
                    VStack(alignment: .leading) {
                        Text(sign)
                            .font(.headline)
                            .foregroundColor(.purple)
                        Text("✨ 今日幸運指數：\(Int.random(in: 50...100))%")
                        Text("💡 感情運：適合認識新朋友，試著打開心扉！")
                        Text("🎭 事業運：適合嘗試新的挑戰，今天充滿機會！")
                    }
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(10)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("星座占卜")
    }
}

struct AstrologyView_Previews: PreviewProvider {
    static var previews: some View {
        AstrologyView()
    }
}
