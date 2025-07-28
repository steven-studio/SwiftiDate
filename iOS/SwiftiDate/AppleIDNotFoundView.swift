//
//  AppleIDNotFoundView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/7/28.
//

import SwiftUI

struct AppleIDNotFoundView: View {
    var onCreateAccount: () -> Void
    var onBack: () -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Spacer()
                
                Text("找不到 Apple ID")
                    .font(.title)
                    .bold()
                Text("我們找不到與該 Apple ID 連結的帳號。")
                    .font(.body)
                    .foregroundColor(.gray)
                Button(action: {
                    onCreateAccount()
                }) {
                    Text("建立新帳號")
                        .bold() // 或 .fontWeight(.bold)
                        .padding(.vertical, 24)
                        .padding(.horizontal, 64)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { onBack() }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .padding()
    }
}
