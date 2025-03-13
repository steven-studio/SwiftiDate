//
//  HowToPurchaseSwiftiDateSupremeView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import SwiftUI

struct ManageProfilePhotosView: View {
    @Binding var isManageProfilePhotosView: Bool // Binding to control the dismissal of HowToPurchaseSwiftiDateSupremeView

    var body: some View {
        VStack(alignment: .leading) {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    isManageProfilePhotosView = false // Dismiss HowToPurchaseSwiftiDateSupremeView and return to the previous view
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
                    Text("如何更改我的照片？")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("""
                    點擊主界面下方的人物👤 進入「個人資料」界面，然後點擊你自己的頭像或頭像下方的綠色鉛筆✏️按鈕，進入個人資料編輯頁面。你可以通過選擇增加、刪除或者重新排列你的照片順序來更改自己的照片：

                    - 添加：點擊任一空著的圖片框進行照片新增，可以從你的相簿中選擇照片進行上傳新的照片。注意：最多可以有6張照片喔！

                    - 刪除：點擊你想要刪除的照片右下角的 x 符號，即可刪除照片。

                    - 調整順序：長按你想要調整排列順序的照片，並將其拖動到任意照片的前後位置即可更改照片展示順序。
                    """)
                    .padding()
                }
            }
        }
        .padding()
    }
}

// Preview for HowToPurchaseSwiftiDateSupremeView
struct ManageProfilePhotosView_Preview: PreviewProvider {
    @State static var isManageProfilePhotosView = true // Provide a sample state variable for the preview

    static var previews: some View {
        ManageProfilePhotosView(isManageProfilePhotosView: $isManageProfilePhotosView) // Use the binding variable in the preview
    }
}
