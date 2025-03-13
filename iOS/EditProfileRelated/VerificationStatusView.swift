//
//  VerificationStatusView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/17.
//

import Foundation
import SwiftUI

struct VerificationStatusView: View {
    @EnvironmentObject var userSettings: UserSettings
    @Binding var isShowingVerificationView: Bool
    @Binding var photos: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("真人認證")
                .font(.headline)
                .foregroundColor(.black)
                .padding(.bottom, 5)

            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.blue)
                Text("認證你的個人照片")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                if userSettings.globalIsUserVerified {
                    Text("已認證")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else {
                    HStack {
                        Text("未認證")
                            .font(.subheadline)
                            .foregroundColor(.red)

                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .onTapGesture {
                        // 導航到認證頁面
                        isShowingVerificationView = true
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(Color.clear)
        .fullScreenCover(isPresented: $isShowingVerificationView) {
            VerificationView(photos: $photos) // Pass the photos binding here
        }
    }
}
