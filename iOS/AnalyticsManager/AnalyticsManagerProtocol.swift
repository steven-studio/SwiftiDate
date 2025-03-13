//
//  AnalyticsManagerProtocol.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/1.
//

import Foundation

// 假設你定義一個 AnalyticsManagerProtocol 讓 AnalyticsManager 和 MockAnalyticsManager 遵守
public protocol AnalyticsManagerProtocol {
    func trackEvent(_ event: String, parameters: [String: Any]?)
}
