//
//  TextViewRepresentable.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/9.
//

import Foundation
import UIKit
import SwiftUI

// 自定義 UIViewRepresentable 組件
struct TextViewRepresentable: UIViewRepresentable {
    var text: String
    @Binding var dynamicHeight: CGFloat
    let maxHeight: CGFloat // 最大高度限制

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false // 禁止編輯
        textView.isSelectable = true // 啟用選取功能
        textView.backgroundColor = UIColor.green.withAlphaComponent(0.1) // 背景設置為透明
        textView.isScrollEnabled = true  // 防止自動滾動
        textView.font = UIFont.systemFont(ofSize: 17) // 設置字體
        let isChineseText = text.range(of: "\\p{Han}", options: .regularExpression) != nil
        textView.textContainer.lineBreakMode = isChineseText ? .byCharWrapping : .byWordWrapping
//        textView.textContainer.lineFragmentPadding = 0 // 移除行內邊距
//        textView.textContainerInset = .zero // 移除內邊距
        
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        let isChineseText = text.range(of: "\\p{Han}", options: .regularExpression) != nil
        print("Is Chinese Text:", isChineseText)

        // 禁用 translatesAutoresizingMaskIntoConstraints
        uiView.translatesAutoresizingMaskIntoConstraints = false

        // 刪除現有的寬度約束
        uiView.constraints.forEach { constraint in
            if constraint.firstAttribute == .width {
                uiView.removeConstraint(constraint)
            }
        }
        
        // 獲取父容器的寬度
        let parentWidth = uiView.superview?.frame.width ?? UIScreen.main.bounds.width
        let fixedWidth = parentWidth - 32

        // 設置寬度約束
        NSLayoutConstraint.activate([
            uiView.widthAnchor.constraint(equalToConstant: fixedWidth)
        ])

        // 設置文本屬性
        uiView.textContainer.lineBreakMode = .byCharWrapping
        uiView.textContainer.lineFragmentPadding = 0
        uiView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

        // 使用 attributedText 設置文本
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        uiView.attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: UIFont.systemFont(ofSize: 17),
                .paragraphStyle: paragraphStyle
            ]
        )
        
        // 禁用滾動以計算高度
        uiView.isScrollEnabled = false

        // 計算內容高度
        let size = uiView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        print("Calculated Size:", size)

        // 更新高度和滾動狀態
        DispatchQueue.main.async {
            let newHeight = size.height > self.maxHeight ? self.maxHeight : size.height
            if self.dynamicHeight != newHeight {
                self.dynamicHeight = newHeight
                uiView.isScrollEnabled = size.height > self.maxHeight
            }

            // 強制刷新布局
            uiView.invalidateIntrinsicContentSize()
            uiView.setNeedsLayout()
            uiView.layoutIfNeeded()
        }
    }
}
