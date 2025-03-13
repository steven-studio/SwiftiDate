//
//  AnalyticsManager+Swizzle.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/1.
//

import Foundation
import ObjectiveC

extension AnalyticsManager {
    private static var spyKey = "analyticsSpyKey"
    
    // 透過關聯物件存取 spy
    var analyticsSpy: AnalyticsSpy? {
        get { return objc_getAssociatedObject(self, &AnalyticsManager.spyKey) as? AnalyticsSpy }
        set { objc_setAssociatedObject(self, &AnalyticsManager.spyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    // 替換 trackEvent 的方法
    @objc dynamic func swizzled_trackEvent(_ event: String, parameters: [String: Any]? = nil) {
        // 先讓 spy 記錄事件
        analyticsSpy?.trackedEvents.append((event: event, parameters: parameters))
        // 呼叫原本的實作（因為我們會交換實作，所以呼叫 swizzled_trackEvent 就相當於原本的 trackEvent）
        swizzled_trackEvent(event, parameters: parameters)
    }
    
    // 執行交換
    static func swizzleTrackEvent(with spy: AnalyticsSpy) {
        let originalSelector = #selector(AnalyticsManager.trackEvent(_:parameters:))
        let swizzledSelector = #selector(AnalyticsManager.swizzled_trackEvent(_:parameters:))
        
        guard let originalMethod = class_getInstanceMethod(AnalyticsManager.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(AnalyticsManager.self, swizzledSelector) else {
            return
        }
        
        // 設定 spy 到 shared 物件上
        AnalyticsManager.shared.analyticsSpy = spy
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    // 還原交換
    static func unswizzleTrackEvent() {
        let originalSelector = #selector(AnalyticsManager.trackEvent(_:parameters:))
        let swizzledSelector = #selector(AnalyticsManager.swizzled_trackEvent(_:parameters:))
        
        guard let originalMethod = class_getInstanceMethod(AnalyticsManager.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(AnalyticsManager.self, swizzledSelector) else {
            return
        }
        method_exchangeImplementations(swizzledMethod, originalMethod)
    }
}
