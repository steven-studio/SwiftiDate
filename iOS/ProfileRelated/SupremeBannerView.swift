//
//  SupremeBannerView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/17.
//

import Foundation
import SwiftUI

struct SupremeBannerView: View {
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "crown.fill") // Adding the crown icon
                        .foregroundColor(.gold) // Matching the gold color
                        .font(.system(size: 18)) // Adjust the size as needed
                    
                    Text("SwiftiDate Supreme")
                        .font(.headline)
                        .foregroundColor(.gold) // Set text color to gold
                        .fontWeight(.bold)
                }
                
                Text("已開啟 SwiftiDate 所有特權")
                    .font(.subheadline)
                    .foregroundColor(.gold)
                
                Spacer()
            }
            .padding(.vertical, 30)
            .frame(maxWidth: UIScreen.main.bounds.width - 80, alignment: .leading) // 設置最大寬度稍小於螢幕寬度
            .padding(.horizontal) // Add horizontal padding to the outer VStack
        }
        .background(Color.black) // Apply background color to the entire ZStack
        .cornerRadius(10) // Apply corner radius to the entire ZStack
    }
}
