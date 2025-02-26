//
//  NoCursorTextField.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/26.
//

import Foundation
import UIKit

/// 1) 隱藏游標
/// 2) 可以在 deleteBackward() 時通知外部
class NoCursorTextField: UITextField {
    /// 需要一個 closure，當使用者在「空字狀態」下按退格時，可以呼叫它
    var onDeleteBackwardWhenEmpty: (() -> Void)?
    
    /// 隱藏游標
    override func caretRect(for position: UITextPosition) -> CGRect {
        return .zero
    }
    
    /// 攔截退格行為
    override func deleteBackward() {
        if text?.isEmpty ?? true {
            onDeleteBackwardWhenEmpty?()
        }
        super.deleteBackward()
    }
}
