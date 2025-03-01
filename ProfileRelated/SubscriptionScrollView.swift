//
//  SubscriptionScrollView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/18.
//

import Foundation
import SwiftUI

enum SubscriptionType {
    case premium
    case supreme
}

struct SubscriptionOptionView: View {
    var discountText: String
    var durationText: String
    var priceText: String
    var originalPriceText: String
    var isHighlighted: Bool
    var subscriptionType: SubscriptionType // Add subscription type to determine the colors
    var action: () -> Void // Closure for tap action

    var body: some View {
        if subscriptionType == .premium {
            VStack(spacing: 10) {
                Text(discountText)
                    .font(.subheadline)
                    .foregroundColor(isHighlighted ? .black : .gold)
                    .padding(.top, 5)
                    .padding(.bottom, 2)
                
                Text(durationText)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Text(priceText)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(isHighlighted ? .black : .gold)

                Text(originalPriceText)
                    .font(.footnote)
                    .strikethrough()
                    .foregroundColor(isHighlighted ? .orange : .gold)
                
                Spacer()
            }
            .frame(width: 100, height: 150)
            .background(isHighlighted ? Color.white : Color.yellow.opacity(0.1))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.yellow, lineWidth: isHighlighted ? 4 : 2) // Yellow border in both states
            )
            .padding(.horizontal, 5)
            .shadow(color: isHighlighted ? Color.yellow.opacity(0.5) : Color.clear, radius: 5)
            .onTapGesture {
                action() // Trigger the action when tapped
            }
        } else {
            VStack(spacing: 10) {
                Text(discountText)
                    .font(.subheadline)
                    .foregroundColor(isHighlighted ? .black : .gold)
                    .padding(.top, 5)
                    .padding(.bottom, 2)
                
                Text(durationText)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.gold)

                Text(priceText)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(isHighlighted ? .black : .gold)

                Text(originalPriceText)
                    .font(.footnote)
                    .strikethrough()
                    .foregroundColor(isHighlighted ? .orange : .gold)
                
                Spacer()
            }
            .frame(width: 100, height: 150)
            .background(isHighlighted ? Color.white : Color.yellow.opacity(0.1))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.yellow, lineWidth: isHighlighted ? 4 : 2) // Yellow border in both states
            )
            .padding(.horizontal, 5)
            .shadow(color: isHighlighted ? Color.yellow.opacity(0.5) : Color.clear, radius: 5)
            .onTapGesture {
                action() // Trigger the action when tapped
            }
        }
    }
}

struct SubscriptionScrollView: View {
    @State private var selectedIndex: Int? = 1 // Default to the second item being highlighted
    var subscriptionType: SubscriptionType // Parameter to specify the subscription type

    // Data for subscription options
    private var subscriptionOptions: [(discount: String, duration: String, price: String, originalPrice: String)] {
        switch subscriptionType {
        case .premium:
            return [
                (discount: "省 50%", duration: "1 週", price: "NT$450/週", originalPrice: "NT$900/週"),
                (discount: "省 85%", duration: "1 個月", price: "NT$140/週", originalPrice: "NT$900/週"),
                (discount: "省 91%", duration: "3 個月", price: "NT$87/週", originalPrice: "NT$900/週"),
                (discount: "省 93%", duration: "12 個月", price: "NT$66/週", originalPrice: "NT$900/週")
            ]
        case .supreme:
            return [
                (discount: "省 50%", duration: "1 週", price: "NT$630/週", originalPrice: "NT$1260/週"),
                (discount: "省 75%", duration: "1 個月", price: "NT$315/週", originalPrice: "NT$1260/週"),
                (discount: "省 85%", duration: "3 個月", price: "NT$200/週", originalPrice: "NT$1260/週"),
                (discount: "省 89%", duration: "12 個月", price: "NT$145/週", originalPrice: "NT$1260/週")
            ]
        }
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(subscriptionOptions.indices, id: \.self) { index in
                    let option = subscriptionOptions[index]

                    SubscriptionOptionView(
                        discountText: option.discount,
                        durationText: option.duration,
                        priceText: option.price,
                        originalPriceText: option.originalPrice,
                        isHighlighted: selectedIndex == index,
                        subscriptionType: subscriptionType,
                        action: {
                            selectedIndex = index // Update the selected index when tapped
                            AnalyticsManager.shared.trackEvent("subscription_option_selected", parameters: [
                                "subscription_type": subscriptionType == .premium ? "premium" : "supreme",
                                "option_index": index
                            ])
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            AnalyticsManager.shared.trackEvent("subscription_scroll_view_appear", parameters: [
                "subscription_type": subscriptionType == .premium ? "premium" : "supreme"
            ])
        }
    }
}
