//
//  MeetingGuideView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/10.
//

import Foundation
import SwiftUI

struct MeetingGuideView: View {
    @Binding var showMeetingGuideView: Bool

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    AnalyticsManager.shared.trackEvent("MeetingGuide_BackTapped", parameters: nil)
                    showMeetingGuideView = false
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding()

            Spacer()
            
            // 此處放入你要顯示的檢舉後的內容
            Image("meeting_guide_image") // 使用你的圖片名稱
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200) // 根據需要調整大小
                .padding()

            // Add your content for "相約見面" here
            Text("相約見面指南")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("""
            SwiftiDate 希望配對成功的對象不僅能在線上相互了解，
            也能在現實生活中成為好朋友。
            但是，在網友見面的過程中，安全也很重要！

            以下是 SwiftiDate 對奔現的安全建議：
            
            - 在公共場所見面
            
            - 告訴家人朋友見面的行程
            
            - 使用公共交通工具等
            """)
                .font(.body)
                .padding()

            Spacer()
        }
        .onAppear {
            AnalyticsManager.shared.trackEvent("MeetingGuideView_Appeared", parameters: nil)
        }
    }
}

// Add a preview for the MeetingGuideView
struct MeetingGuideView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a constant binding for the preview
        MeetingGuideView(showMeetingGuideView: .constant(true))
    }
}
