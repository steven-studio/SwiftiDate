//
//  MeetWillingnessSection.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/17.
//

import Foundation
import SwiftUI

// 見面意願區域
struct MeetWillingnessSection: View {
    @Binding var selectedMeetWillingness: String?
    @Binding var isShowingMeetWillingnessView: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text("線下見面")
                .font(.headline)
                .padding(.bottom, 5)

            HStack {
                Image(systemName: "person.2.fill")
                    .foregroundColor(.gray)
                    .font(.headline)
                Text("見面意願")
                Spacer()
                Text(selectedMeetWillingness ?? "未填寫")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .onTapGesture {
                // 埋點：用戶點擊見面意願區域，打開見面意願視圖
                AnalyticsManager.shared.trackEvent("meet_willingness_view_opened")
                isShowingMeetWillingnessView = true
            }
            .fullScreenCover(isPresented: $isShowingMeetWillingnessView) {
                MeetWillingnessView(isPresented: $isShowingMeetWillingnessView, selectedOption: $selectedMeetWillingness)
                    .onAppear {
                        // 埋點：見面意願的 Sheet 出現時上報事件
                        AnalyticsManager.shared.trackEvent("meet_willingness_sheet_appear")
                    }
            }
        }
        .padding()
    }
}
