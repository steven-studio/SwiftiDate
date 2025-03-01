//
//  TurboPurchaseView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/21.
//

import Foundation
import SwiftUI

struct TurboPurchaseView: View {
    @Environment(\.presentationMode) var presentationMode // Environment variable to control view dismissal
    @State private var selectedOption = "5 Turbo" // Default selected option

    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                // Mockup header with the phone image
                Image("turbo_header") // Replace with your actual image
                    .resizable()
                    .scaledToFill() // Use scaledToFill to ensure the image fills the frame
                    .frame(width: UIScreen.main.bounds.width, height: 350) // Adjust the height to extend as much as needed
                    .clipped() // Clips any overflowed content to fit within the frame
                    .edgesIgnoringSafeArea(.top) // Extend to the top edges
                
                // Add the "X" button on top of the image
                Button(action: {
                    AnalyticsManager.shared.trackEvent("turbo_purchase_view_dismissed")
                    presentationMode.wrappedValue.dismiss() // Dismiss the view
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.gray)
                        .padding(16) // Add padding to give more space around the X button
                }
            }
            
            Text("收穫更多喜歡")
                .font(.headline)
                .padding(.top)
            
            Text("開啟Turbo期間，你的資料將直接置頂到所有人的前面！輕鬆提升10倍配對成功率")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Spacer()
            
            // Turbo options
            HStack(spacing: 10) {
                TurboOptionView(title: "10 Turbo", price: "NT$99 /次", discount: "省 34%", isSelected: selectedOption == "10 Turbo") {
                    selectedOption = "10 Turbo"
                    AnalyticsManager.shared.trackEvent("turbo_option_selected", parameters: ["option": "10 Turbo"])
                }
                TurboOptionView(title: "5 Turbo", price: "NT$138 /次", discount: "省 8%", isSelected: selectedOption == "5 Turbo") {
                    selectedOption = "5 Turbo"
                    AnalyticsManager.shared.trackEvent("turbo_option_selected", parameters: ["option": "5 Turbo"])
                }
                TurboOptionView(title: "1 Turbo", price: "NT$150 /次", discount: "", isSelected: selectedOption == "1 Turbo") {
                    selectedOption = "1 Turbo"
                    AnalyticsManager.shared.trackEvent("turbo_option_selected", parameters: ["option": "1 Turbo"])
                }
            }
            .padding(.horizontal)
            
            // Purchase button
            Button(action: {
                AnalyticsManager.shared.trackEvent("turbo_purchase_button_tapped", parameters: [
                    "selected_option": selectedOption
                ])
                print("立即獲取 \(selectedOption)")
                // Handle the purchase logic here
            }) {
                Text("立即獲取")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            Text("獲得後隨時用，永遠不會過期")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom, 10)
        }
        .navigationTitle("Turbo")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            AnalyticsManager.shared.trackEvent("turbo_purchase_view_appear")
        }
    }
}

struct TurboOptionView: View {
    var title: String
    var price: String
    var discount: String
    var isSelected: Bool
    var onSelect: () -> Void
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding(.bottom, 5)
            
            if !discount.isEmpty {
                Text(discount)
                    .font(.subheadline)
                    .foregroundColor(.red)
                    .padding(3)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(5)
            }
            
            Text(price)
                .font(.subheadline)
        }
        .frame(width: 100, height: 120)
        .background(isSelected ? Color.purple.opacity(0.3) : Color.purple.opacity(0.1))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.purple : Color.clear, lineWidth: 2)
        )
        .onTapGesture {
            onSelect()
        }
    }
}

struct TurboPurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        TurboPurchaseView()
    }
}
