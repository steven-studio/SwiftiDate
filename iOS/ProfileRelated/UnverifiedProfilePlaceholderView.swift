//
//  UnverifiedProfilePlaceholderView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/17.
//

import Foundation
import SwiftUI

struct UnverifiedProfilePlaceholderView: View {
    let photos: [String]
    
    var body: some View {
        HStack {
            ZStack {
                if let firstPhotoName = photos.first, let image = PhotoUtility.loadImageFromLocalStorage(named: firstPhotoName) {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 2)
                        )
                } else {
                    // 顯示預設的佔位符圖片
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 2)
                        )
                }
                
                // 顯示 xmark，在圖像的上方
                Circle()
                    .fill(Color.red)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    )
                    .offset(x: 20, y: 20) // 調整 x 和 y 的偏移量，使其位於圖像上方
            }
            
            Text("請更換頭像照片後再查看喜歡數排名")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.leading, 10)
            
            Spacer()
            
            Image(systemName: "lock.fill")
                .resizable()
                .frame(width: 24, height: 30)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.green)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
