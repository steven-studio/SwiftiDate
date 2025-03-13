//
//  VerifiedProfileProgressView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/17.
//

import Foundation
import SwiftUI

struct VerifiedProfileProgressView: View {
    let userRankPercentage: Double
    @Binding var isShowingInfoPopup: Bool

    var body: some View {
        VStack {
            HStack {
                Text("打敗 \(String(format: "%.1f", userRankPercentage))%")
                    .font(.subheadline)
                    .fontWeight(.bold)

                // Add the question mark icon with tap gesture
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.green)
                    .onTapGesture {
                        isShowingInfoPopup = true // Show the popup when tapped
                    }
            }
            .padding(.bottom, 5)

            ProgressView(value: userRankPercentage / 100) // Convert the percentage to a fraction
                .progressViewStyle(LinearProgressViewStyle(tint: .green))
                .scaleEffect(x: 1, y: 4, anchor: .center)
        }
        .padding(.horizontal)
    }
}
