//
//  InfoPopupView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/17.
//

import Foundation
import SwiftUI

struct InfoPopupView: View {
    @Binding var isShowing: Bool
    var userRankPercentage: Double
    
    var body: some View {
        // Popup content
        VStack {
            Spacer()
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("即時更新的人氣大賽")
                        .font(.headline)
                    Spacer()
                    Button(action: {
                        AnalyticsManager.shared.trackEvent("info_popup_close_tapped")
                        isShowing = false // Close the popup
                    }) {
                        Image(systemName: "xmark")
                            .font(.title)
                            .foregroundColor(.gray)
                            .opacity(0.4)
                    }
                }
                .padding()
                
                Text("你好秀啊！你比附近\(String(format: "%.1f", userRankPercentage))%的用戶還受歡迎喔！")                               .font(.body)
                    .padding(.horizontal)
                
                Text("如何獲得更多喜歡")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("保持活躍，每天上線 SwiftiDate")
                    }
                    HStack {
                        Image(systemName: "checkmark")
                        Text("配對多右滑，右滑多配對")
                    }
                    HStack {
                        Image(systemName: "checkmark")
                        Text("選最好的照片作為頭像")
                    }
                    HStack {
                        Image(systemName: "checkmark")
                        Text("個資豐富，脫穎而出")
                    }
                    HStack {
                        Image(systemName: "checkmark")
                        Text("頭像認證，取得信任")
                    }
                }
                .padding(.horizontal)
                
                Button(action: {
                    AnalyticsManager.shared.trackEvent("info_popup_get_more_exposure_tapped")
                    isShowing = false // Dismiss the popup
                }) {
                    Text("獲得更多曝光的機會")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .transition(.opacity) // Smooth transition when appearing/disappearing
        .animation(.easeInOut)
        .onAppear {
            AnalyticsManager.shared.trackEvent("info_popup_view_appear", parameters: [
                "user_rank_percentage": userRankPercentage
            ])
        }
    }
}

struct InfoPopupView_Previews: PreviewProvider {
    @State static var isShowingPreview = true // Create a mock State for the binding
    
    static var previews: some View {
        InfoPopupView(isShowing: $isShowingPreview, userRankPercentage: 75.4)
            .previewLayout(.sizeThatFits)
            .background(Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)) // Adding background for better preview
    }
}
