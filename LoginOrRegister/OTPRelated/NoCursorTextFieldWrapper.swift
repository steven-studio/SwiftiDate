//
//  NoCursorTextFieldWrapper.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/26.
//

import Foundation
import SwiftUI

/// 讓 SwiftUI 中可以直接使用 NoCursorTextField 的包裝
struct NoCursorTextFieldWrapper: UIViewRepresentable {
    
    /// 綁定的字串
    @Binding var text: String
    var index: Int  // 你可以傳入 index

    /// 退格到空字時，可呼叫的 closure（用來通知外部）
    var onDeleteBackwardWhenEmpty: (() -> Void)? = nil
    
    /// 你要不要處理焦點，或提交鍵事件，都可以在這裡加
    
    func makeUIView(context: Context) -> NoCursorTextField {
        let textField = NoCursorTextField(frame: .zero)
        
        // 基礎外觀設定
        textField.font = UIFont.systemFont(ofSize: 24)
        textField.textColor = .black
        textField.tintColor = .clear    // 游標顏色也可再設一次
        textField.borderStyle = .none
        textField.textContentType = .oneTimeCode
        textField.keyboardType = .numberPad
        
        // **關鍵**：把 accessibilityIdentifier 設在真正的 UITextField
        textField.accessibilityIdentifier = "OTPTextField\(index)"
        
        // **重點**：設定文字置中 (水平 + 垂直)
        textField.textAlignment = .center
        textField.contentVerticalAlignment = .center
        
        // 加入自訂行為
        textField.onDeleteBackwardWhenEmpty = {
            onDeleteBackwardWhenEmpty?()
        }
        
        // 使用 Coordinator 來監測文字變更
        textField.delegate = context.coordinator
        
        return textField
    }
    
    func updateUIView(_ uiView: NoCursorTextField, context: Context) {
        // 每次 SwiftUI 刷新，將 SwiftUI 的 text 同步給 UITextField
        if uiView.text != text {
            uiView.text = text
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: NoCursorTextFieldWrapper
        
        init(_ parent: NoCursorTextFieldWrapper) {
            self.parent = parent
        }
        
        /// 文字改變時更新 SwiftUI 的 @Binding text
        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}
