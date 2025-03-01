//
//  CrushPurchaseView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/21.
//

import Foundation
import SwiftUI

struct CrushPurchaseView: View {
    @Environment(\.presentationMode) var presentationMode // Environment variable to control view dismissal
    @State private var selectedOption = "30 Crushes" // Default selected option

    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                // Mockup header with the phone image
                Image("crush_header") // Replace with your actual image
                    .resizable()
                    .scaledToFill() // Use scaledToFill to ensure the image fills the frame
                    .frame(width: UIScreen.main.bounds.width, height: 350) // Adjust the height to extend as much as needed
                    .clipped() // Clips any overflowed content to fit within the frame
                    .edgesIgnoringSafeArea(.top) // Extend to the top edges
                
                // Add the "X" button on top of the image
                Button(action: {
                    AnalyticsManager.shared.trackEvent("crush_purchase_view_dismissed")
                    presentationMode.wrappedValue.dismiss() // Dismiss the view
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.gray)
                        .padding(16) // Add padding to give more space around the X button
                }
            }
            
            Text("使用 Crush 魅力無窮")
                .font(.headline)
                .padding(.top)
            
            Text("送出 Crush，讓對方可以馬上看見你！")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Spacer()
            
            // Crush options
            HStack(spacing: 10) {
                CrushOptionView(title: "60 Crushes", price: "NT$34/個", discount: "省 48%", isSelected: selectedOption == "60 Crushes") {
                    selectedOption = "60 Crushes"
                    AnalyticsManager.shared.trackEvent("crush_option_selected", parameters: ["option": "60 Crushes"])
                }
                CrushOptionView(title: "30 Crushes", price: "NT$43/個", discount: "省 33%", isSelected: selectedOption == "30 Crushes") {
                    selectedOption = "30 Crushes"
                    AnalyticsManager.shared.trackEvent("crush_option_selected", parameters: ["option": "30 Crushes"])
                }
                CrushOptionView(title: "5 Crushes", price: "NT$64/個", discount: "", isSelected: selectedOption == "5 Crushes") {
                    selectedOption = "5 Crushes"
                    AnalyticsManager.shared.trackEvent("crush_option_selected", parameters: ["option": "5 Crushes"])
                }
            }
            .padding(.horizontal)
            
            // Purchase button
            Button(action: {
                AnalyticsManager.shared.trackEvent("crush_purchase_button_tapped", parameters: [
                    "selected_option": selectedOption
                ])
                print("立即擁有 clicked with \(selectedOption)")
                // Handle the purchase logic here
            }) {
                Text("立即擁有")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            Text("獲得後隨時用，永遠不會過期")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom, 10)
        }
        .navigationTitle("Crush")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CrushOptionView: View {
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
        .background(isSelected ? Color.green.opacity(0.3) : Color.green.opacity(0.1))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
        )
        .onTapGesture {
            onSelect()
        }
    }
}

struct CrushPurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        CrushPurchaseView()
    }
}
