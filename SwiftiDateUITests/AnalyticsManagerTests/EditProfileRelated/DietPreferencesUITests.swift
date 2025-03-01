//
//  DietPreferencesUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/1.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

final class DietPreferencesUITests: XCTestCase {
    var analyticsSpy: AnalyticsSpy!
    
    override func setUp() {
        super.setUp()
        analyticsSpy = AnalyticsSpy()
        // 利用 swizzling 攔截 trackEvent 呼叫
        AnalyticsManager.swizzleTrackEvent(with: analyticsSpy)
    }
    
    override func tearDown() {
        // 還原交換，避免影響其他測試
        AnalyticsManager.unswizzleTrackEvent()
        analyticsSpy = nil
        super.tearDown()
    }
    
    func testDietPreferenceSelectionAndConfirmation() throws {
        // 建立 binding，初始為 nil
        var selectedPreference: String? = nil
        let binding = Binding<String?>(
            get: { selectedPreference },
            set: { selectedPreference = $0 }
        )
        
        // 建立 view
        let view = DietPreferencesView(selectedDietPreference: binding)
        ViewHosting.host(view: view)
        
        // 由於 onAppear 會觸發頁面曝光事件，這裡我們只關注使用者互動的部分
        
        // 模擬點擊「素食」按鈕
        let optionButton = try view.inspect().find(button: "素食")
        try optionButton.tap()
        XCTAssertEqual(selectedPreference, "素食", "binding 應該更新為 '素食'")
        
        // 驗證已記錄 "diet_preference_selected" 事件
        if let event = analyticsSpy.trackedEvents.first(where: { $0.event == "diet_preference_selected" }) {
            XCTAssertEqual(event.parameters?["option"] as? String, "素食", "參數 'option' 不正確")
        } else {
            XCTFail("沒有觸發 diet_preference_selected 事件")
        }
        
        // 測試「清空」功能：點擊「清空」按鈕
        let clearButton = try view.inspect().find(button: "清空")
        try clearButton.tap()
        XCTAssertNil(selectedPreference, "清空操作後，binding 應該為 nil")
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "diet_preference_cleared" }),
                      "沒有觸發 diet_preference_cleared 事件")
        
        // 測試「確認」功能：先選擇「從不挑食」，再點擊「確定」
        let newOptionButton = try view.inspect().find(button: "從不挑食")
        try newOptionButton.tap()
        XCTAssertEqual(selectedPreference, "從不挑食", "binding 應該更新為 '從不挑食'")
        
        let confirmButton = try view.inspect().find(button: "確定")
        try confirmButton.tap()
        if let confirmEvent = analyticsSpy.trackedEvents.first(where: { $0.event == "diet_preference_confirmed" }) {
            XCTAssertEqual(confirmEvent.parameters?["selected"] as? String, "從不挑食", "確認的參數不正確")
        } else {
            XCTFail("沒有觸發 diet_preference_confirmed 事件")
        }
    }
}
