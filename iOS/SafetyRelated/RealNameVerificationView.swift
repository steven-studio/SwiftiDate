//
//  RealNameVerificationView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/10.
//

import Foundation
import SwiftUI

struct RealNameVerificationView: View {
    @Binding var showRealNameVerificationView: Bool
    
    var body: some View {
        VStack {
            // 返回按鈕
            HStack {
                Button(action: {
                    // 點擊返回按鈕時，返回上個頁面
                    showRealNameVerificationView = false
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                        .padding()
                }
                Spacer()
            }
            
            Spacer()
            
            // 顯示圖片
            Image(systemName: "triangle.fill") // 這裡可以換成你的實際圖片名稱
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .foregroundColor(Color(red: 0.45, green: 0.80, blue: 0.90))
                .padding()

            Text("真人認證")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 10)
            
            Text("""
真人認證的藍色勾勾並不是網紅專屬標誌，每一位通過認證的用戶都可以擁有喔！

當你滑到有藍色勾勾標誌的卡片，代表對方的照片是本人照，不會是機器人～

SwiftiDate 採用世界領先的臉部識別技術，不僅超快速，而且超精準，精準度可達金融服務級別 👍

認證後的好處：藍色勾勾會向其他用戶證明你的信任，獲得更多配對哦！

如何驗證：在「我的」頁面找到「本人認證」，點擊進入「本人認證」，按照操作指引提示進行臉部掃描。系統成功交叉比對用戶與個人資料照片後，即可獲得藍色勾勾圖標。
""")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .padding()

            Spacer()

            // 確認按鈕
            Button(action: {
                // 這裡可以加入其他操作
                showRealNameVerificationView = false
            }) {
                Text("了解了")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal, 30)
            }

            Spacer()
        }
        .background(Color.white.ignoresSafeArea())
    }
}

struct RealNameVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        RealNameVerificationView(showRealNameVerificationView: .constant(true))
    }
}
