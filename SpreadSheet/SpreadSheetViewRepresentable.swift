//
//  SpreadSheetViewRepresentable.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/11.
//

import Foundation
import SwiftUI

struct SpreadSheetViewRepresentable: UIViewRepresentable {
    let view: SpreadSheetView
    @Binding var contentHeight: CGFloat
    let multiplier: CGFloat  // 新增這個參數

    func makeUIView(context: Context) -> SpreadSheetView {
        // 設定 SpreadSheetView 裡面的屬性
        view.cellWidthMultiplier = multiplier
        return view
    }
    
    func updateUIView(_ uiView: SpreadSheetView, context: Context) {
        uiView.cellWidthMultiplier = multiplier
        // 透過 DispatchQueue 確保在主線程上更新高度
        DispatchQueue.main.async {
            self.contentHeight = uiView.intrinsicContentSize.height
        }
    }
}
