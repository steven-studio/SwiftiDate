//
//  HowToPurchaseSwiftiDateSupremeView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import SwiftUI

struct UpdateProfileDetailsView: View {
    @Binding var isUpdateProfileDetailsView: Bool // Binding to control the dismissal of HowToPurchaseSwiftiDateSupremeView

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isUpdateProfileDetailsView = false // Dismiss HowToPurchaseSwiftiDateSupremeView and return to the previous view
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                
                Text("SwiftiDate 幫助")
                    .font(.headline)
                    .padding(.leading, 5)
                
                Spacer()
            }
            .padding()
            
            Divider()
            
            // Scrollable content
            ScrollView {
                VStack(alignment: .leading) {
                    // Detailed content of HowToPurchaseSwiftiDateSupremeView
                    Text("如何編輯我的個人資料？")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("""
                    點擊主界面下方的人物👤 進入「個人資料」界面，然後點擊你自己的頭像或頭像下方的綠色鉛筆✏️按鈕，進入個人資料編輯頁面。在編輯個人資料界面，你可以上傳照片、編輯你的姓名、生日、個人介紹、興趣等個人資料。
                    """)
                    .padding()
                }
            }
        }
        .padding()
    }
}

// Preview for HowToPurchaseSwiftiDateSupremeView
struct UpdateProfileDetailsView_Preview: PreviewProvider {
    @State static var isUpdateProfileDetailsView = true // Provide a sample state variable for the preview

    static var previews: some View {
        UpdateProfileDetailsView(isUpdateProfileDetailsView: $isUpdateProfileDetailsView) // Use the binding variable in the preview
    }
}
