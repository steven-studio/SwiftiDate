//
//  InteractiveContentView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/22.
//

import Foundation
import SwiftUI

struct InteractiveContentView: View {
    var onBack: () -> Void // Closure to handle back navigation
    
    var body: some View {
        VStack {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    onBack() // Call the onBack closure when the button is pressed
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                }

                Spacer() // Pushes the back button to the left
                
                Text("戀人卡指南") // Title for the view (Change to your preferred title)
                    .font(.headline)
                
                Spacer() // Ensures the title is centered
            }
            .frame(height: 60)
            .background(Color.white)
            
            Divider() // Divider line under the custom navigation bar
            
            // Main content
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    
                    // Text message example
                    Text("戀人卡每天都會有不同的題目等你來回答！選擇相同答案的兩個人即可直接配對成功～")
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    
                    // An image
                    Image("exampleImage")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width - 40, height: 200)
                        .clipped()
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    // Another informational block with an embedded button
                    VStack(alignment: .leading, spacing: 5) {
                        Text("《滑卡指南》")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Text("👉 點擊卡片可以看到更多資訊哦～")
                            .font(.subheadline)
                            .foregroundColor(.green)
                        
                        Text("❤️ @玩玩，來找到真正適合自己的配對！")
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    
                    // "Continue" button
                    Button(action: {
                        onBack() // Call onBack when pressing "Continue" button to go back
                    }) {
                        Text("繼續")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
        }
        .navigationBarHidden(true) // Hide the default navigation bar
    }
}
