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
    let widthMultiplier: CGFloat? // 可選值
    
    init(items: [String], isFirstLine: Bool, isLastLine: Bool, widthMultiplier: CGFloat? = nil) {
        self.items = items
        self.isFirstLine = isFirstLine
        self.isLastLine = isLastLine
        self.widthMultiplier = widthMultiplier
    }
}

struct BorderViews {
    let topBorder: UIView
    let bottomBorder: UIView
    let leftBorder: UIView
    let rightBorder: UIView
}
