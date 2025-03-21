//
//  NicknameInputView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/4.
//

import Foundation
import SwiftUI

struct NicknameInputView: View {
    @State private var nickname: String = ""
    private let maxLength = 35
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: {
                    // 返回上一頁前追蹤返回事件
                    AnalyticsManager.shared.trackEvent("Nickname_BackTapped", parameters: nil)
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.gray.opacity(0.5)) // 設置文字顏色為黑色
                        .padding(.leading)
                }
                Spacer()
            }
            
            // 標題
            Text("你的名字叫…")
                .font(.title)
                .bold()
                .padding()
            
            // 說明文字
            Text("這將是你在 SwiftiDate 中的暱稱")
                .font(.system(size: 18))
                .padding(.bottom)
            
            // 輸入框 + 字數顯示
            VStack {
                TextField("", text: $nickname)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .onChange(of: nickname) { oldValue, newValue in
                        // 如果超過 35 字就自動截斷
                        if nickname.count > maxLength {
                            nickname = String(nickname.prefix(maxLength))
                        }
                    }
                
                HStack {
                    Spacer()
                    
                    // 顯示剩餘字數 or 已輸入字數
                    Text("\(nickname.count)/\(maxLength)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // 「繼續」按鈕
            Button(action: {
                // 按下繼續後的行為，例如：儲存暱稱、跳轉頁面
                print("使用者輸入的暱稱：\(nickname)")
            }) {
                Text("繼續")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(isNicknameValid ? Color.blue : Color.gray)
                    .frame(width: 300)
                    .cornerRadius(25)
            }
            .disabled(!isNicknameValid)
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .padding()
    }
    
    // 判斷暱稱是否有效（非空 & 長度 <= maxLength）
    private var isNicknameValid: Bool {
        !nickname.isEmpty && nickname.count <= maxLength
    }
}

struct NicknameInputView_Previews: PreviewProvider {
    static var previews: some View {
        NicknameInputView()
            .previewDevice("iPhone 15 Pro")
    }
}
