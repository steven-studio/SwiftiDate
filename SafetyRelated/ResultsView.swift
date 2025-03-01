//
//  ResultsView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/10.
//

import Foundation
import SwiftUI

struct ResultsView: View {
    var score: Int // This will be passed from the quiz view
    var totalQuestions: Int
    @Binding var showSafetyTestView: Bool // Binding to return to the SafetyTestView

    var body: some View {
        VStack {
            Spacer()
            
            // You can customize this image to reflect your design
            Image(systemName: "lock.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding()

            Text("你的得分：")
                .font(.headline)
                .padding(.top)
            
            Text("\(score) / \(totalQuestions)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            // Display this congratulatory message only if score equals 6
            if score == 6 {
                Text("恭喜！你的安全意識很不錯，但不要放鬆警惕哦～")
                    .multilineTextAlignment(.center)
                    .padding()
            }

            ProgressView(value: Double(score), total: Double(totalQuestions))
                .padding(.horizontal, 40)
                .padding(.top)

            Text("希望SwiftiDate安全中心可以幫助你學到更多安全交友的技巧～")
                .multilineTextAlignment(.center)
                .padding()

            Spacer()

            Button(action: {
                // 記錄關閉結果頁事件
                AnalyticsManager.shared.trackEvent("ResultsView_Closed", parameters: ["score": score, "total": totalQuestions])
                // Close the ResultsView and return to SafetyTestView
                showSafetyTestView = false
            }) {
                Text("好的")
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
        .padding()
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            AnalyticsManager.shared.trackEvent("ResultsView_Appeared", parameters: ["score": score, "total": totalQuestions])
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    @State static var showSafetyTestView = true // Create a state variable for preview

    static var previews: some View {
        ResultsView(score: 5, totalQuestions: 6, showSafetyTestView: $showSafetyTestView) // Pass the binding
    }
}
