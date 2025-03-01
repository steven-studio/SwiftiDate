//
//  SocialTrainingView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/1/31.
//

import Foundation
import SwiftUI

struct SocialTrainingView: View {
    let courses: [SocialCourse] = [
        SocialCourse(
            title: "高價值社交技巧",
            instructor: "Avi",
            description: "學習如何自然吸引異性，提升社交自信，讓你在約會中脫穎而出。",
            price: "$9.99",
            url: URL(string: "https://avi-dating-course.com"), // Avi 官方網站（假設網址）
            isInAppPurchase: false
        ),
        SocialCourse(
            title: "線上聊天的黃金法則",
            instructor: "神秘講師 X",
            description: "如何透過訊息聊天建立吸引力，增加對話趣味性，提高回覆率。",
            price: "$14.99",
            url: nil, // 未來可以改為內購
            isInAppPurchase: true
        )
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("🔥 SwiftiDate 社交提升課程")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)

                    Text("想提升你的社交技巧？這些課程將幫助你更自信地與異性互動，讓你的搭訕技巧更自然，並提升你的成功率！")
                        .padding(.bottom, 10)

                    // 列出所有課程
                    ForEach(courses) { course in
                        NavigationLink(destination: CourseDetailView(course: course)) {
                            CourseRowView(course: course)
                                .simultaneousGesture(TapGesture().onEnded {
                                    // 埋點：使用者點擊某個課程
                                    AnalyticsManager.shared.trackEvent("social_course_tapped", parameters: [
                                        "course_title": course.title,
                                        "instructor": course.instructor
                                    ])
                                })
                        }
                        .buttonStyle(PlainButtonStyle()) // 讓整個 row 可點擊
                    }
                }
                .padding()
                // 埋點：頁面曝光
                .onAppear {
                    AnalyticsManager.shared.trackEvent("social_training_view_appear")
                }
            }
            .navigationTitle("社交課程")
        }
    }
}

struct SocialTrainingView_Previews: PreviewProvider {
    static var previews: some View {
        SocialTrainingView()
    }
}
