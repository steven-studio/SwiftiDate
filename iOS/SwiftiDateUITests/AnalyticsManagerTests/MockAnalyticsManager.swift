//
//  MockAnalyticsManager.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/1.
//

import Foundation
@testable import SwiftiDate

// 測試替身
class MockAnalyticsManager: AnalyticsManagerProtocol {
    var trackedEvents: [(event: String, parameters: [String: Any]?)] = []
    
    func trackEvent(_ event: String, parameters: [String: Any]?) {
        trackedEvents.append((event: event, parameters: parameters))
    }
}
