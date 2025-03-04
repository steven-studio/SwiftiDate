//
//  AnalyticsManager.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/28.
//

import Foundation
// 如果要整合 Firebase Analytics:
import FirebaseAnalytics
import Mixpanel

class AnalyticsManager: AnalyticsManagerProtocol {
    static var shared = AnalyticsManager()

    private init() {
        // 若需要在這裡做額外初始化可加，如 FirebaseApp.configure() 等
        
        // 初始化 Mixpanel
        Mixpanel.initialize(token: "c33a19b0b1c17db46731337f2bc233da", trackAutomaticEvents: true)
    }
    
    /// 追蹤事件的統一方法
    @objc dynamic func trackEvent(_ eventName: String, parameters: [String: Any]? = nil) {
        // Firebase
        Analytics.logEvent(eventName, parameters: parameters)
        
        // Mixpanel
        let mixpanelProps = convertToMixpanelProperties(parameters)
        Mixpanel.mainInstance().track(event: eventName, properties: mixpanelProps)
        
        print("Tracking Event: \(eventName), params: \(parameters ?? [:])")
    }
    
    func convertToMixpanelProperties(_ dictionary: [String: Any]?) -> Properties {
        guard let dictionary = dictionary else { return [:] }

        var result: Properties = [:]
        for (key, value) in dictionary {
            // 檢查 value 是否符合 MixpanelType (String, Int, Double, Bool, Date, etc.)
            if let v = value as? MixpanelType {
                result[key] = v
            } else {
                // 如果是其他型別，視需求決定要 skip 還是做某種轉換
                // 這裡示範直接略過
                print("Warning: Skip \(key) because \(value) is not MixpanelType")
            }
        }
        return result
    }
}
