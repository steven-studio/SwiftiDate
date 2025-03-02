//
//  AchievementCardView.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/2.
//

import Foundation
import SwiftUI

struct AchievementCardView: View {
    var title: String
    var count: Int
    var color: Color
    var action: (() -> Void)? // Optional action closure
    
    var body: some View {
        VStack {
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
            Text("\(count)")
                .font(.title)
                .fontWeight(.bold)
            Button(action: {
                action?() // Execute the action if provided
            }) {
                Text("獲取更多")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(5)
                    .background(Color.white)
                    .cornerRadius(5)
            }
        }
        .frame(width: 100, height: 100)
        .background(color.opacity(0.2))
        .cornerRadius(10)
    }
}
