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

    func makeUIView(context: Context) -> SpreadSheetView {
        return view
    }
    
    func updateUIView(_ uiView: SpreadSheetView, context: Context) {
        // 透過 DispatchQueue 確保在主線程上更新高度
        DispatchQueue.main.async {
            self.contentHeight = uiView.intrinsicContentSize.height
        }
    }
}
