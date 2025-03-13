//
//  RegisterLanguageSelectionView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/4.
//

import Foundation
import SwiftUI

struct RegisterLanguageSelectionView: View {
    // 所有可供選擇的語言
    let allLanguages = ["English", "ภาษาไทย", "Bahasa Melayu", "Bahasa Indonesia", "中文", "廣東語", "閩南語"]
    
    // 使用者已選擇的語言（多選），可用 Set<String> 方便判斷
    @State private var selectedLanguages: Set<String> = []
    
    var body: some View {
        VStack {
            // 頂部略過按鈕
            HStack {
                Spacer()
                Button("略過") {
                    // 略過行為：可以跳過或記錄事件
                    print("使用者點擊略過")
                }
                .padding(.trailing, 20)
            }
            .padding(.top, 10)
            
            // 標題
            Text("你會說哪些語言？")
                .font(.title2)
                .bold()
                .padding(.top, 10)
            
            // 語言列表
            // 可用 ScrollView + ForEach，或 List 都行
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(allLanguages, id: \.self) { language in
                        languageRow(language: language)
                        Divider()
                    }
                }
                .padding(.horizontal, 20)
                .background(Color.white)
            }
            .padding(.top, 10)
            
            Spacer()
            
            // 「繼續」按鈕
            Button(action: {
                // 按下繼續的行為
                print("已選語言：\(selectedLanguages)")
                // 例如：跳轉頁面、儲存到後端等
            }) {
                Text("繼續")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isValid ? Color.green : Color.gray)
                    .cornerRadius(25)
                    .padding(.horizontal, 40)
            }
            .disabled(!isValid)
            .padding(.bottom, 30)
        }
        .padding(.top, 10)
    }
    
    // 是否有選擇至少一種語言
    private var isValid: Bool {
        !selectedLanguages.isEmpty
    }
    
    // MARK: - 單一語言的 Row
    @ViewBuilder
    private func languageRow(language: String) -> some View {
        HStack {
            Text(language)
                .font(.body)
            
            Spacer()
            
            // 如果有選到，就顯示一個核取圖示
            if selectedLanguages.contains(language) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else {
                // 可留空，或顯示灰色圈圈
                Image(systemName: "circle")
                    .foregroundColor(.gray.opacity(0.3))
            }
        }
        .contentShape(Rectangle()) // 讓整個列可點擊
        .onTapGesture {
            // 切換選取狀態
            if selectedLanguages.contains(language) {
                selectedLanguages.remove(language)
            } else {
                selectedLanguages.insert(language)
            }
        }
        .frame(height: 50)
    }
}

struct RegisterLanguageSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterLanguageSelectionView()
    }
}
