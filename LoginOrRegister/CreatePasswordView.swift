//
//  CreatePasswordView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/4.
//

import Foundation
import SwiftUI

struct CreatePasswordView: View {
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    
    // 檢查密碼長度是否符合
    private var isPasswordValid: Bool {
        password.count >= 6
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: {
                    // 返回上一頁前追蹤返回事件
                    AnalyticsManager.shared.trackEvent("CreatePassword_BackTapped", parameters: nil)
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.gray.opacity(0.5)) // 設置文字顏色為黑色
                        .padding(.leading)
                }
                Spacer()
            }
            .padding(.top)
            
            // 標題
            Text("創建密碼")
                .font(.title)
                .bold()
                .padding(5)
                .foregroundColor(.white)
            
            // 說明文字
            Text("密碼須不少於6個字符")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.vertical)
            
            // 密碼輸入欄位 (可顯示/隱藏)
            ZStack(alignment: .trailing) {
                TextField("輸入密碼", text: $password)
                    .font(.title2)
                    .padding(.horizontal)
                    .padding(.vertical)
                    .foregroundColor(.black)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                    .accessibilityIdentifier("CreatePasswordField") // <- 加上 Identifier

//                } else {
//                    SecureField("輸入密碼", text: $password)
//                        .font(.title2)
//                        .padding(.horizontal)
//                        .padding(.vertical)
//                        .foregroundColor(.black)
//                        .background(Color.gray.opacity(0.3))
//                        .cornerRadius(10)
//                        .accessibilityIdentifier("SecureCreatePasswordField") // <- 加上 Identifier
//                }
                
//                Button(action: {
//                    isPasswordVisible.toggle()
//                }) {
//                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
//                        .foregroundColor(.gray)
//                        .padding(.trailing, 8)
//                }
            }
            
            // 錯誤訊息 (若需要)
            if !isPasswordValid && !password.isEmpty {
                Text("密碼長度需大於等於 6 個字元")
                    .font(.footnote)
                    .foregroundColor(.red)
            }
            
            Spacer()
            
            // 繼續按鈕
            Button(action: {
                // 這裡放你想要的行為，例如：
                // 1. 儲存密碼
                // 2. 導向下一個頁面
                // 3. 呼叫後端 API 等
                print("建立密碼：\(password)")
            }) {
                Text("繼續")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isPasswordValid ? Color.green : Color.gray)
                    .cornerRadius(8)
            }
            .disabled(!isPasswordValid)
        }
        .padding()
        .navigationBarHidden(true) // 如果需要隱藏NavigationBar
        .background(Color.black)
    }
}

struct CreatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePasswordView()
    }
}
