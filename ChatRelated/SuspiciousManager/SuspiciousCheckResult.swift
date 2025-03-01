//
//  SuspiciousCheckResult.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/22.
//

import Foundation

enum SuspiciousReason {
    case firstMessageHookup
    case tooFastConfession
    // 也可以加 .scam, .spam, ... 等等
    case phishingLink
    case scamKeyword
    case saleKeyword
    case ballsInHerHand
    case NSFWKeyword
}

/// 規則檢查的結果
enum SuspiciousCheckResult {
    case allow        // 一切正常，允許訊息送出
    case warn(SuspiciousReason)
    case block(SuspiciousReason)
}
