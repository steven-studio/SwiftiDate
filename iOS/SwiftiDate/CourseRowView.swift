//
//  CourseRowView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/1/31.
//

import Foundation
import SwiftUI

struct CourseRowView: View {
    let course: SocialCourse

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(course.title)
                .font(.headline)
            Text("👨‍🏫 \(course.instructor)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(course.description)
                .font(.body)
                .lineLimit(2)
            Text("💰 \(course.price)")
                .font(.subheadline)
                .foregroundColor(.blue)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
