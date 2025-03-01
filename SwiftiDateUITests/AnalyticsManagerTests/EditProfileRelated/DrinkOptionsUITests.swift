//
//  DrinkOptionsUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/1.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

final class DrinkOptionsUITests: XCTestCase {
    var analyticsSpy: AnalyticsSpy!
    
    override func setUp() {
        super.setUp()
        analyticsSpy = AnalyticsSpy()
        // 利用 swizzling 攔截 AnalyticsManager.shared 的 trackEvent 呼叫
        AnalyticsManager.swizzleTrackEvent(with: analyticsSpy)
    }
    
    override func tearDown() {
        // 還原方法交換，避免影響其他測試
        AnalyticsManager.unswizzleTrackEvent()
        analyticsSpy = nil
        super.tearDown()
    }
    
    func testDrinkOptionsInteractions() throws {
        // 建立 binding，初始為 nil
        var selectedDrink: String? = nil
        let binding = Binding<String?>(
            get: { selectedDrink },
            set: { selectedDrink = $0 }
        )
        
        // 建立 view 並上線
        let view = DrinkOptionsView(selectedDrinkOption: binding)
        ViewHosting.host(view: view)
        
        // 測試 onAppear 是否觸發頁面曝光事件 "drink_options_view_appear"
        let appearEvent = analyticsSpy.trackedEvents.first(where: { $0.event == "drink_options_view_appear" })
        XCTAssertNotNil(appearEvent, "應該觸發 drink_options_view_appear 事件")
        
        // 模擬點擊某個飲酒選項，例如「只在社交場合」
        let optionButton = try view.inspect().find(button: "只在社交場合")
        try optionButton.tap()
        XCTAssertEqual(selectedDrink, "只在社交場合", "點擊後，binding 應更新為 '只在社交場合'")
        
        // 驗證事件 "drink_option_selected" 是否有正確上報，且參數包含所選選項
        let selectedEvent = analyticsSpy.trackedEvents.first(where: {
            $0.event == "drink_option_selected" &&
            ($0.parameters?["option"] as? String) == "只在社交場合"
        })
        XCTAssertNotNil(selectedEvent, "應該觸發 drink_option_selected 事件並傳入正確參數")
        
        // 測試「清空」按鈕：點擊後 binding 應變為 nil
        let clearButton = try view.inspect().find(button: "清空")
        try clearButton.tap()
        XCTAssertNil(selectedDrink, "點擊清空後，binding 應為 nil")
        
        let clearEvent = analyticsSpy.trackedEvents.first(where: { $0.event == "drink_option_cleared" })
        XCTAssertNotNil(clearEvent, "應該觸發 drink_option_cleared 事件")
        
        // 測試「確定」按鈕：先選擇另一個選項，再點擊確定，檢查上報事件與參數
        let notDrinkButton = try view.inspect().find(button: "不喝酒")
        try notDrinkButton.tap()
        XCTAssertEqual(selectedDrink, "不喝酒", "點擊後，binding 應更新為 '不喝酒'")
        
        let confirmButton = try view.inspect().find(button: "確定")
        try confirmButton.tap()
        let confirmEvent = analyticsSpy.trackedEvents.first(where: {
            $0.event == "drink_option_confirmed" &&
            ($0.parameters?["option"] as? String) == "不喝酒"
        })
        XCTAssertNotNil(confirmEvent, "應該觸發 drink_option_confirmed 事件並傳入正確參數")
    }
}
