//
//  GenderSelectionView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/4.
//

import Foundation
import SwiftUI

enum GenderType: String {
    case male = "男生"
    case female = "女生"
    // 若想支援其他性別或自訂選項，可以在這裡新增
}

struct GenderSelectionView: View {
    @State private var selectedGender: GenderType? = nil
    @EnvironmentObject var userSettings: UserSettings  // 若需要儲存到全局設定
    
    var body: some View {
        VStack(spacing: 32) {
            // 標題
            Text("你是…")
                .font(.title)
                .padding(.top, 40)
            
            // 性別選擇區塊
            HStack(spacing: 40) {
                // 女生按鈕
                VStack {
                    // 圖示部分，可換成你自己的圖片資源
                    Image(selectedGender == .female ? "icon_female_selected" : "icon_female_unselected")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .onTapGesture {
                            selectedGender = .female
                        }
                    
                    Text("女生")
                        .font(.headline)
                }
                
                // 男生按鈕
                VStack {
                    Image(selectedGender == .male ? "icon_male_selected" : "icon_male_unselected")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .onTapGesture {
                            selectedGender = .male
                        }
                    
                    Text("男生")
                        .font(.headline)
                }
            }
            
            // 「繼續」按鈕
            Button(action: {
                // 當使用者點擊「繼續」後的行為
                if let gender = selectedGender {
                    // 將性別儲存到 userSettings 或傳給後端
                    userSettings.gender = gender.rawValue
                    print("使用者選擇的性別：\(gender.rawValue)")
                    
                    // 例如，跳轉到下一個畫面
                    // ...
                }
            }) {
                Text("繼續")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedGender == nil ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(selectedGender == nil)
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .padding()
    }
}

struct GenderSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        // 建議提供預覽時的 userSettings 或其他 EnvironmentObject
        GenderSelectionView()
            .environmentObject(UserSettings())
            .previewDevice("iPhone 15 Pro")
    }
}
