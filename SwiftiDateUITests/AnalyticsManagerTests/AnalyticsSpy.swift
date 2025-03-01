//
//  AnalyticsSpy.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/1.
//

import Foundation

class AnalyticsSpy: AnalyticsManagerProtocol {
    var trackedEvents: [(event: String, parameters: [String: Any]?)] = []
    
    func trackEvent(_ event: String, parameters: [String : Any]? = nil) {
        trackedEvents.append((event: event, parameters: parameters))
    }
}
