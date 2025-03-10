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
    
    func makeUIView(context: Context) -> SpreadSheetView {
        return view
    }
    
    func updateUIView(_ uiView: SpreadSheetView, context: Context) {
        // 如果需要更新 uiView 的內容，這裡可以進行配置
    }
}
