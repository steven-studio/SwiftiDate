//
//  CourseDetailView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/1/31.
//

import Foundation
import SwiftUI
import StoreKit

struct CourseDetailView: View {
    let course: SocialCourse
    @State private var isPurchasing = false
    @State private var purchaseSuccess = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(course.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)

                Text("👨‍🏫 講師：\(course.instructor)")
                    .font(.headline)
                    .foregroundColor(.gray)

                Text(course.description)
                    .padding(.bottom, 10)

                Text("💰 價格：\(course.price)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding(.bottom, 10)

                if let url = course.url {
                    Link("🔗 前往課程網站", destination: url)
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .cornerRadius(10)
                        // 如有需要，也可以在 Link 外層加入 onTapGesture 埋點
                        .onTapGesture {
                            AnalyticsManager.shared.trackEvent("course_website_link_clicked", parameters: [
                                "course_title": course.title
                            ])
                        }
                } else if course.isInAppPurchase {
                    Button(action: {
                        isPurchasing = true
                        // 埋點：點擊購買按鈕
                        AnalyticsManager.shared.trackEvent("course_purchase_button_tapped", parameters: [
                            "course_title": course.title,
                            "price": course.price
                        ])
                        purchaseSocialTraining()
                    }) {
                        Text("🔥 立即購買")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .disabled(isPurchasing)

                    if purchaseSuccess {
                        Text("✅ 購買成功！你已經解鎖 VIP 內容！")
                            .foregroundColor(.green)
                            .font(.headline)
                            .padding(.top, 10)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("課程詳情")
        .onAppear {
            // 埋點：頁面曝光
            AnalyticsManager.shared.trackEvent("course_detail_view_appear", parameters: [
                "course_title": course.title,
                "course_instructor": course.instructor
            ])
        }
    }

    // 內購處理邏輯
    func purchaseSocialTraining() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            purchaseSuccess = true
            isPurchasing = false
            // 埋點：購買成功
            AnalyticsManager.shared.trackEvent("course_purchase_success", parameters: [
                "course_title": course.title
            ])
        }
    }
}
