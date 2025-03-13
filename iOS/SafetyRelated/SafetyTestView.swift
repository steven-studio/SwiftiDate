//
//  SafetyTestView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/10.
//

import Foundation
import SwiftUI

struct SafetyTestView: View {
    @Binding var showSafetyTestView: Bool
    @State private var isQuizStarted = false // State to control the transition to the quiz

    var body: some View {
        if isQuizStarted {
            // Pass the binding to the SafetyQuizView
            SafetyQuizView(showSafetyTestView: $showSafetyTestView)
                .onAppear {
                    AnalyticsManager.shared.trackEvent("SafetyTest_QuizStarted", parameters: nil)
                }
        } else {
            VStack {
                HStack {
                    Button(action: {
                        // Close the SafetyTestView and record the event
                        AnalyticsManager.shared.trackEvent("SafetyTest_Closed", parameters: nil)
                        showSafetyTestView = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.title)
                            .foregroundColor(.gray) // Set the color to gray
                            .padding()
                    }
                    Spacer()
                }
                Spacer()

                // Icon image similar to the one in the image
                Image(systemName: "lock.shield.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120) // Adjust the size accordingly
                    .foregroundColor(Color(red: 0.45, green: 0.80, blue: 0.90)) // Custom color
                
                Text("SwiftiDate 安全測驗")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                Text("SwiftiDate 安全團隊幫你模擬了數個交友場景，快來測測你的安全等級吧～")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 10)
                
                Spacer()
                
                // Button for starting the test
                Button(action: {
                    AnalyticsManager.shared.trackEvent("SafetyTest_Started", parameters: nil)
                    // Start the quiz by setting isQuizStarted to true
                    isQuizStarted = true
                }) {
                    Text("開始測試")
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
            .padding(.top, 50)
            .background(Color.white.ignoresSafeArea())
            .onAppear {
                AnalyticsManager.shared.trackEvent("SafetyTestView_Appeared", parameters: nil)
            }
        }
    }
}

struct SafetyTestView_Previews: PreviewProvider {
    @State static var showSafetyTestView = true // Add a State variable for the preview
    
    static var previews: some View {
        SafetyTestView(showSafetyTestView: $showSafetyTestView) // Pass the binding
    }
}
