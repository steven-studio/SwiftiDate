//
//  SpreadsheetItemViewModel.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/11.
//

import Foundation
import UIKit

class SpreadsheetItemViewModel: ObservableObject {
    let items: [String]
    let isFirstLine: Bool
    let isLastLine: Bool
    let widthMultiplier: CGFloat?  // 針對兩欄時的舊方式，可選
    let columnRatios: [CGFloat]?     // 新增：針對多欄情況的比例
    
    init(items: [String], isFirstLine: Bool, isLastLine: Bool, widthMultiplier: CGFloat? = nil, columnRatios: [CGFloat]? = nil) {
        self.items = items
        self.isFirstLine = isFirstLine
        self.isLastLine = isLastLine
        self.widthMultiplier = widthMultiplier
        self.columnRatios = columnRatios
    }
}

struct BorderViews {
    let topBorder: UIView
    let bottomBorder: UIView
    let leftBorder: UIView
    let rightBorder: UIView
}
