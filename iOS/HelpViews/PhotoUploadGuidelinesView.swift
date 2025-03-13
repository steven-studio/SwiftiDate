//
//  PhotoUploadGuidelinesView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import SwiftUI

struct PhotoUploadGuidelinesView: View {
    @Binding var isPhotoUploadGuidelinesView: Bool // Binding to control the dismissal of PhotoUploadGuidelinesView

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isPhotoUploadGuidelinesView = false // Dismiss PhotoUploadGuidelinesView and return to the previous view
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
                    // Detailed content of PhotoUploadGuidelinesView
                    Text("我需要上傳什麼樣的照片作為頭像？")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("""
                    上傳到 SwiftiDate 的照片應符合以下要求，你才能被其他用戶看到，有機會獲得配對：

                    1. 上傳的照片應該是你的真實、正面、無遮擋物的單人照片；
                    2. 請不要使用從網路上下載的圖片；
                    3. 請不要使用戴墨鏡或者背景過於陰暗的照片；
                    4. 請勿上傳裸體或不雅的照片。

                    我們建議你上傳多張展現你的興趣愛好和個人生活的照片。旅行照和寵物合照更受大家的喜愛喔(^__^)。

                    - **添加**：點擊任一空著的圖片框進行照片新增，可以從你的相簿中選擇照片進行上傳新的照片。注意：最多可以有6張照片喔！
                    - **刪除**：點擊你想要刪除的照片右下角的 x 符號，即可刪除照片。
                    - **調整順序**：長按你想要調整排列順序的照片，並將其拖動到任意照片的前後位置即可更改照片展示順序。
                    """)
                    .padding()
                }
            }
        }
        .padding()
    }
}

// Preview for PhotoUploadGuidelinesView
struct PhotoUploadGuidelinesView_Preview: PreviewProvider {
    @State static var isPhotoUploadGuidelinesView = true // Provide a sample state variable for the preview

    static var previews: some View {
        PhotoUploadGuidelinesView(isPhotoUploadGuidelinesView: $isPhotoUploadGuidelinesView) // Use the binding variable in the preview
    }
}
