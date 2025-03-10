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
    
    init(items: [String], isFirstLine: Bool, isLastLine: Bool) {
        self.items = items
        self.isFirstLine = isFirstLine
        self.isLastLine = isLastLine
    }
}

struct BorderViews {
    let topBorder: UIView
    let bottomBorder: UIView
    let leftBorder: UIView
    let rightBorder: UIView
}
